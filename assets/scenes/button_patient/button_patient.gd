extends Control

signal button_pressed(button: Control);

var is_hovered := false;
var parent : RigidBody3D = null;
var camera : Camera3D = null;

func _process(delta: float) -> void:
	update_transparency();
	update_position();

func _on_button_patient_mouse_entered() -> void:
	var fade_in = get_tree().create_tween();
	fade_in.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.1);
	is_hovered = true;

func _on_button_patient_mouse_exited() -> void:
	var fade_out = get_tree().create_tween();
	fade_out.tween_property(self, "modulate", Color(1, 1, 1, get_target_alpha()), 0.1);
	fade_out.tween_property(self, "is_hovered", false, 0.0);

func _on_button_patient_pressed() -> void:
	button_pressed.emit(self);

func get_target_alpha() -> float:
	var dist = parent.doctor.position.distance_to(parent.position);
	return 1.0 - pow(dist/4.0, 2);

func update_transparency() -> void:
	if(parent == null): return;
	if(!is_hovered): modulate = Color(1, 1, 1, get_target_alpha());

func update_position() -> void:
	position = camera.unproject_position(parent.position + Vector3(0, 1.5, 0));
