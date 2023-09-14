extends KinematicBody

signal kill_count_plus

onready var parent = get_parent()


#keeping it ismple


func _ready():
	pass

func die():
	queue_free()

func _on_Area_body_entered(body):
	if body.is_in_group("player") && parent.can_hunt == true:
		emit_signal("kill_count_plus")
		die()
	else :
		pass #should have made this a rigid body
