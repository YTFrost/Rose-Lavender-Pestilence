extends Control

func show_interaction(interaction: String) -> void:
	match(interaction):
		"sleep": $TextureProgressBar.texture_over = load("res://assets/textures/ui/interaction_indicator/action_icons/sleep.png");
		"inspect": $TextureProgressBar.texture_over = load("res://assets/textures/ui/interaction_indicator/action_icons/inspect.png");
		"grab_panaceum": $TextureProgressBar.texture_over = load("res://assets/textures/ui/interaction_indicator/action_icons/grab_panaceum.png");
		_: pass;

func set_progress(level: float) -> void:
	$TextureProgressBar.value = level*100;
