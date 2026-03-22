extends Control

func set_time(time_tracker: TimeTracker) -> void:
	$MarginContainer/Label.text = time_tracker.to_string();
