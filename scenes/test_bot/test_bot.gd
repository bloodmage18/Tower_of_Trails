extends KinematicBody

var curHp : int = 5
var maxHp : int = 5

var direction = Vector3.FORWARD
var velocity = Vector3.ZERO

var vertical_velocity = 0
var gravity = 20

var movement_speed = 0
export var walk_speed = 5.25
export var run_speed = 25
export var acceleration = 6
export var angular_acceleration = 7

onready var body = get_node("body")

var damage = 1

#onready var ui = get_node("CanvasLayer/Ui")

func _ready():
	pass
#	ui.update_health_bar(curHp, maxHp)
	

func _input(event):
	pass	

func _physics_process(delta):
	
	if Input.is_action_pressed("move_forward") || Input.is_action_pressed("move_backward")|| Input.is_action_pressed("move_left")|| Input.is_action_pressed("move_right") :
		
		var h_rot = $cam_rot/h.global_transform.basis.get_euler().y
		
		direction = Vector3(Input.get_action_strength("move_left") - Input.get_action_strength("move_right"),
					0,
					Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")).rotated(Vector3.UP, h_rot).normalized()

		if Input.is_action_pressed("sprint"):
			movement_speed = run_speed
		else:
			movement_speed = walk_speed
	else:
		movement_speed = 0
	
	velocity = lerp(velocity, direction * movement_speed, delta * acceleration)

	move_and_slide(velocity + Vector3.DOWN * vertical_velocity, Vector3.UP)
	
	if !is_on_floor():
		vertical_velocity += gravity * delta
	else:
		vertical_velocity = 0
		
	body.rotation.y = lerp_angle(body.rotation.y, atan2(direction.x, direction.z), delta * angular_acceleration)
	
