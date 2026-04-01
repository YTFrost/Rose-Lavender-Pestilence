class_name PatientSchedule extends Resource

@export var entries : Dictionary[String, String]; 

func get_arrival(hours: int, minutes: int) -> String:
	var result = entries.get("%02d:%02d" % [hours, minutes]);
	return result;
