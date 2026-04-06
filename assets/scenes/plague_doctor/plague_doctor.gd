extends CharacterBody3D

var item_stack_height := 0.0;
var max_items := 10;
var items := [];
var heading := Vector3.FORWARD;
var type := Character.DOCTOR;
var interaction_lock := false;
var can_interact := true;
var interaction_target : Node3D = null;
var interaction_progress : float = 0.0;
@export var walk_speed := 8;
@export var rotate_speed := 3*PI;
@onready var camera_node : Camera3D = $Camera3D;
@onready var animation_player : AnimationPlayer = $AnimationPlayer;

func _process(delta: float) -> void:
	if(camera_node != null):
		camera_node.global_position = global_position + Vector3(0, 10, 5.5);
		$InteractionIndicator.position = camera_node.unproject_position(position + Vector3(0.0, 3.0, 0.0));
	var flat_heading = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down", 0.2);
	heading = Vector3(flat_heading.x, 0.0, flat_heading.y);
	if(flat_heading != Vector2.ZERO):
		velocity.x = flat_heading.x * walk_speed;
		velocity.z = flat_heading.y * walk_speed;
		if(velocity.length() < walk_speed/2): animation_player.play("walk", 0.5, velocity.length() / (walk_speed/2));
		else: animation_player.play("run", 0.5, velocity.length() / walk_speed);
		update_rotation(delta);
	else:
		velocity.x = 0.0;
		velocity.z = 0.0;
		animation_player.play("idle");
	velocity.y = velocity.y - 98.1 * delta;
	move_and_slide();
	update_interaction(delta);

func update_rotation(delta: float) -> void:
	var rotation_vector := Vector3.FORWARD.rotated(Vector3.UP, rotation.y);
	var heading_difference := heading.signed_angle_to(rotation_vector, Vector3.DOWN);
	rotation.y += clampf(heading_difference, -rotate_speed*delta, rotate_speed*delta);

func update_interaction(delta: float) -> void:
	if(interaction_lock or interaction_target == null): return;
	if(interaction_progress < interaction_target.interaction_time):
		if(!interaction_target.impossible): interaction_progress += delta;
		$InteractionIndicator.set_progress(interaction_progress / interaction_target.interaction_time);
	else:
		interaction_target.interact(self);
		if(interaction_target.continuous): $InteractionIndicator.hide();

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

func add_item(item: Node3D) -> void:
	items.append(item);
	$ItemStack.add_child(item);
	item.position.y = item_stack_height;
	item_stack_height += item.get_node("Top").position.y;
