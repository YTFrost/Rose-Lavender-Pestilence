extends Node3D

var world_time := TimeTracker.new();

func _ready() -> void:
	world_time.twenty_four_hour_format = false;

func _on_male_character_patient_info_requested(patient: RigidBody3D) -> void:
	show_patient_info(patient);

func show_patient_info(patient: RigidBody3D) -> void:
	var patient_info_scene : PackedScene = load("res://assets/scenes/patient_info/patient_info.tscn");
	var patient_info_instance : Control = patient_info_scene.instantiate();
	add_child(patient_info_instance);	
	patient_info_instance.load_patient_info(patient);
	patient.patient_info_updated.connect(patient_info_instance.load_patient_info);

func _on_world_timer_timeout():
	world_time.update();
	$TimeUi.set_time(world_time);
