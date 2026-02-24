extends Control

const DEAD_ZONE := 0.2;

var center :
	get: return joystick_background.position + joystick_background.size/2;
var max_dist :
	get: return joystick_range.size.x/2;

@onready var joystick_background : TextureRect = $Background;
@onready var joystick_range : Control = $JoystickContainer;
@onready var joystick : TextureRect = $JoystickContainer/Joystick;

var is_pressed := false;
var heading := 0.0;
var speed := 0.0;

func _gui_input(event: InputEvent) -> void:
	if(event is InputEventMouseButton): handle_button(event);
	elif(event is InputEventMouseMotion): handle_motion(event);
	update_joystick_display();

func handle_button(event: InputEventMouseButton) -> void:
	recalculate(event);
	if(event.is_pressed()):
		is_pressed = true;
		check_and_press();
	elif(event.is_released()):
		is_pressed = false;
		check_and_release();

func handle_motion(event: InputEventMouseMotion) -> void:
	recalculate(event);
	if(is_pressed):
		check_and_press();
		check_and_release();

func recalculate(event : InputEvent) -> void:
	var translated_position = event.position - center;
	heading = translated_position.angle_to(Vector2.UP);
	speed = min(center.distance_to(event.position), max_dist)/max_dist;

func check_and_press() -> void:
	if(speed < DEAD_ZONE): return;
	var sine := sin(heading);
	var cosine := cos(heading);
	if(cosine > 0.0): Input.action_press("walk_up", speed*cosine);
	elif(cosine < 0.0): Input.action_press("walk_down", speed*-cosine);
	if(sine > 0.0): Input.action_press("walk_left", speed*sine);
	elif(sine < 0.0): Input.action_press("walk_right", speed*-sine);

func check_and_release() -> void:
	if(is_pressed):
		var sine := sin(heading);
		var cosine := cos(heading);
		if(Input.is_action_pressed("walk_up") and (cosine <= 0.0 or speed < DEAD_ZONE)): Input.action_release("walk_up");
		if(Input.is_action_pressed("walk_down") and (cosine >= 0.0 or speed < DEAD_ZONE)): Input.action_release("walk_down");
		if(Input.is_action_pressed("walk_left") and (sine <= 0.0 or speed < DEAD_ZONE)): Input.action_release("walk_left");
		if(Input.is_action_pressed("walk_right") and (sine >= 0.0 or speed < DEAD_ZONE)): Input.action_release("walk_right");
	else:
		Input.action_release("walk_up");
		Input.action_release("walk_down");
		Input.action_release("walk_left");
		Input.action_release("walk_right");

func update_joystick_display() -> void:
	if(is_pressed): joystick.position = joystick_range.size/2 + Vector2.UP.rotated(-heading) * max_dist * speed - joystick.size/2;
	else: joystick.position = joystick_range.size/2 - joystick.size/2;
