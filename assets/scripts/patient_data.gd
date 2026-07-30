@tool
class_name PatientData extends Resource

## The patient's name.
@export var patient_name := "Mirosław";
## The patient's surname.
@export var patient_surname := "Zimoch";
## The patient's life value, ranging from 0.0 to 100.0.
@export var life := 100.0;
## The patient's current temperature, ranging from -100.0 to 100.0.
@export var temperature := 0.0;
## The patient's current moisture, ranging from -100.0 to 100.0.
@export var moisture := 0.0;
## The state of the patient's Blood humor.
@export var blood : HumorState = HumorState.new(HumorState.Type.BLOOD);
## The state of the patient's Gall humor.
@export var gall : HumorState = HumorState.new(HumorState.Type.GALL);
## The state of the patient's Phlegm humor.
@export var phlegm : HumorState = HumorState.new(HumorState.Type.PHLEGM);
## The state of the patient's Melancholy humor.
@export var melancholy : HumorState = HumorState.new(HumorState.Type.MELANCHOLY);
## An array of all of the patient's current afflictions. A sum array of each
## individual humor's afflictions.
@export var afflictions : Array = [];
## The patient's walk speed, in m/s.
@export var walk_speed := 3.0;
