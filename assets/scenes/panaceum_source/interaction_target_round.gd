extends "res://assets/scenes/interaction_target/interaction_target.gd"

signal doctor_grabbed_panaceum(bed, doctor);

func interact(doctor: CharacterBody3D):
	doctor.interaction_progress = 0.0;
	doctor_grabbed_panaceum.emit(self, doctor);
