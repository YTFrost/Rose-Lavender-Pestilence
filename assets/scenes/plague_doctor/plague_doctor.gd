extends CharacterBody3D

signal inventory_changed(item_count: int);

var heading := Vector3.FORWARD;
var item_count := 0;
@export var walk_speed := 8;
@export var rotate_speed := 3*PI;
@onready var animation_player : AnimationPlayer = $AnimationPlayer;

func _process(delta: float) -> void:
	var flat_heading = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down", 0.2);
	heading = Vector3(flat_heading.x, 0.0, flat_heading.y);
	if(flat_heading != Vector2.ZERO):
		velocity.x = flat_heading.x * walk_speed;
		velocity.z = flat_heading.y * walk_speed;
		if(velocity.length() < walk_speed/2): animation_player.play("walk", 0.5, velocity.length() / (walk_speed/2));
		else: animation_player.play("run", 0.5, velocity.length() / walk_speed);
		update_rotation(delta);
	else:
		velocity.x = 0.0;
		velocity.z = 0.0;
		animation_player.play("idle");
	velocity.y = velocity.y - 98.1 * delta;
	move_and_slide();

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
