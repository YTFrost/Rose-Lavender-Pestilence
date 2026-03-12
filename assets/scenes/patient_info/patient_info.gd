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
	$NotebookContainer/ContainerBackground.grow_horizontal = GROW_DIRECTION_END

func load_patient_info(patient: RigidBody3D) -> void:
	$NotebookContainer/ContentMargins/VerticalContentSorter/Name.text = "%s %s" % [patient.patient_name, patient.patient_surname];
	$NotebookContainer/ContentMargins/VerticalContentSorter/QualitiesSorter/TemperatureSorter/Temperature.text = get_temperature_desc(patient.temperature);
	$NotebookContainer/ContentMargins/VerticalContentSorter/QualitiesSorter/MoistureSorter/Moisture.text = get_moisture_desc(patient.moisture);
	$NotebookContainer/ContentMargins/VerticalContentSorter/HealthBar/Full.size.x = 500 * (patient.life/100);
	$NotebookContainer/ContentMargins/VerticalContentSorter/BloodContainer/Blood.text = "%f" % patient.blood;
	$NotebookContainer/ContentMargins/VerticalContentSorter/PhlegmContainer/Phlegm.text = "%f" % patient.phlegm;
	$NotebookContainer/ContentMargins/VerticalContentSorter/GallContainer/Gall.text = "%f" % patient.gall;
	$NotebookContainer/ContentMargins/VerticalContentSorter/MelancholyContainer/Melancholy.text = "%f" % patient.melancholy;

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

func slide_in() -> void:
	anchor_left = 1.0;
	var tween := get_tree().create_tween();
	tween.tween_property(self, "anchor_left", 0.0, 0.25);
	tween.set_trans(Tween.TRANS_CIRC);
	tween.set_ease(Tween.EASE_IN_OUT);

func slide_out() -> void:
	var tween := get_tree().create_tween();
	tween.tween_property(self, "anchor_left", 1.0, 0.25);
	tween.tween_callback(queue_free);
	tween.set_trans(Tween.TRANS_CIRC);
	tween.set_ease(Tween.EASE_IN_OUT);

func _on_close_button_pressed() -> void:
	slide_out();

func _on_close_area_pressed() -> void:
	slide_out();
