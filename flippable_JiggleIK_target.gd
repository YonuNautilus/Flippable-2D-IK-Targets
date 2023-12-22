@tool
extends Marker2D
class_name FlippableJiggleIKTarget
## A script used to help a single Bone2D jiggle joint behavior correctly when the parent
## tree is flipped on the x axis
##
##

@export var bone: Bone2D
@export var active = true
@export var active_in_editor = true
@export var target_lines_on: = false



var flipped:
	get: return bone.global_scale.x * bone.global_scale.y < 0

var face:
	get: return -1 if flipped else 1


func _process(delta):
	calculate()
	

func calculate():
	if bone and (active_in_editor or not Engine.is_editor_hint()):
		print(rad_to_deg(bone.rotation))
		if flipped:
			pass
