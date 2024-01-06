@tool
extends Marker2D
class_name FlippableFABRIKTarget

@export var bone_datas : Array[FlippableFABRIKBone] = []

@export var nummerOfBones = 2
@export var start_bone: Bone2D
@export var end_bone: Bone2D
@export var min_buffer = 1.0
@export var max_buffer = 1.0
@export var flip_joint = false
@export var active = true
@export var active_in_editor = true

var boneArray = Array()
var flipped:
	get:
		var ret = end_bone.global_scale.x * end_bone.global_scale.y < 0
		#print(str(end_bone.global_scale.x) + ", " + str(end_bone.global_scale.y))
		#print(ret)
		return ret


var face:
	get: return -1 if flipped else 1

func _ready():
	boneArray.append(start_bone)
	
	var checkBone: Bone2D = start_bone
	
	#Child bones should always be at index 1 (because sprite is at index 0)
	while checkBone != end_bone:
		checkBone = checkBone.get_child(1)
		boneArray.append(checkBone)
		
	#print(boneArray.size())
	

func _process(_delta):
	if active:
		#print(position.x)
		calculate()
	

func calculate():
	if bone_datas and (active_in_editor or not Engine.is_editor_hint()):
		
		var original_global_pose = get_global_transform()

		for bonePart in bone_datas:
			var bone_length = bonePart.get_length() * abs(bonePart.global_scale.y)
			var bone_sqr = bone_length * bone_length
			
			var target_offet = global_position - bonePart.global_position
		
		var end_length = end_bone.get_length() * abs(end_bone.global_scale.y)
		var end_sqr = end_length * end_length
		
		var start_bone = bone_datas[0]
		var start_length = start_bone.get_length() * abs(start_bone.global_scale.y)
		var start_sqr = start_length * start_length
		
		var target_offset = global_position - start_bone.global_position
		
		var target_length = clamp(target_offset.length(), max(0, end_length - start_length) + min_buffer, end_length + start_length - max_buffer)
		var target_sqr = target_length * target_length
		
		var start_target_angle = acos((target_sqr + start_sqr - end_sqr) / (2 * start_length * target_length)) * face
		var end_target_angle = acos((end_sqr + start_sqr - target_sqr) / (2 * end_length * start_length)) * face
		
		var at = atan2(target_offset.y, target_offset.x)
		
		if flipped:
			if flip_joint:
				start_bone.global_rotation = at + start_target_angle
				end_bone.rotation = -end_target_angle
			else:
				start_bone.global_rotation = at - start_target_angle
				end_bone.rotation = end_target_angle
			
			for bonePart in bone_datas:
				for child in bonePart.get_children():
					if child is Sprite2D:
						child.rotation = PI
		else:
			if flip_joint:
				start_bone.global_rotation = at + start_target_angle
				end_bone.rotation = PI + end_target_angle
			else:
				start_bone.global_rotation = at - start_target_angle
				end_bone.rotation = PI - end_target_angle
			
			for child in end_bone.get_children():
				if child is Sprite2D:
					child.rotation = 0
