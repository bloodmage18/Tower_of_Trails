extends Node
class_name Quest_Manager

# Enum to categorize quests
enum QuestType {
	MAIN_SURVIVE,
	MAIN_ESCAPE,
	SUB_HUNT,
	SUB_HUNTED,
	SUB_NONE
	}

# Constants for quest types
#const MAIN_SURVIVE = 0
#const MAIN_ESCAPE = 1
#const SUB_HUNT = 2
#const SUB_HUNTED = 3
#const SUB_NONE = 4


# Main quest variables
var surviveTimer: Timer
var keysCollected: int = 0
var requiredKeys: int = 3
var exitDoor: Area

# Sub quest variables
var huntNpcs: Array = []
var huntedNpcs: Array = []
var huntedPlayer: bool = false
var huntedPlayerArea: Area
var huntCounter: int = 0
var requiredHuntCount: int = 5

func _ready():
	# Initialize and connect signals
	surviveTimer = $Main_Quests/Survival/survivalTimer
	exitDoor = $Main_Quests/Traversal/End_point
	huntedPlayerArea = $"Sub_Quests/Hunted-sub_quest"
	
	surviveTimer.connect("timeout", self, "_on_SurviveTimerTimeout")
	exitDoor.connect("body_entered", self, "_on_ExitDoorEntered")
	huntedPlayerArea.connect("body_entered", self, "_on_HuntedPlayerEntered")
	
	# Start the main quest (Survive)
#	startMainQuest(QuestType.MAIN_SURVIVE)

func startMainQuest(questType):
	match questType:
		QuestType.MAIN_SURVIVE:
			# Start the timer for survival
			surviveTimer.start()
		
		QuestType.MAIN_ESCAPE:
			# Initialize exit door and key logic
			exitDoor.disabled = true
			keysCollected = 0

func completeMainQuest(questType):
	match questType:
		QuestType.MAIN_SURVIVE:
			# Handle survival quest completion
			surviveTimer.stop()
			print("Survival quest completed!")
		
		QuestType.MAIN_ESCAPE:
			# Handle escape quest completion
			exitDoor.disabled = false
			print("Escape quest completed!")

func startSubQuest(questType):
	match questType:
		QuestType.SUB_HUNT:
			# Initialize and spawn hunt NPCs
			huntNpcs = get_tree().get_nodes_in_group("hunt_npc")
			huntCounter = 0
		
		QuestType.SUB_HUNTED:
			# Initialize hunted NPCs and player hunted state
			huntedNpcs = get_tree().get_nodes_in_group("hunted_npc")
			huntedPlayer = false
			huntedPlayerArea.monitoring = true
			huntedPlayerArea.set_monitorable_area(huntedNpcs[0]) # Adjust this based on your game logic

func completeSubQuest(questType):
	match questType:
		QuestType.SUB_HUNT:
			# Handle hunt quest completion
			print("Hunt subquest completed!")
		
		QuestType.SUB_HUNTED:
			# Handle hunted quest completion
			huntedPlayerArea.monitoring = false
			print("Hunted subquest completed!")

func _on_SurviveTimerTimeout():
	# Handle survival quest failure
	print("Survival quest failed!")
	startMainQuest(QuestType.MAIN_SURVIVE) # Restart the quest

func _on_ExitDoorEntered(body):
	# Check if the player has collected enough keys
	if body.is_in_group("player") and keysCollected >= requiredKeys:
		print("Exit door unlocked!")
		completeMainQuest(QuestType.MAIN_ESCAPE)

func _on_HuntedPlayerEntered(body):
	# Handle player being hunted
	if body.is_in_group("player"):
		huntedPlayer = true
		print("Player is being hunted!")

func onHuntNpcDefeated():
	# Called when a hunt NPC is defeated
	huntCounter += 1
	print("Hunted NPCs defeated: ", huntCounter)
	if huntCounter >= requiredHuntCount:
		completeSubQuest(QuestType.SUB_HUNT)

func onHuntedNpcCaughtPlayer():
	# Called when a hunted NPC catches the player
	huntedPlayer = true
	print("Player caught by a hunted NPC!")

func skipSubQuest(questType):
	# Allow players to skip subquests if they choose
	match questType:
		QuestType.SUB_HUNT:
			print("Hunt subquest skipped!")
			completeSubQuest(QuestType.SUB_HUNT)
		
		QuestType.SUB_HUNTED:
			print("Hunted subquest skipped!")
			completeSubQuest(QuestType.SUB_HUNTED)

# Add any additional functions or signals as needed




func _on_Survival_Gate_body_entered(body):
	if body.is_in_group("Player"):
		startMainQuest(QuestType.MAIN_SURVIVE)
	
func _on_Escape_Gate_body_entered(body):
	if body.is_in_group("Player"):
		startMainQuest(QuestType.MAIN_ESCAPE)
