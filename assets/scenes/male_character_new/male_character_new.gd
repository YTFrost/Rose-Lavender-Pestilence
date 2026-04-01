## Main class for Patient NPCs. Contains an instance of InteractionTargetRound, used for interactions.
extends RigidBody3D

## Emitted when the child InteractionTargetRound emits doctor_inspected_patient.
## In practice, it means that whenever the doctor finishes waiting for an interaction
## to happen, InteractionTargetRound emits, then patient_info_requested is emitted.
signal patient_info_requested(patient: RigidBody3D);
## TODO: Not re-implemented yet. Is supposed to emit, whenever the patient's info changes.
signal patient_info_updated(patient: RigidBody3D);

## Defines the maximum delta for individual humor updates. MAX_SWING is used on
## moisture and temperature separately, so the theoretical maximum delta is 2 x MAX_SWING.
## Does not account for Humor normalization.
const MAX_SWING := 2.0;
## Defines the maximum delta in every individual exis when looking for a target
## location to wander to.
const MAX_WANDER_DISTANCE := 20.0;
## Defines the patient's walk speed, in m/s.
const WALK_SPEED = 3.0;

## Defines possible states for the NPC AI.
enum State {
	## Patient is idling.
	IDLE,
	## Patient is walking to the target location.
	WANDERING,
	## Patient has received a new target location to wander to, but can not start
	## navigating until the physics engine makes sure the location is reachable
	## by foot. This state is only supposed to last for 1 physics step.
	RESOLVING_DESTINATION 
}

## The patient's data.
@export var data : PatientData;

## The type of the character.
var type := Character.PATIENT;
## The patient's current state.
var state := State.IDLE;
## The patient's current destination information.
var destination : Destination = Destination.new();

## TODO: Split the current method into proper helper methods.
func _process(_delta):
	if(state == State.IDLE): $MaleCharacter/AnimationPlayer.play("idle");
	elif(state == State.WANDERING): $MaleCharacter/AnimationPlayer.play("walk_healthy");

## Currently, this handles destination updates and NPC AI.
## TODO: Optimize the destination updates so it doesn't require passing a World3D every tick.
## TODO: Split the current method into proper helper methods.
func _physics_process(delta):
	destination._physics_update(get_world_3d());
	if(state == State.WANDERING):
		var current_agent_position: Vector3 = global_position
		var next_path_position: Vector3 = $NavigationAgent3D.get_next_path_position();
		linear_velocity = current_agent_position.direction_to(next_path_position) * WALK_SPEED;
		var target_rotation = -linear_velocity.signed_angle_to(Vector3.FORWARD, Vector3.UP);
		rotation.y = target_rotation;
	elif(state == State.IDLE):
		linear_velocity = Vector3.ZERO;
	elif(state == State.RESOLVING_DESTINATION):
		if(destination.is_ready()):
			state = State.WANDERING;
			$NavigationAgent3D.target_position = destination.position;

## Applies a flat modifier to every humor, interpreting the delta as moisture.[br]
## - Adds the value to Blood[br]
## - Adds the value to Phlegm[br]
## - Subtracts the value from Gall[br]
## - Subtracts the value from Melancholy[br]
## After you apply all the modifiers, remember to call [method normalize_humors] to
## normalize the humors to 100.0 again.
func apply_moist_mod(delta: float) -> void:
	data.blood.level += delta;
	data.phlegm.level += delta;
	data.gall.level -= delta;
	data.melancholy.level -= delta;

## Applies a flat modifier to every humor, interpreting the delta as temperature.[br]
## - Adds the value to Blood[br]
## - Adds the value to Gall[br]
## - Subtracts the value from Phlegm[br]
## - Subtracts the value from Melancholy[br]
## After you apply all the modifiers, remember to call [method normalize_humors] to
## normalize the humors to 100.0 again.
func apply_temp_mod(delta: float) -> void:
	data.blood.level += delta;
	data.gall.level += delta;
	data.phlegm.level -= delta;
	data.melancholy.level -= delta;

## Normalizes the humors to 100.0 if the difference between it and 100.0 is larger
## than 0.01. Should only be called after all the expected operations are done.
func normalize_humors() -> void:
	var total_humors := data.blood.level + data.phlegm.level + data.gall.level + data.melancholy.level;
	if( abs( 100.0 - total_humors ) > 0.01 ):
		data.blood.level = ( data.blood.level / total_humors ) * 100.0;
		data.phlegm.level = ( data.phlegm.level / total_humors ) * 100.0;
		data.gall.level = ( data.gall.level / total_humors ) * 100.0;
		data.melancholy.level = ( data.melancholy.level / total_humors ) * 100.0;

## Updates afflictions of all humors, then sums every individual array and saves
## it as [member data.afflictions].
func update_afflictions() -> void:
	data.blood.update_afflictions();
	data.gall.update_afflictions();
	data.phlegm.update_afflictions();
	data.melancholy.update_afflictions();
	data.afflictions = data.blood.afflictions + data.gall.afflictions + data.phlegm.afflictions + data.melancholy.afflictions;

## Sets the patient's [member data.destination] to [param pos] and [member data.state]
## to [member State.WANDERING]. If [param correct_height] is [code]true[/code], it
## sets the [member data.state] to [member State.RESOLVING_DESTINATION] instead, 
## forcing the physics engine to resolve the target location first.
func walk_to(pos: Vector3, correct_height: bool = true) -> void:
	destination.position = pos;
	destination.correct_height = correct_height;
	if(correct_height):
		state = State.RESOLVING_DESTINATION;
	else:
		state = State.WANDERING
		$NavigationAgent3D.target_position = pos;

#region Callbacks
func _on_update_timer_timeout() -> void:
	var heat_delta = (data.temperature / 100.0) * MAX_SWING
	var moist_delta = (data.moisture / 100.0) * MAX_SWING

	apply_temp_mod(heat_delta);
	apply_moist_mod(moist_delta);
	normalize_humors();
	update_afflictions();
	
	data.temperature *= 0.98
	data.moisture *= 0.98
	
	patient_info_updated.emit(self);

func _on_state_timer_timeout():
	walk_to(Vector3(
		position.x + randf_range(-MAX_WANDER_DISTANCE, MAX_WANDER_DISTANCE),
		position.y,
		position.z + randf_range(-MAX_WANDER_DISTANCE, MAX_WANDER_DISTANCE)
	));

func _on_navigation_agent_3d_target_reached():
	state = State.IDLE;

func _on_doctor_inspected_patient(_target: Node3D, doctor: Node3D) -> void:
	patient_info_requested.emit(self, doctor);
	var info_menu_scene : PackedScene = load("res://assets/scenes/patient_info/patient_info.tscn");
	var info_menu_instance : Control = info_menu_scene.instantiate();
	info_menu_instance.load_patient_info(self);
	add_child(info_menu_instance);
	doctor.interaction_lock = true;

func _on_interaction_ended(_target: Node3D, doctor: Node3D) -> void:
	doctor.interaction_lock = false;
#endregion
