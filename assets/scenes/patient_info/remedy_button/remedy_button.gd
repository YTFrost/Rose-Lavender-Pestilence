extends TextureButton

signal remedy_used;

var on_click : Callable;
var doctor : Node3D;
var patient : Node3D;
var item_name : String;

func _on_pressed():
	if(on_click == null): push_error("on_click function not defined for button: %s", self.to_string());
	else: on_click.call(patient, doctor);
	doctor.remove_item(item_name);
	remedy_used.emit();
