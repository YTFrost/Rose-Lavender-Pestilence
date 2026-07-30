extends Node3D

@export var patient_schedule : PatientSchedule;

@export var world_time : TimeTracker;
var world_time_tween : Tween;
var current_skylight_progress := 12.0 - 1.0/60.0;

func _ready() -> void:
	world_time.twenty_four_hour_format = false;
	world_time.minutes_updated.connect(_on_minute_updated);
	update_skylight();

func _on_male_character_patient_info_requested(patient: RigidBody3D, doctor: Node3D) -> void:
	show_patient_info(patient, doctor);

func show_patient_info(patient: RigidBody3D, doctor: Node3D) -> void:
	var patient_info_scene : PackedScene = load("res://assets/scenes/patient_info/patient_info.tscn");
	var patient_info_instance : Control = patient_info_scene.instantiate();
	add_child(patient_info_instance);	
	patient_info_instance.load_patient_info(patient);
	patient_info_instance.load_remedies(doctor);
	patient.patient_info_updated.connect(patient_info_instance.load_patient_info);

func _on_world_timer_timeout():
	world_time.update();
	$TimeUi.set_time(world_time);

func _on_doctor_went_to_sleep(_bed: Variant, _doctor: Variant) -> void:
	$TimeUi.start_sleep();
	world_time_tween = get_tree().create_tween();
	world_time_tween.tween_property($WorldTimer, "wait_time", 1.0/30.0, 10);

func _on_time_ui_doctor_woke_up() -> void:
	if(world_time_tween.is_running()): world_time_tween.kill();
	$WorldTimer.wait_time = 1.0;
	$TimeUi.stop_sleep();
	$PlagueDoctor.reset_interaction();
	$PlagueDoctor.interaction_lock = false;

func _on_minute_updated(_minute: int) -> void:
	update_skylight();
	update_patient_arrival();

func spawn_patient(data: PatientData) -> void:
	var patient_scene : PackedScene = load("res://assets/scenes/male_character/male_character.tscn");
	var patient_instance := patient_scene.instantiate();
	patient_instance.data = data;
	patient_instance.get_node("InteractionTargetRound").player_character = $PlagueDoctor;
	add_child(patient_instance);

func update_skylight() -> void:
	var new_skylight_progress = world_time.hours + world_time.minutes/60.0;
	$AnimationPlayer.play_section("skylight_cycle", current_skylight_progress, new_skylight_progress);
	current_skylight_progress = new_skylight_progress;

func update_patient_arrival() -> void:
	var result = patient_schedule.get_arrival(world_time.hours, world_time.minutes);
	if(result != null): spawn_patient(result);

func _on_plague_doctor_picked_up_item(item: Node3D) -> void:
	$InventoryDisplay.add_item(item);
