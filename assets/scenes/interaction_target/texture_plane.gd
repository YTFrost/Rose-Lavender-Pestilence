@tool
extends MeshInstance3D

@export var color : Color = Color.WHITE:
	set(value):
		color = value;
		mesh.surface_get_material(0).set_shader_parameter("color", Vector3(color.r, color.g, color.b));
		mesh.surface_get_material(0).set_shader_parameter("alpha_mod", color.a);
@export var speed : float = 1.0:
	set(value):
		speed = value;
		mesh.surface_get_material(0).set_shader_parameter("time_multiplier", speed);
@export var size : float = 1.0:
	set(value):
		size = value;
		mesh.surface_get_material(0).set_shader_parameter("background_size", size);
@export var outline_width : float = 0.1:
	set(value):
		outline_width = value;
		mesh.surface_get_material(0).set_shader_parameter("outline_width", outline_width);

func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED: update_material();

func update_material():
	mesh.surface_get_material(0).set_shader_parameter("plane_size", Vector2(scale.x, scale.z));
