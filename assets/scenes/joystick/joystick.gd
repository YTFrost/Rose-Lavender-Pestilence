extends Control

var is_pressed := false;
var heading := 0.0;
var speed := 0.0;

const center := Vector2(100, 100);
const dead_zone := 0.2;
const max_dist := 100;

func _gui_input(event: InputEvent) -> void:
	if(event is InputEventMouseButton):
		if(event.is_pressed()):
			is_pressed = true;
			if(cos(heading) > 0.2): Input.action_press("walk_up", cos(heading));
			if(-cos(heading) > 0.2): Input.action_press("walk_down", -cos(heading));
			if(-sin(heading) > 0.2): Input.action_press("walk_right", -sin(heading));
			if(sin(heading) > 0.2): Input.action_press("walk_left", sin(heading));
		elif(event.is_released()):
			is_pressed = false;
			Input.action_release("walk_up");
			Input.action_release("walk_down");
			Input.action_release("walk_left");
			Input.action_release("walk_right");
	
	if(event is InputEventMouseMotion and is_pressed):
		if(cos(heading) > 0.2): Input.action_press("walk_up", cos(heading));
		if(-cos(heading) > 0.2): Input.action_press("walk_down", -cos(heading));
		if(-sin(heading) > 0.2): Input.action_press("walk_right", -sin(heading));
		if(sin(heading) > 0.2): Input.action_press("walk_left", sin(heading));
	
	update_control(event.position);

func update_control(click_position : Vector2):
	heading = (click_position-center).angle_to(Vector2.UP);
	speed = max(min(center.distance_to(click_position), max_dist)/100.0, 0.2);
	if(is_pressed):
		$joystick.position = center + Vector2.UP.rotated(-heading) * max_dist * speed - Vector2(32, 32);
	else: $joystick.position = center - Vector2(32, 32);
