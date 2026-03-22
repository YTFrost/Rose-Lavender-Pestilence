extends Control

const TEMP_DESCS = [
	"Freezing",		# [-100, -90]
	"Cold",			# [-90, -70]
	"Chilly",		# [-70, -30]
	"Normal",		# [-30, 30]
	"Warm",			# [30, 70]
	"Hot",			# [70, 90]
	"Cooking",		# [90, 100]
];
const MOIST_DESCS = [
	"Parched",		# [-100, -90]
	"Dehydrated",	# [-90, -70]
	"Thirsty",		# [-70, -30]
	"Normal",		# [-30, 30]
	"Damp",			# [30, 70]
	"Sweating",		# [70, 90]
	"Soaked",		# [90, 100]
];

func _enter_tree() -> void:
	$AnimationPlayer.play("slide_in", -1, 4.0);

func load_patient_info(patient: RigidBody3D) -> void:
	$NotebookContainer/ContentMargins/VerticalContentSorter/Name.text = "%s %s" % [patient.patient_name, patient.patient_surname];
	$NotebookContainer/ContentMargins/VerticalContentSorter/QualitiesSorter/TemperatureSorter/Temperature.text = get_temperature_desc(patient.temperature);
	$NotebookContainer/ContentMargins/VerticalContentSorter/QualitiesSorter/MoistureSorter/Moisture.text = get_moisture_desc(patient.moisture);
	$NotebookContainer/ContentMargins/VerticalContentSorter/HealthBar/Full.size.x = 500 * (patient.life/100);
	$NotebookContainer/ContentMargins/VerticalContentSorter/BloodContainer/Blood.text = "%f" % patient.blood.level;
	$NotebookContainer/ContentMargins/VerticalContentSorter/PhlegmContainer/Phlegm.text = "%f" % patient.phlegm.level;
	$NotebookContainer/ContentMargins/VerticalContentSorter/GallContainer/Gall.text = "%f" % patient.gall.level;
	$NotebookContainer/ContentMargins/VerticalContentSorter/MelancholyContainer/Melancholy.text = "%f" % patient.melancholy.level;
	if(patient.afflictions.size() == 0): $NotebookContainer/ContentMargins/VerticalContentSorter/Afflictions.text = "None";
	else:
		var affliction_names := [];
		for affliction in patient.afflictions:
			affliction_names.append(affliction.name);
		$NotebookContainer/ContentMargins/VerticalContentSorter/Afflictions.text = ", ".join(affliction_names);

func get_temperature_desc(temperature: float) -> String:
	if(90 < temperature): return TEMP_DESCS[6];
	elif(70 < temperature): return TEMP_DESCS[5];
	elif(30 < temperature): return TEMP_DESCS[4];
	elif(-30 < temperature): return TEMP_DESCS[3];
	elif(-70 < temperature): return TEMP_DESCS[2];
	elif(-90 < temperature): return TEMP_DESCS[1];
	else: return TEMP_DESCS[0];
	
func get_moisture_desc(moisture: float) -> String:
	if(90 < moisture): return MOIST_DESCS[6];
	elif(70 < moisture): return MOIST_DESCS[5];
	elif(30 < moisture): return MOIST_DESCS[4];
	elif(-30 < moisture): return MOIST_DESCS[3];
	elif(-70 < moisture): return MOIST_DESCS[2];
	elif(-90 < moisture): return MOIST_DESCS[1];
	else: return MOIST_DESCS[0];

func _on_close_button_pressed() -> void:
	$AnimationPlayer.play("slide_out", -1, 4.0);

func _on_close_area_pressed() -> void:
	$AnimationPlayer.play("slide_out", -1, 4.0);

func _on_animation_player_animation_finished(anim_name: String):
	if(anim_name == "slide_out"): queue_free();
