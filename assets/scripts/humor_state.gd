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
var afflictions : Array[Affliction] = [];
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
	while(afflictions.size() > affliction_count):
		afflictions.pop_at( randi_range(0, afflictions.size() - 1) );
	while(afflictions.size() < affliction_count):
		var chosen_affliction : Affliction;
		var index : int;
		var possible_afflictions : Array = Affliction.get_all(type, state).duplicate();
		index = randi_range(0, possible_afflictions.size() - 1)
		chosen_affliction = possible_afflictions[index];
		while(afflictions.has(chosen_affliction)):
			possible_afflictions.pop_at(index);
			index = randi_range(0, possible_afflictions.size() - 1)
			chosen_affliction = possible_afflictions[index];
		afflictions.push_back(chosen_affliction);
