extends Control

signal doctor_woke_up();

func set_time(time_tracker: TimeTracker) -> void:
	$MarginContainer/Label.text = time_tracker.to_string();

func start_sleep() -> void:
	$AnimationPlayer.play("show_sleep_screen");

func stop_sleep() -> void:
	$AnimationPlayer.play("show_sleep_screen", -1, -1.0, true);

func _on_wake_up_button_pressed() -> void:
	doctor_woke_up.emit();
