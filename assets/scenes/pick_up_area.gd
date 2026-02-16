extends Node3D

var player : CharacterBody3D

func _process(delta: float) -> void:
	if(player != null and player.can_get_items()): player.get_item();

func _on_area_3d_body_entered(body: Node3D) -> void:
	if(body is CharacterBody3D): player = body;

func _on_area_3d_body_exited(body: Node3D) -> void:
	player = null;
