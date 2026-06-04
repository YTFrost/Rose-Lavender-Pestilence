extends Control

signal inventory_mode_changed(mode);

const PICKUP_NORMAL_TEXTURE := preload("res://assets/textures/ui/inventory_button/pickup/pickup_normal.png");
const PICKUP_HOVER_TEXTURE := preload("res://assets/textures/ui/inventory_button/pickup/pickup_hover.png");
const PICKUP_PRESSED_TEXTURE := preload("res://assets/textures/ui/inventory_button/pickup/pickup_pressed.png");
const DROP_NORMAL_TEXTURE := preload("res://assets/textures/ui/inventory_button/drop/drop_normal.png");
const DROP_HOVER_TEXTURE := preload("res://assets/textures/ui/inventory_button/drop/drop_hover.png");
const DROP_PRESSED_TEXTURE := preload("res://assets/textures/ui/inventory_button/drop/drop_pressed.png");

var inventory_slot_resource : PackedScene = preload("res://assets/scenes/inventory_display/inventory_slot/inventory_slot.tscn");
var is_visible : bool = false;
var inventory_mode := InventoryMode.PICKUP;

func fade_in() -> void:
	$AnimationPlayer.play("fade_in");

func fade_out() -> void:
	$AnimationPlayer.play("fade_out");

func set_texture_pickup() -> void:
	var button = $CenterContainer/VBoxContainer2/TextureButton
	button.texture_normal = PICKUP_NORMAL_TEXTURE;
	button.texture_hover = PICKUP_HOVER_TEXTURE;
	button.texture_pressed = PICKUP_PRESSED_TEXTURE;

func set_texture_drop() -> void:
	var button = $CenterContainer/VBoxContainer2/TextureButton
	button.texture_normal = DROP_NORMAL_TEXTURE;
	button.texture_hover = DROP_HOVER_TEXTURE;
	button.texture_pressed = DROP_PRESSED_TEXTURE;

func add_item(item: Node3D) -> void:
	if(!is_visible):
		fade_in();
		is_visible = true;
	var new_slot = inventory_slot_resource.instantiate();
	$CenterContainer/VBoxContainer2/VBoxContainer.add_child(new_slot);
	new_slot.appear();
	new_slot.set_item(item);

func _on_texture_button_pressed() -> void:
	if(inventory_mode == InventoryMode.PICKUP):
		inventory_mode = InventoryMode.DROP;
		set_texture_drop();
	else:
		inventory_mode = InventoryMode.PICKUP;
		set_texture_pickup();
	inventory_mode_changed.emit(inventory_mode);

func _on_plague_doctor_dropped_item(index: int) -> void:
	$CenterContainer/VBoxContainer2/VBoxContainer.get_child(index).queue_free();
	if($CenterContainer/VBoxContainer2/VBoxContainer.get_children().size() == 1):
		fade_out();
		is_visible = false;
