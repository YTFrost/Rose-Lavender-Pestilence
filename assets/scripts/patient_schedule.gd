class_name PatientSchedule extends Resource

@export var entries : Dictionary[String, PatientData]; 

func get_arrival(hours: int, minutes: int) -> PatientData:
	var result = entries.get("%02d:%02d" % [hours, minutes]);
	return result;
