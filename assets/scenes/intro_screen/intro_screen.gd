extends Control

var next_scene : PackedScene = load("res://assets/scenes/main_menu/main_menu.tscn");

func _on_intro_player_finished() -> void:
	var next_scene_instance := next_scene.instantiate();
	queue_free();
	add_sibling(next_scene_instance);
