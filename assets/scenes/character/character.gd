extends Node3D

var heading := Vector3.FORWARD;
@export var walk_speed := 8.0;
@export var rotate_speed := 3*PI;
@onready var animation_player : AnimationPlayer = $AnimationPlayer;

func _process(delta: float) -> void:
	var flat_heading = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down", 0.2);
	var new_heading = Vector3(flat_heading.x, 0.0, flat_heading.y);
	heading = heading.normalized();
	heading = new_heading;
	if(heading != Vector3.ZERO):
		position += heading * walk_speed * delta;
		animation_player.play("walk");
		update_rotation(delta);
	else:
		animation_player.pause();

func update_rotation(delta: float) -> void:
	var rotation_vector := Vector3.FORWARD.rotated(Vector3.UP, rotation.y);
	var heading_difference := heading.signed_angle_to(rotation_vector, Vector3.DOWN);
	rotation.y += clampf(heading_difference, -rotate_speed*delta, rotate_speed*delta);
