extends Label

func _on_character_inventory_changed(item_count: int) -> void:
	text = "Held Items: %d" % item_count;
