class_name HumorState extends Resource;

enum Type {
	BLOOD,
	GALL,
	PHLEGM,
	MELANCHOLY
}
enum State {
	DEFICIENCY,
	MILD_DEFICIENCY,
	NORMAL,
	MILD_EXCESS,
	EXCESS
}

@export var type : Type;
@export var level : float:
	set(value):
		level = clamp(value, 0.0, 100.0);
		update_state();
var state : HumorState.State = HumorState.State.NORMAL;
var afflictions : Array = [];
var affliction_count := 0;

func _init(new_type: HumorState.Type, new_level: float = 25.0):
	type = new_type;
	level = new_level;

func update_state() -> void:
	if(level < 18): state = HumorState.State.DEFICIENCY;
	elif(level < 22): state = HumorState.State.MILD_DEFICIENCY;
	elif(level < 28): state = HumorState.State.NORMAL;
	elif(level < 32): state = HumorState.State.MILD_EXCESS;
	else: state = HumorState.State.EXCESS;

func update_afflictions() -> void:
	match(state):
		HumorState.State.DEFICIENCY: affliction_count = 1;
		HumorState.State.MILD_DEFICIENCY: affliction_count = 0;
		HumorState.State.NORMAL: affliction_count = 0;
		HumorState.State.MILD_EXCESS: affliction_count = 1;
		HumorState.State.EXCESS: affliction_count = 2;
