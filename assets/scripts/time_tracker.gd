class_name TimeTracker

var hours := 12:
	set(value):
		if(value < 24): hours = value;
		else: hours = value % 24;
var minutes := 0:
	set(value):
		if(value < 60): minutes = value;
		else:
			minutes = value % 60;
			@warning_ignore("integer_division")
			hours += value / 60
var seconds := 0:
	set(value):
		if(value < 60): seconds = value;
		else:
			seconds = value % 60;
			@warning_ignore("integer_division")
			minutes += value / 60
var twenty_four_hour_format := true;

func update() -> void:
	seconds += 1;

func _to_string() -> String:
	if(twenty_four_hour_format): return "%02d:%02d:%02d" % [hours, minutes, seconds];
	var period = "AM" if (hours < 13) else "PM";
	if(hours % 12 == 0): return "%02d:%02d:%02d %s" % [hours, minutes, seconds, period];
	return "%02d:%02d:%02d %s" % [hours % 12, minutes, seconds, period];
