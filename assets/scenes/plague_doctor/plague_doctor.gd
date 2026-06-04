extends CharacterBody3D

signal picked_up_item(item: Node3D);
signal dropped_item(index: int);

const CAMERA_OFFSET = Vector3(0, 10, 5.5);
const INTERACTION_INDICATOR_OFFSET = Vector3(0.0, 3.0, 0.0);
const ROTATION_LERP_WEIGHT = 0.1;
const VELOCITY_LERP_WEIGHT = 0.225;
const GRAVITY = 45.0;

enum LegsState {
	IDLE,
	WALKING,
	RUNNING 
}
enum BodyState {
	IDLE,
	CARRY_LIGHT,
	CARRY_HEAVY
}

@export var camera_node : Camera3D;
@export var interaction_indicator_node : Control;
@export var walk_speed := 3;
@export var rotate_speed := 3*PI;
@export var run_speed := 8;

@onready var animation_player : AnimationPlayer = $AnimationPlayer;
var can_interact := true;
var heading := Vector2.UP;
var item_stack_height := 0.0;
var inventory_mode := InventoryMode.PICKUP;
var interaction_lock := false;
var interaction_progress : float = 0.0;
var interaction_target : Node3D = null;
var items := [];
var max_items := 10;
var legs_state := LegsState.IDLE;
var body_state := BodyState.IDLE;
var type := Character.DOCTOR;

func _process(delta: float) -> void:
	update_camera();
	update_interaction_indicator();
	update_heading();
	update_state();
	update_rotation();
	update_interaction(delta);

func _physics_process(delta: float) -> void:
	update_movement(delta);
	move_and_slide();

func update_movement(delta: float) -> void:
	var heading_normalized = heading.normalized();
	if(legs_state == LegsState.IDLE):
		velocity.x = lerpf(velocity.x, 0.0, VELOCITY_LERP_WEIGHT);
		velocity.z = lerpf(velocity.z, 0.0, VELOCITY_LERP_WEIGHT);
	if(legs_state == LegsState.WALKING):
		velocity.x = lerpf(velocity.x, heading_normalized.x * walk_speed, VELOCITY_LERP_WEIGHT);
		velocity.z = lerpf(velocity.z, heading_normalized.y * walk_speed, VELOCITY_LERP_WEIGHT);
	elif(legs_state == LegsState.RUNNING):
		velocity.x = lerpf(velocity.x, heading_normalized.x * run_speed, VELOCITY_LERP_WEIGHT);
		velocity.z = lerpf(velocity.z, heading_normalized.y * run_speed, VELOCITY_LERP_WEIGHT);
	velocity.y -= GRAVITY * delta

func update_camera() -> void:
	if(camera_node == null):
		push_error("Invalid update_camera() call. 'camera_node' is null.");
		return;
	camera_node.global_position = global_position + CAMERA_OFFSET;

func update_interaction_indicator() -> void:
	if(interaction_indicator_node == null):
		push_error("Invalid update_interaction_indicator() call. 'interaction_indicator_node' is null.");
		return;
	if(camera_node == null):
		push_error("Invalid update_interaction_indicator() call. 'camera_node' is null.");
		return;
	interaction_indicator_node.position = camera_node.unproject_position(position + INTERACTION_INDICATOR_OFFSET);

func update_rotation() -> void:
	if(heading.length() < 0.1): return;
	rotation.y = lerp_angle(rotation.y, heading.angle_to(Vector2.RIGHT), ROTATION_LERP_WEIGHT);

func update_interaction(delta: float) -> void:
	if(interaction_lock or interaction_target == null): return;
	if(interaction_progress < interaction_target.interaction_time):
		if(!interaction_target.impossible): interaction_progress += delta;
		$InteractionIndicator.set_progress(interaction_progress / interaction_target.interaction_time);
	else:
		interaction_target.interact(self);
		if(interaction_target.continuous): $InteractionIndicator.hide();

func update_heading() -> void:
	heading = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down", 0.1);
	if(Input.is_action_pressed("walk")): heading = heading.normalized() * 0.49;

func update_state() -> void:
	if(heading.length() < 0.1): legs_state = LegsState.IDLE;
	elif(heading.length() < 0.5): legs_state = LegsState.WALKING;
	else: legs_state = LegsState.RUNNING;

func try_interact(object) -> bool:
	if(can_interact):
		can_interact = false;
		interaction_target = object;
		$InteractionIndicator.visible = true;
		$InteractionIndicator.show_interaction(interaction_target.interaction);
		return true;
	else:
		return false;

func try_clear_interaction(object) -> void:
	if(interaction_target == object):
		interaction_target = null;
		can_interact = true;
		$InteractionIndicator.visible = false;
		interaction_progress = 0.0;

func reset_interaction() -> void:
	interaction_target = null;
	can_interact = true;
	interaction_progress = 0.0;
	$InteractionIndicator.visible = false;

func can_pick_up_item() -> bool:
	return items.size() < max_items;

func can_drop_item() -> bool:
	return items.size() > 0;

func add_item(item: Node3D) -> void:
	items.append(item);
	$item_stack_origin.add_child(item);
	update_item_stack();
	if(items.size() > 0): body_state = BodyState.CARRY_LIGHT;
	if(items.size() > 5): body_state = BodyState.CARRY_HEAVY;
	picked_up_item.emit(item);

func remove_item(item_name: String) -> void:
	var found = items.find_custom(func (item): return item.item_name == item_name);
	if(found != -1):
		var removed_item = items.pop_at(found);
		$item_stack_origin.remove_child(removed_item);
		removed_item.queue_free();
		update_item_stack();
		if(items.size() == 0): inventory_mode = InventoryMode.PICKUP;
		if(items.size() == 0): body_state = BodyState.IDLE;
		if(items.size() > 0): body_state = BodyState.CARRY_LIGHT;
		if(items.size() > 5): body_state = BodyState.CARRY_HEAVY;
		dropped_item.emit(found);
	else:
		push_error("Can not remove item '%s', because player has none", item_name);

func has_item(item_name: String) -> bool:
	return items.find_custom(func (item): return item.item_name == item_name) != -1;

func update_item_stack() -> void:
	item_stack_height = 0.0;
	var item_list = $item_stack_origin.get_children();
	for item in item_list:
		item.position.y = item_stack_height;
		item_stack_height += item.get_node("Top").position.y;

func _on_inventory_display_inventory_mode_changed(mode: Variant) -> void:
	inventory_mode = mode;
