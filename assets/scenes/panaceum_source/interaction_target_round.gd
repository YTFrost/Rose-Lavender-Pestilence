extends "res://assets/scenes/interaction_target/interaction_target.gd"

signal doctor_grabbed_panaceum(interaction_target, doctor);

var interact_callback : Callable = interact_grab_panaceum;

func pre_interaction(doctor: Node3D) -> void:
	if(doctor.inventory_mode == InventoryMode.DROP):
		if(doctor.has_item("panaceum")): set_interaction("drop_panaceum");
		else: set_interaction("no_panaceum");
	else:
		if(doctor.can_pick_up_item()): set_interaction("grab_panaceum");
		else: set_interaction("inventory_full");

func interact(doctor: CharacterBody3D) -> void:
	interact_callback.call(doctor);
	doctor.reset_interaction();
	pre_interaction(doctor);
	doctor.try_interact(self);

func interact_grab_panaceum(doctor: CharacterBody3D) -> void:
	var panaceum_scene : PackedScene = load("res://assets/scenes/items/panaceum/panaceum.tscn");
	var panaceum_instance := panaceum_scene.instantiate();
	doctor.interaction_progress = 0.0;
	doctor.add_item(panaceum_instance);
	doctor_grabbed_panaceum.emit(self, doctor);

func interact_drop_panaceum(doctor: CharacterBody3D) -> void:
	doctor.remove_item("panaceum");

func interact_inventory_full(doctor: CharacterBody3D) -> void:
	pass;

func interact_no_panaceum(doctor: CharacterBody3D) -> void:
	pass;

func set_interaction(new_interaction: String) -> void:
	match(new_interaction):
		"grab_panaceum":
			interaction = "grab_panaceum";
			impossible = false;
			interact_callback = interact_grab_panaceum;
		"drop_panaceum":
			interaction = "drop_panaceum";
			impossible = false;
			interact_callback = interact_drop_panaceum;
		"inventory_full":
			interaction = "inventory_full";
			impossible = true;
			interact_callback = interact_inventory_full;
		"no_panaceum":
			interaction = "no_panaceum";
			impossible = true;
			interact_callback = interact_no_panaceum;
		_:
			push_error("Uncrecognised interaction type '%s' in PanaceumSource/InteractionTargetRound" % new_interaction);
			
