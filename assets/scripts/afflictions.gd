class_name Affliction

enum State {
	DEFICIENCY,
	EXCESS
}

static var FLUSHED_CHEEKS = Affliction.new(
	"Flushed cheeks", 
	Affliction.State.EXCESS, 
	"Patient's face is red, as if they are constantly ashamed or flustered."
);
static var NOSEBLEEDS = Affliction.new(
	"Nosebleeds", 
	Affliction.State.EXCESS, 
	"Occasionally, blood pours out of the patient's nose in varying volume."
);
static var PALE_SKIN = Affliction.new(
	"Pale skin",
	Affliction.State.DEFICIENCY,
	"Patient's skin is white and anemic, seen particularly on the face and hands."
);
static var POOR_DIGESTION = Affliction.new(
	"Poor digestion",
	Affliction.State.EXCESS,
	"Patient complains about stomach aches and unpleasant rumbling after dining."
);
static var SLEEPINESS = Affliction.new(
	"Sleepiness",
	Affliction.State.EXCESS,
	"Patient is visibly drowsy and sleepy, despite a sufficient resting."
);
static var DRY_COUGH = Affliction.new(
	"Dry cough",
	Affliction.State.DEFICIENCY,
	"Patient has a sickly, dry cough."
);
static var INTENSE_THIRST = Affliction.new(
	"Intense thirst",
	Affliction.State.EXCESS,
	"Patient craves water and feels very dry, despite drinking a sufficient amount."
);
static var DRY_MOUTH = Affliction.new(
	"Dry mouth",
	Affliction.State.EXCESS,
	"Patient complains of an unpleasantly dry mouth."
);
static var LOW_MOTIVATION = Affliction.new(
	"Low motivation",
	Affliction.State.DEFICIENCY,
	"Patient is idle and unmotivated to act."
);
static var REDUCED_APPETITE = Affliction.new(
	"Reduced appetite",
	Affliction.State.EXCESS,
	"Patient eats insufficiently, if anything at all."
);
static var BROODING = Affliction.new(
	"Brooding",
	Affliction.State.EXCESS,
	"Patient is visibly upset and ponders endlessly about various problems."
);
static var RECKLESSNESS = Affliction.new(
	"Recklessness",
	Affliction.State.DEFICIENCY,
	"Patient acts recklessly and without forethought, causing danger to themselves and those around."
);
static var affliction_map : Dictionary[HumorState.Type, Dictionary] = {
	HumorState.Type.BLOOD: {
		Affliction.State.DEFICIENCY: [ Affliction.PALE_SKIN ],
		Affliction.State.EXCESS: [ Affliction.FLUSHED_CHEEKS, Affliction.NOSEBLEEDS ]
	},
	HumorState.Type.PHLEGM: {
		Affliction.State.DEFICIENCY: [ Affliction.DRY_COUGH ],
		Affliction.State.EXCESS: [ Affliction.SLEEPINESS, Affliction.POOR_DIGESTION ]
	},
	HumorState.Type.GALL: {
		Affliction.State.DEFICIENCY: [ Affliction.LOW_MOTIVATION ],
		Affliction.State.EXCESS: [ Affliction.DRY_MOUTH, Affliction.INTENSE_THIRST ]
	},
	HumorState.Type.MELANCHOLY: {
		Affliction.State.DEFICIENCY: [ Affliction.RECKLESSNESS ],
		Affliction.State.EXCESS: [ Affliction.BROODING, Affliction.REDUCED_APPETITE ]
	}
}

var name : String;
var description : String;
var type : Affliction.State;

static func get_random(the_type: HumorState.Type, state: HumorState.State) -> Affliction:
	var affliction_state;
	var humor_afflictions = affliction_map[the_type];
	match(state):
		HumorState.State.DEFICIENCY: affliction_state = Affliction.State.DEFICIENCY;
		HumorState.State.MILD_EXCESS, HumorState.State.EXCESS: affliction_state = Affliction.State.EXCESS;
	var afflictions = humor_afflictions[affliction_state];
	return afflictions[ randi_range(0, afflictions.size() - 1) ];

static func get_all(the_type: HumorState.Type, state: HumorState.State) -> Array:
	var affliction_state;
	var humor_afflictions = affliction_map[the_type];
	match(state):
		HumorState.State.DEFICIENCY: affliction_state = Affliction.State.DEFICIENCY;
		HumorState.State.MILD_EXCESS, HumorState.State.EXCESS: affliction_state = Affliction.State.EXCESS;
	return humor_afflictions[affliction_state];

func _init(new_name: String, new_type: Affliction.State, new_description: String = ""):
	name = new_name;
	type = new_type;
	description = new_description;
