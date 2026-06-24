extends "res://assets/scenes/items/item.gd"

func on_apply_remedy(patient: Node3D, doctor: Node3D):
	patient.data.blood.level = 25.0;
	patient.data.gall.level = 25.0;
	patient.data.phlegm.level = 25.0;
	patient.data.melancholy.level = 25.0;
	patient.normalize_humors();
