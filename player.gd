extends CharacterBody2D

@onready var idle_sheet = $"Idle-sheet"
@onready var run_sheet = $"Run-sheet"
@onready var jump_start_sheet = $"Jump-start-sheet"
@onready var jump_end_sheet = $"Jump-end-sheet"
@onready var animation_player = $AnimationPlayer

const RUN_SPEED := 200.0
const JUMP_VELOCITY := -400.0

var gravity := ProjectSettings.get('physics/2d/default_gravity') as float


func _sheet_factory(type: String) -> void:
	match type:
		"idle":
			idle_sheet.set_visible(true)
			run_sheet.set_visible(false)
			jump_start_sheet.set_visible(false)
			jump_end_sheet.set_visible(false)
		"run":
			idle_sheet.set_visible(false)
			run_sheet.set_visible(true)
			jump_start_sheet.set_visible(false)
			jump_end_sheet.set_visible(false)
		"jump_start":
			idle_sheet.set_visible(false)
			run_sheet.set_visible(false)
			jump_start_sheet.set_visible(true)
			jump_end_sheet.set_visible(false)
			
	animation_player.play(type)
	
func _unhandled_key_input(event) -> void:
	var key = event.as_text()
	if (key == "A" or key == "D") and event.is_released():
		idle_sheet.flip_h = key == "A"

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left","move_right")
	velocity.x = direction * RUN_SPEED
	velocity.y += gravity * delta
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
	
	if is_on_floor():
		if is_zero_approx(direction):
			_sheet_factory("idle")
		else:
			_sheet_factory("run")
	else:
		_sheet_factory("jump_start")
		
	if not is_zero_approx(direction):
		run_sheet.flip_h = direction < 0
		jump_start_sheet.flip_h = direction < 0
		
	move_and_slide()
