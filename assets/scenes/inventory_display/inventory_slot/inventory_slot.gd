extends TextureRect

func appear() -> void:
	$AnimationPlayer.play("appear", -1, 2.0);

func set_item(item: Node3D) -> void:
	$TextureRect.texture = item.image;
