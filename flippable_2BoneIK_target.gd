@tool
extends Marker2D
class_name Flippable2BoneIKTarget

##The second bone of the 2-bone chain
@export var end_bone: Bone2D
@export var min_buffer = 1.0
@export var max_buffer = 1.0
##If the joint should bend the other way
@export var flip_joint = false
@export var active = true
@export var active_in_editor = true
##True if there is a third bone after end_bone that is not part of the IK chain
@export var has_extra_bone = false
##True if the rotation of the extra bone should follow the rotation of the target marker
@export var extra_bone_follow_rotation = false
##True if this 2Bone IK is attached to another 2BoneIK
@export var is_flippable_child = false

var flipped:
	get: return end_bone.global_scale.x * end_bone.global_scale.y < 0


var face:
	get: return -1 if flipped else 1


func _process(_delta):
	if active:
		calculate()
	

func calculate():
	if end_bone and (active_in_editor or not Engine.is_editor_hint()):

		#get length of end bone and its square
		var end_length = end_bone.get_length() * abs(end_bone.global_scale.y)
		var end_sqr = end_length * end_length
		
		#get length of start bone and its square
		var start_bone = end_bone.get_parent()
		var start_length = start_bone.get_length() * abs(start_bone.global_scale.y)
		var start_sqr = start_length * start_length
		
		#get offset between start bone and IK marker (Vector2)
		var target_offset = global_position - start_bone.global_position
		
		#get a target length value, clamping that vector's length between 2 values:
		#	1. difference of end bone length and start bone length (floor of 0) plus min_buffer
		#	2. sum of 2 bone lengths minus max_buffer
		#get the square of that length
		var target_length = clamp(target_offset.length(), max(0, end_length - start_length) + min_buffer, end_length + start_length - max_buffer)
		var target_sqr = target_length * target_length
		
		#get the intended angle of the start bone (inverse cosine (input is adjascent over hypotenuse))
		#	- where adjascent leg is target square plus start square minus end square
		#	- where hypotenuse is 2 times the start length times the target length
		var start_target_angle = acos((target_sqr + start_sqr - end_sqr) / (2 * start_length * target_length)) * face
		var end_target_angle = acos((end_sqr + start_sqr - target_sqr) / (2 * end_length * start_length)) * face
		
		#get the angle of that offset
		var at = atan2(target_offset.y, target_offset.x)
		
		if flipped:
			if is_flippable_child:
				var parent_bone : Bone2D = start_bone.get_parent()
				start_bone.position.x = -parent_bone.get_length()
			
			if flip_joint:
				start_bone.global_rotation = at + start_target_angle
				end_bone.rotation = -end_target_angle
			else:
				start_bone.global_rotation = at - start_target_angle
				end_bone.rotation = end_target_angle
			
			for child in end_bone.get_children():
				if child is Sprite2D:
					child.rotation = PI
				if has_extra_bone:
					if child is Bone2D:
						child.position.x = -end_bone.get_length()
						if !extra_bone_follow_rotation:
							child.rotation = PI
						else:
							child.rotation = rotation + PI

		else:
			if is_flippable_child:
				var parent_bone : Bone2D = start_bone.get_parent()
				start_bone.position.x = parent_bone.get_length()
			
			if flip_joint:
				start_bone.global_rotation = at + start_target_angle
				end_bone.rotation = PI + end_target_angle
			else:
				start_bone.global_rotation = at - start_target_angle
				end_bone.rotation = PI - end_target_angle

			for child in end_bone.get_children():
				if child is Sprite2D:
					child.rotation = 0
				if has_extra_bone:
					if child is Bone2D:
						child.position.x = end_bone.get_length()
						if !extra_bone_follow_rotation:
							child.rotation = 0
						else:
							child.rotation = rotation
