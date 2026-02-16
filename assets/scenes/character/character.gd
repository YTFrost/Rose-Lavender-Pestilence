extends CharacterBody3D

signal inventory_changed(item_count: int);

var heading := Vector3.FORWARD;
var item_count := 0;
@export var walk_speed := 8.0;
@export var rotate_speed := 3*PI;
@onready var animation_player : AnimationPlayer = $AnimationPlayer;

func _process(delta: float) -> void:
	var flat_heading = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down", 0.2);
	var new_heading = Vector3(flat_heading.x, 0.0, flat_heading.y);
	heading = heading.normalized();
	heading = new_heading;
	if(heading != Vector3.ZERO):
		velocity = heading * walk_speed;
		animation_player.play("walk");
		update_rotation(delta);
		move_and_slide();
	else:
		animation_player.pause();

func update_rotation(delta: float) -> void:
	var rotation_vector := Vector3.FORWARD.rotated(Vector3.UP, rotation.y);
	var heading_difference := heading.signed_angle_to(rotation_vector, Vector3.DOWN);
	rotation.y += clampf(heading_difference, -rotate_speed*delta, rotate_speed*delta);

func can_get_items() -> bool:
	return $ActionTimer.is_stopped();

func can_take_items() -> bool:
	return item_count > 0 and $ActionTimer.is_stopped();

func get_item() -> void:
	item_count += 1;
	$ActionTimer.start();
	inventory_changed.emit(item_count);

func take_item() -> void:
	item_count -= 1;
	$ActionTimer.start();
	inventory_changed.emit(item_count);
