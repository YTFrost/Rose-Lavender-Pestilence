extends "res://assets/scenes/interaction_target/interaction_target.gd"

signal doctor_went_to_sleep(bed, doctor);

func interact(doctor: CharacterBody3D):
	doctor.interaction_lock = true;
	doctor_went_to_sleep.emit(self, doctor);
