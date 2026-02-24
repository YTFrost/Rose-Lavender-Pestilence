extends Node3D

func _process(_delta: float) -> void:
	$Camera3D.position = $PlagueDoctor.position + Vector3(0, 7, 4);
