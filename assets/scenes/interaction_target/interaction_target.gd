extends Node3D

signal interaction_began(target: Node3D, doctor: Node3D);
signal interaction_ended(target: Node3D, doctor: Node3D);

@export var player_character : CharacterBody3D = null;
@export var rootNode : Node3D = self;
@export var alpha_curve : Curve = null;
@export var interaction : String;
@export var interaction_time : float;

@onready var texture_plane = $InteractionArea/TexturePlane;

func _process(_delta) -> void:
	if(player_character == null or alpha_curve == null): return;
	texture_plane.mesh.surface_get_material(0).set_shader_parameter("alpha_mod", 
		alpha_curve.sample( player_character.position.distance_to(rootNode.position) )
	);

func _on_interaction_area_body_entered(body: Node3D) -> void:
	if(body == player_character):
		pre_interaction(body);
		interaction_began.emit(self, body);
		body.try_interact(self);
		post_interaction(body);

func _on_interaction_area_body_exited(body: Node3D) -> void:
	if(body == player_character):
		pre_clear(body);
		interaction_ended.emit(self, body);
		body.try_clear_interaction(self);
		post_clear(body);

func pre_interaction(_doctor: Node3D) -> void:
	pass;

func post_interaction(_doctor: Node3D) -> void:
	pass;

func pre_clear(_doctor: Node3D) -> void:
	pass;

func post_clear(_doctor: Node3D) -> void:
	pass;
