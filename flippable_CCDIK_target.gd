@tool
extends Marker2D
class_name FlippableCCDIKTarget
##A target modification similar to CCDIK or LookAt, with angle constraints.
##Useful for both setting and constraining the angle of a foot at the end of a leg 2-bone IK chain

@export var bone: Bone2D
@export var active = true
@export var active_in_editor = true
@export var upper_constraint: float = 0
@export var lower_constraint: float = 0
##True to show the constraining angles as lines.
##Red for upper contraint, blue for lower constraint
@export var target_lines_on: = false

var target_lines: Array[Line2D]

var flipped:
	get: return bone.global_scale.x * bone.global_scale.y < 0

var face:
	get: return -1 if flipped else 1

# Set up the debug lines, which show the upper (red) and lower (blue) angle constraints.
# Actually they are only "debug lines" when being drawn, but they actually represent the
# constraint angles
func _ready():
	for i in range(0, 2):
		var l = Line2D.new()
		l.position = bone.position
		l.add_point(Vector2.ZERO)
		l.add_point(Vector2(bone.position.x + 100, 0))
		l.width = 1.5
		l.visible = target_lines_on
		target_lines.append(l)
		bone.get_parent().add_child(l)
		if i == 0:
			l.rotation = deg_to_rad(upper_constraint)
			l.default_color = Color.RED
		elif i == 1:
			l.rotation = deg_to_rad(lower_constraint)
			l.default_color = Color.BLUE

func _process(_delta):
	if active:
		calculate()

func calculate():
	if bone and (active_in_editor or not Engine.is_editor_hint()):
		# First set the bone object to look at the target's position
		bone.look_at(to_global(position))

		"""
		Then set the angles of the target lines
		In the end we can use these lines's angles as the constraint values.
		Might be more efficient to just calculate them as their own
		variables rather than as Line2D objects, but for now this is fine.
		"""
		if flipped:
			bone.position.x = -bone.get_parent().get_length()
			for i in range(0, target_lines.size()):
				var l: Line2D = target_lines[i]
				l.position.x = -bone.get_parent().get_length()
				var target = 0
				if i == 0:
					target = deg_to_rad(upper_constraint)
				else:
					target = deg_to_rad(lower_constraint)
				l.rotation = target + PI
		else:
			bone.position.x = bone.get_parent().get_length()
			for i in range(0, target_lines.size()):
				var l: Line2D = target_lines[i]
				l.position.x = bone.get_parent().get_length()
				var target = 0
				if i == 0:
					target = deg_to_rad(upper_constraint)
				else:
					target = deg_to_rad(lower_constraint)
				l.rotation = target
		
		bone.rotation = clamp(bone.rotation, target_lines[0].rotation, target_lines[1].rotation)
		
		#print(
			#str(rad_to_deg(target_lines[0].rotation)) 
			#+ "\n\t" 
			#+ str(rad_to_deg(target_lines[1].rotation))
			#+ "\n\t\t"
			#+ str(rad_to_deg(bone.rotation)))
