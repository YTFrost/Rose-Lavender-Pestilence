extends "res://assets/scenes/interaction_target/interaction_target.gd"

@export var time_tracker : TimeTracker;
@export var world_timer : Timer;
var tweens : Array[Tween] = [];

func interact(doctor: CharacterBody3D):
	doctor.interaction_lock = true;
	world_timer.stop();
	$AnimationPlayer.play("sleep_ui_appear", -1, 0.25);
	$SecondsTimer.wait_time = 1.0;
	$SecondsTimer.start();
	var seconds_tween = get_tree().create_tween();
	seconds_tween.tween_property($SecondsTimer, "wait_time", 1.0/20.0, 5);
	seconds_tween.tween_callback(func():
		$TenSecondsTimer.start();
		var ten_seconds_tween = get_tree().create_tween();
		ten_seconds_tween.tween_property($TenSecondsTimer, "wait_time", 1.0/20.0, 10);
		ten_seconds_tween.tween_callback(func():
			$MinutesTimer.start();
			var minutes_tween = get_tree().create_tween();
			minutes_tween.tween_property($MinutesTimer, "wait_time", 1.0/20.0, 10);
			tweens.append(minutes_tween);
		)
		tweens.append(ten_seconds_tween);
	);
	tweens.append(seconds_tween);

func _enter_tree() -> void:
	time_tracker.seconds_updated.connect(_on_time_tracker_seconds_updated);

func _on_time_tracker_seconds_updated(_value: int) -> void:
	$TextureRect/TimeUi.set_time(time_tracker);

func _on_seconds_timer_timeout() -> void:
	time_tracker.seconds = time_tracker.seconds + 1;

func _on_ten_seconds_timer_timeout() -> void:
	time_tracker.seconds = time_tracker.seconds + 10;

func _on_minutes_timer_timeout() -> void:
	time_tracker.minutes = time_tracker.minutes + 1;

func _on_wake_up_button_pressed() -> void:
	world_timer.start();
	$AnimationPlayer.play("sleep_ui_disappear", -1, 0.2);
	$SecondsTimer.stop();
	$TenSecondsTimer.stop();
	$MinutesTimer.stop();
	for tween in tweens:
		tween.kill();

func _on_interaction_ended(_target: Node3D, doctor: Node3D) -> void:
	doctor.interaction_lock = false;
