extends Node3D

signal doctor_entered_area(doctor);
signal doctor_left_area(doctor);

@export var player_character : CharacterBody3D = null;
@export var alpha_curve : Curve;

func _process(delta) -> void:
	if(player_character == null): return;
	var alpha = alpha_curve.sample( player_character.position.distance_to(position) );
	$interact_plane.mesh.surface_get_material(0).set_shader_parameter("alpha_mod", alpha);

func _on_interaction_area_body_entered(body):
	if(body.get("type") == Character.DOCTOR):
		doctor_entered_area.emit(body);
		body.try_interact(self);

func _on_interaction_area_body_exited(body):
	if(body.get("type") == Character.DOCTOR):
		doctor_left_area.emit(body);
		body.try_clear_interaction(self);
