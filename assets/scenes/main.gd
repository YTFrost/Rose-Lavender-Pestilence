extends Node3D

func _process(_delta: float) -> void:
	$Camera3D.position = $Character.position + Vector3(0, 10, 5);
