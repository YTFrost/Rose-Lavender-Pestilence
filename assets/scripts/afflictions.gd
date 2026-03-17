class_name Affliction

enum State {
	DEFICIENCY,
	EXCESS
}

var name : String;
var description : String;
var type : Affliction.State;

static var affliction_map : Dictionary[HumorState.Type, Dictionary] = {
	HumorState.Type.BLOOD: {
		Affliction.State.DEFICIENCY: [ PALE_SKIN ],
		Affliction.State.EXCESS: [ FLUSHED_CHEEKS, NOSEBLEEDS ]
	},
	HumorState.Type.GALL: {
		Affliction.State.DEFICIENCY: [ PALE_SKIN ],
		Affliction.State.EXCESS: [ FLUSHED_CHEEKS, NOSEBLEEDS ]
	},
	HumorState.Type.PHLEGM: {
		Affliction.State.DEFICIENCY: [ PALE_SKIN ],
		Affliction.State.EXCESS: [ FLUSHED_CHEEKS, NOSEBLEEDS ]
	},
	HumorState.Type.MELANCHOLY: {
		Affliction.State.DEFICIENCY: [ PALE_SKIN ],
		Affliction.State.EXCESS: [ FLUSHED_CHEEKS, NOSEBLEEDS ]
	}
}

static var FLUSHED_CHEEKS = Affliction.new(
	"Flushed cheeks", 
	Affliction.State.EXCESS, 
	"The patient's face is red, as if they are constantly ashamed or flustered."
);
static var NOSEBLEEDS = Affliction.new(
	"Nosebleeds", 
	Affliction.State.EXCESS, 
	"Occasionally, blood pours out of the patient's nose in varying volume."
);
static var PALE_SKIN = Affliction.new(
	"Pale skin",
	Affliction.State.DEFICIENCY,
	"The patient's skin is white and anemic, seen particularily on the face and hands."
);

func _init(new_name: String, new_type: Affliction.State, new_description: String = ""):
	name = new_name;
	type = new_type;
	description = new_description;

static func get_random(the_type: HumorState.Type, state: HumorState.State) -> Affliction:
	var affliction_state;
	var humor_afflictions = affliction_map[the_type];
	match(state):
		HumorState.State.DEFICIENCY: affliction_state = Affliction.State.DEFICIENCY;
		[HumorState.State.MILD_EXCESS, HumorState.State.EXCESS]: affliction_state = Affliction.State.EXCESS;
	var afflictions = humor_afflictions[affliction_state];
	return afflictions[ randi_range(0, afflictions.size()) ];
