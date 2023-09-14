extends Node

class_name sub_quest

signal sub_quest_1_done

onready var can_accept_quest : bool = true
onready var quest_accepted : bool = false
onready var quest_completed : bool = false

onready var number_to_kill : int = 1

func _ready():
	can_accept_quest = true
	quest_completed = false


func _on_Mob_kill_count_plus():
	number_to_kill -= 1
	if number_to_kill == 0 :
		can_accept_quest = false
		quest_completed = true
		emit_signal("sub_quest_1_done")

