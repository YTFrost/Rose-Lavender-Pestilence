extends TextureButton

var on_click : Callable;
var doctor : Node3D;
var patient : Node3D;

func _on_pressed():
	if(on_click == null): push_error("on_click function not defined for button: %s", self.to_string());
	else: on_click.call(patient, doctor); 
