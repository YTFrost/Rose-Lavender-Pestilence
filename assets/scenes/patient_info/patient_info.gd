extends Control

func load_patient_info(patient: RigidBody3D) -> void:
	$ContainerBackground/ContentContainer/Name.text = "%s %s" % [patient.patient_name, patient.patient_surname];

func slide_in() -> void:
	anchor_left = 1.0;
	var tween := get_tree().create_tween();
	tween.tween_property(self, "anchor_left", 0.5, 0.5);
	tween.set_trans(Tween.TRANS_CIRC);
	tween.set_ease(Tween.EASE_IN_OUT);
