extends RigidBody3D

signal patient_info_requested(patient: RigidBody3D);

@export var patient_name := "Mirosław";
@export var patient_surname := "Zimoch";
@export var life := 100;
@export var temperature := 0;
@export var moisture := 0;
@export var blood := 25;
@export var phlegm := 25;
@export var gall := 25;
@export var melancholy := 25;
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
