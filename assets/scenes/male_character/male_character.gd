extends RigidBody3D

signal patient_info_requested(patient: RigidBody3D);
signal patient_info_updated(patient: RigidBody3D);

const MAX_SWING := 2.0;

@export var patient_name := "Mirosław";
@export var patient_surname := "Zimoch";
@export var life := 100.0;
@export var temperature := 0.0;
@export var moisture := 0.0;
@export var blood := 25.0;
@export var phlegm := 25.0;
@export var gall := 25.0;
@export var melancholy := 25.0;
@export var afflictions : Array = [];
var type := Character.PATIENT;
var button : Control = null;
var doctor : CharacterBody3D = null;

func show_info_button(new_doctor):
	var button_scene := load("res://assets/scenes/button_patient/button_patient.tscn");
	var button_instance : Control = button_scene.instantiate();
	button_instance.parent = self;
	button_instance.camera = new_doctor.camera_node;
	button_instance.button_pressed.connect(on_button_pressed);
	add_child(button_instance);
	button = button_instance;
	doctor = new_doctor;

func hide_info_button(new_doctor):
	button.queue_free();
	button = null;

func on_button_pressed(button: Control):
	patient_info_requested.emit(self);

func _on_update_timer_timeout() -> void:
	var heat_delta = (temperature / 100.0) * MAX_SWING
	var moist_delta = (moisture / 100.0) * MAX_SWING

	# Apply heat influence
	blood += heat_delta
	gall += heat_delta
	phlegm -= heat_delta
	melancholy -= heat_delta

	# Apply moisture influence
	blood += moist_delta
	gall -= moist_delta
	phlegm += moist_delta
	melancholy -= moist_delta

	# Prevent negative humors
	blood = max(blood, 0.0)
	gall = max(gall, 0.0)
	phlegm = max(phlegm, 0.0)
	melancholy = max(melancholy, 0.0)

	# Normalize so total = 100
	var total = blood + gall + phlegm + melancholy
	if total > 0.0:
		var scale = 100.0 / total
		blood *= scale
		gall *= scale
		phlegm *= scale
		melancholy *= scale

	# Dampen qualities
	temperature *= 0.98
	moisture *= 0.98
	
	patient_info_updated.emit(self);

func update_afflictions() -> void:
	pass;
