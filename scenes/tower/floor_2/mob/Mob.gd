extends KinematicBody

signal kill_count_plus

onready var parent = get_parent()
var isHungry = false
var isHuntingPlayer = false
var target: Spatial = null
var speed: float = 2.0
var attackDistance: float = 2.0
var runDistance: float = 10.0
var health: int = 10
var maxHealth: int = 10
var homeBase: Spatial = null

func _ready():
	homeBase = find_home_base() # Implement home base lookup

func die():
	queue_free()

func _process(delta):
	if health <= 0:
		die()

	if isHungry:
		if target:
			move_towards_target()
		else:
			if isHuntingPlayer:
				target = find_player()
			else:
				target = find_food()

	if isHuntingPlayer and target and target.is_in_group("player"):
		move_towards_target()

	if target and target.is_in_group("player"):
		if target.global_transform.origin.distance_to(global_transform.origin) < attackDistance:
			attack(target)

func move_towards_target():
	if target:
		var direction = (target.global_transform.origin - global_transform.origin).normalized()
		move_and_slide(direction * speed)

func attack(target: Spatial):
	if target.is_in_group("player"):
		target.emit_signal("mob_attack", 1) # 1 represents mob damage
		return

	if target.is_in_group("food"):
		isHungry = false
		target.queue_free()

func find_home_base() -> Spatial:
	# Implement home base lookup logic here.
	# Return the Spatial node representing the home base.
	return null

func find_food() -> Spatial:
	# Implement food search logic here.
	# Return the Spatial node representing the food.
	return null

func find_player() -> Spatial:
	# Implement player search logic here.
	# Return the Spatial node representing the player.
	return null

func wander():
	# Implement random wandering behavior here.
	pass

func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		if isHuntingPlayer:
			target = body
		else:
			emit_signal("kill_count_plus")
			die()
