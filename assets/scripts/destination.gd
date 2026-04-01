class_name Destination

var position := Vector3.ZERO;
var correct_height := false;

func _physics_update(world: World3D) -> void:
	if(correct_height):
		var query = PhysicsRayQueryParameters3D.create(
			position + Vector3(0, 100, 0),
			position - Vector3(0, 100, 0));
		var result = world.direct_space_state.intersect_ray(query);
		if(!result.is_empty()):
			position = result["position"];
		correct_height = false;

func is_ready() -> bool:
	return !correct_height;
