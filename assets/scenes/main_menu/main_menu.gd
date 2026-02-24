extends Control

func _enter_tree() -> void:
	$AnimationPlayer.play("fade_in");

func lock_ui() -> void:
	$MainMenuMargin.mouse_filter = MOUSE_FILTER_IGNORE;
	$MainMenuMargin.focus_mode = FOCUS_NONE;

func unlock_ui() -> void:
	$MainMenuMargin.mouse_filter = MOUSE_FILTER_PASS;
	$MainMenuMargin.focus_mode = FOCUS_NONE;

func _on_quit_button_button_down() -> void:
	$QuitConfirmationBox.visible = true;
	lock_ui();

func _on_yes_button_pressed() -> void:
	get_tree().quit();

func _on_no_button_pressed() -> void:
	$QuitConfirmationBox.visible = false;
	unlock_ui();

func _on_start_button_pressed() -> void:
	var main_scene_resource : PackedScene = load("res://assets/scenes/main.tscn");
	var main_scene_instance := main_scene_resource.instantiate();
	add_sibling(main_scene_instance);
	queue_free();
