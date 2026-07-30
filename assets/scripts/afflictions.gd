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
static var HEAD_PRESSURE = Affliction.new(
	"Head pressure",
	Affliction.State.EXCESS,
	"Patient reports strong pressure inside their head. Movement, bending over and turning causes noticeable pain.",
	func(patient: RigidBody3D):
		patient.data.life -= 2;
		patient.data.temperature += 3;
		patient.data.moisture += 1;
);
static var RESTLESSNESS = Affliction.new(
	"Restlessness",
	Affliction.State.EXCESS,
	"Patient is restless and reports difficulty sleeping, despite being tired.",
	func(patient: RigidBody3D):
		patient.data.life -= 1;
		patient.data.temperature += 2;
		patient.data.moisture += 2;
);
static var HEAVY_HEARTBEAT = Affliction.new(
	"Heavy heartbeat",
	Affliction.State.EXCESS,
	"Patient's heartbeat is loud, strong and quick.",
	func(patient: RigidBody3D):
		patient.data.temperature += 3;
		patient.data.moisture += 3;
);
static var DIZZINESS = Affliction.new(
	"Dizziness",
	Affliction.State.EXCESS,
	"Patient reports a sensation of their surroundings moving, particularly when moving their head.",
	func(patient: RigidBody3D):
		patient.data.life -= 3;
);
static var FATIGUE = Affliction.new(
	"Fatigue",
	Affliction.State.DEFICIENCY,
	"Patient is weak and fatigued, despite plenty of rest.",
	func(patient: RigidBody3D):
		patient.data.life -= 1;
);
static var WEAK_PULSE = Affliction.new(
	"Weak Pulse",
	Affliction.State.DEFICIENCY,
	"Patient's pulse is faint, barely noticeable.",
	func(patient: RigidBody3D):
		patient.data.life -= 1;
);
static var FAINTING = Affliction.new(
	"Fainting",
	Affliction.State.DEFICIENCY,
	"Patient keeps slipping into unconsciousness.",
	func(patient: RigidBody3D):
		patient.data.life -= 1;
);
static var COLD_SKIN = Affliction.new(
	"Cold Skin",
	Affliction.State.DEFICIENCY,
	"Patient's skin is cold to the touch, as if dead.",
	func(patient: RigidBody3D):
		patient.data.life -= 1;
);
static var SHORTNESS_OF_BREATH = Affliction.new(
	"Shortness of Breath",
	Affliction.State.DEFICIENCY,
	"Patient's breath is shallow and weak.",
	func(patient: RigidBody3D):
		patient.data.life -= 1;
);
static var affliction_map : Dictionary[HumorState.Type, Dictionary] = {
	HumorState.Type.BLOOD: {
		Affliction.State.DEFICIENCY: [
			Affliction.PALE_SKIN,
			Affliction.FATIGUE,
			Affliction.WEAK_PULSE,
			Affliction.FAINTING,
			Affliction.COLD_SKIN,
			Affliction.SHORTNESS_OF_BREATH
		],
		Affliction.State.EXCESS: [
			Affliction.FLUSHED_CHEEKS,
			Affliction.NOSEBLEEDS,
			Affliction.HEAD_PRESSURE,
			Affliction.RESTLESSNESS,
			Affliction.HEAVY_HEARTBEAT,
			Affliction.DIZZINESS
		]
	},
	HumorState.Type.PHLEGM: {
		Affliction.State.DEFICIENCY: [ Affliction.DRY_COUGH ],
		Affliction.State.EXCESS: [
			Affliction.SLEEPINESS,
			Affliction.POOR_DIGESTION,
		]
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
var effect : Callable;

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

func _init(new_name: String, new_type: Affliction.State, new_description: String, new_effect: Callable = func(_patient: RigidBody3D): pass):
	name = new_name;
	type = new_type;
	description = new_description;
	effect = new_effect;
