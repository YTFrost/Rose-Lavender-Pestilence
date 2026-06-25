extends Control

signal closed;

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
const REMEDIES = [
	"panaceum",
];

var patient : Node3D;
var doctor : Node3D;

func _enter_tree() -> void:
	$AnimationPlayer.play("slide_in", -1, 4.0);

func reload_patient_info() -> void:
	$NotebookContainer/ContentMargins/VerticalContentSorter/Name.text = "%s %s" % [patient.data.patient_name, patient.data.patient_surname];
	$NotebookContainer/ContentMargins/VerticalContentSorter/QualitiesSorter/TemperatureSorter/Temperature.text = get_temperature_desc(patient.data.temperature);
	$NotebookContainer/ContentMargins/VerticalContentSorter/QualitiesSorter/MoistureSorter/Moisture.text = get_moisture_desc(patient.data.moisture);
	$NotebookContainer/ContentMargins/VerticalContentSorter/HealthBar/Full.size.x = 500 * (patient.data.life/100);
	$NotebookContainer/ContentMargins/VerticalContentSorter/BloodContainer/Blood.text = "%f" % patient.data.blood.level;
	$NotebookContainer/ContentMargins/VerticalContentSorter/PhlegmContainer/Phlegm.text = "%f" % patient.data.phlegm.level;
	$NotebookContainer/ContentMargins/VerticalContentSorter/GallContainer/Gall.text = "%f" % patient.data.gall.level;
	$NotebookContainer/ContentMargins/VerticalContentSorter/MelancholyContainer/Melancholy.text = "%f" % patient.data.melancholy.level;
	if(patient.data.afflictions.size() == 0): $NotebookContainer/ContentMargins/VerticalContentSorter/Afflictions.text = "None";
	else:
		var affliction_names := [];
		for affliction in patient.data.afflictions:
			affliction_names.append(affliction.name);
		$NotebookContainer/ContentMargins/VerticalContentSorter/Afflictions.text = ", ".join(affliction_names);

func reload_remedies() -> void:
	var remedies_container := $NotebookContainer/ContentMargins/VerticalContentSorter/RemediesContainer;
	for child in remedies_container.get_children():
		child.queue_free();
	var item_list : Array = doctor.items;
	var remedy_list : Array;
	var button_resource := load("res://assets/scenes/patient_info/remedy_button/remedy_button.tscn");
	for item in item_list:
		if(!REMEDIES.has(item.item_name) or remedy_list.has(item.item_name)): continue;
		var normal_texture := load("res://assets/textures/ui/remedy_buttons/%s/%s_normal.png" % [item.item_name, item.item_name]);
		var hover_texture := load("res://assets/textures/ui/remedy_buttons/%s/%s_hover.png" % [item.item_name, item.item_name]);
		var pressed_texture := load("res://assets/textures/ui/remedy_buttons/%s/%s_pressed.png" % [item.item_name, item.item_name]);
		var button : TextureButton = button_resource.instantiate();
		button.texture_normal = normal_texture;
		button.texture_hover = hover_texture;
		button.texture_pressed = pressed_texture;
		button.on_click = item.on_apply_remedy;
		button.doctor = doctor;
		button.patient = patient;
		button.item_name = item.item_name;
		button.remedy_used.connect(reload_remedies);
		button.remedy_used.connect(reload_patient_info);
		remedies_container.add_child(button);
		remedy_list.append(item.item_name);

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
	if(anim_name == "slide_out"):
		closed.emit();
		queue_free();
