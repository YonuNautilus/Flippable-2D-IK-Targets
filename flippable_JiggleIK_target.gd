@tool
extends Marker2D
class_name FlippableJiggleIKTarget
## A script used to help a single Bone2D jiggle joint behavior correctly when the parent
## tree is flipped on the x axis
##
## @deprecated

@export var bone: Bone2D
@export var active = true
@export var active_in_editor = true



var flipped:
	get: return bone.global_scale.x * bone.global_scale.y < 0

var face:
	get: return -1 if flipped else 1


func _process(delta):
	if active:
		calculate()
	

func calculate():
	if bone and (active_in_editor or not Engine.is_editor_hint()):
		
		var sprite: Sprite2D
		for c in bone.get_children():
			if c is Sprite2D:
				sprite = c
		
		
		if flipped:
			if sprite:
				sprite.rotation = - deg_to_rad(-120)
		else:
			if sprite:
				sprite.rotation = 0
