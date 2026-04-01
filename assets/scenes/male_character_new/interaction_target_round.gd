extends "res://assets/scenes/interaction_target/interaction_target.gd"

signal doctor_inspected_patient(target: Node3D, doctor: Node3D);

func interact(doctor: Node3D) -> void:
	doctor_inspected_patient.emit(self, doctor);
