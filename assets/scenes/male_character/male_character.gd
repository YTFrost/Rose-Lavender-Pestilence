extends RigidBody3D

signal patient_info_requested(patient: RigidBody3D);
signal patient_info_updated(patient: RigidBody3D);

const MAX_SWING := 2.0;

@export var patient_name := "Mirosław";
@export var patient_surname := "Zimoch";
@export var life := 100.0;
@export var temperature := 0.0;
@export var moisture := 0.0;
@export var blood : HumorState = HumorState.new(HumorState.Type.BLOOD);
@export var gall : HumorState = HumorState.new(HumorState.Type.GALL);
@export var phlegm : HumorState = HumorState.new(HumorState.Type.PHLEGM);
@export var melancholy : HumorState = HumorState.new(HumorState.Type.MELANCHOLY);
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

func hide_info_button(_new_doctor):
	button.queue_free();
	button = null;

func on_button_pressed(_new_button: Control):
	patient_info_requested.emit(self);

func _on_update_timer_timeout() -> void:
	var heat_delta = (temperature / 100.0) * MAX_SWING
	var moist_delta = (moisture / 100.0) * MAX_SWING

	apply_temp_mod(heat_delta);
	apply_moist_mod(moist_delta);
	normalize_humors();
	update_afflictions();
	
	temperature *= 0.98
	moisture *= 0.98
	
	patient_info_updated.emit(self);

func apply_temp_mod(delta: float) -> void:
	blood.level += delta;
	gall.level += delta;
	phlegm.level -= delta;
	melancholy.level -= delta;

func apply_moist_mod(delta: float) -> void:
	blood.level += delta;
	phlegm.level += delta;
	gall.level -= delta;
	melancholy.level -= delta;

func normalize_humors() -> void:
	var total_humors := blood.level + phlegm.level + gall.level + melancholy.level;
	if( abs( 100.0 - total_humors ) > 0.01 ):
		blood.level = ( blood.level / total_humors ) * 100.0;
		phlegm.level = ( phlegm.level / total_humors ) * 100.0;
		gall.level = ( gall.level / total_humors ) * 100.0;
		melancholy.level = ( melancholy.level / total_humors ) * 100.0;

func update_afflictions() -> void:
	blood.update_afflictions();
	gall.update_afflictions();
	phlegm.update_afflictions();
	melancholy.update_afflictions();
	afflictions = blood.afflictions + gall.afflictions + phlegm.afflictions + melancholy.afflictions;
