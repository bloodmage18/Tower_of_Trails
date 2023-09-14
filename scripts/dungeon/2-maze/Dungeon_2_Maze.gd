extends Spatial

onready var survival_set_time = get_node("Survival/Set_Time")

onready var can_accept_quests : bool = true
onready var quest_completed : bool = false

onready var Hunter_quest = get_node("Sub_Quests/Hunt") as sub_quest
onready var can_hunt = Hunter_quest.quest_accepted
onready var mob_kill_count : int = 0

onready var can_accept_sub_quests : bool = true

enum {quests,SURVIVAL,TRAVERSAL}
var state = quests # does nothing - just for fun

func _ready():
	print("Quests Available : ")
	print(" A - Survival ")
	print(" B - Traversal")
	
	mob_kill_count = 0
	
func _physics_process(delta):
	
	if Hunter_quest.can_accept_quest == true :
		can_accept_sub_quests = true
	else:
		can_accept_sub_quests = false

	
	match state:
		quests:
			if quest_completed == false:
				can_accept_quests = true
				#it works
		SURVIVAL:
			can_accept_quests = false
			
		TRAVERSAL:
			can_accept_quests = false
			


func _on_Set_Time_timeout():
	if state == SURVIVAL :
		print("CONGRATULATIONS FOR SURVIVING THE TRIAL : " )
		quest_completed = true
		state = quests
	#keeping it simple


func _on_Area_body_entered(body):
#	if body.name == "test_bot":
# my mind literally went blank
	if body.is_in_group("player") && can_accept_quests == true:
		print("survival quest selected : survive for - " , survival_set_time.wait_time , "seconds")
		state = SURVIVAL
		survival_set_time.start()


func _on_Start_point_body_entered(body) :
	if body.is_in_group("player") && can_accept_quests == true:
		print("Traversal quest selected : Get to End Gate ")
		state = TRAVERSAL


func _on_End_point_body_entered(body):
	if body.is_in_group("player") && state == TRAVERSAL:
		print("Traversal Quest Completed")
		quest_completed = true
		state = quests
		
		#see easy as pie , though making pie isnt easy

func _on_Hunt_sub_quest_1_done():
	print("sub_quest - Hunter COMPLETED")


func _on_None_body_entered(body):
	if body.is_in_group("player") && can_accept_sub_quests:
		print("declined all sub quest scenarios ")
		get_node("Sub_Quests/Hunt").can_accept_quest = false
		get_node("Sub_Quests/Hunt").quest_completed = false 


func _on_Huntersubquest_body_entered(body):
	if body.is_in_group("player") && Hunter_quest.can_accept_quest == true && Hunter_quest.quest_completed == false:
		print("hunter quest accepted ")
		print("number of mob left : " , Hunter_quest.number_to_kill)
		can_hunt = true
		Hunter_quest.can_accept_quest = false


func _on_Huntedsub_quest_body_entered(body):
	pass # Replace with function body.
