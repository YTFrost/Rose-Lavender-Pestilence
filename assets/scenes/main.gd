extends Node3D

func _on_male_character_patient_info_requested(patient: RigidBody3D) -> void:
	show_patient_info(patient);

func show_patient_info(patient: RigidBody3D) -> void:
	var patient_info_scene : PackedScene = load("res://assets/scenes/patient_info/patient_info.tscn");
	var patient_info_instance : Control = patient_info_scene.instantiate();
	add_child(patient_info_instance);
	patient_info_instance.slide_in();
	patient_info_instance.load_patient_info(patient);
