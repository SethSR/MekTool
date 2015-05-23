import com.mindrocks.functional.Functional;

class AST {
	function base(): Float { return 0; }
	function cost(): Float { return 0; }
	function space(): Float { return 0; }
	function kills(): Int { return 0; }
	// function details(s: String, n: Int = 0) return '%-${39-n}s = (cost : %6.2f | space : %6.2f | kills : %3d)'.format(s,cost,space,kills);
}

enum MekSys {
	/** Crew Systems **/
	Cockpit;
	Passenger;
	ExtraCrew;

	/** Optional Systems **/
	Stereo              (properties: Array<Property>); // extends OptType { override val toString = "Stereo" }
	Liftwire            (properties: Array<Property>); // extends OptType { override val toString = "Liftwire" }
	AntiTheftCodeLock   (properties: Array<Property>); // extends OptType { override val toString = "Anti-Theft Code Lock" }
	Spotlights          (properties: Array<Property>); // extends OptType { override val toString = "Spotlights" }
	Nightlights         (properties: Array<Property>); // extends OptType { override val toString = "Nightlights" }
	StorageModule       (properties: Array<Property>); // extends OptType { override val toString = "Storage Module" }
	Micromanipulators   (properties: Array<Property>); // extends OptType { override val toString = "Micromanipulators" }
	SlickSpray          (properties: Array<Property>); // extends OptType { override val toString = "Slick-Spray" }
	BoggSpray           (properties: Array<Property>); // extends OptType { override val toString = "Bogg-Spray" }
	DamageControlPackage(properties: Array<Property>); // extends OptType { override val toString = "Damage Control Package" }
	QuickChangeMount    (properties: Array<Property>); // extends OptType { override val toString = "Quick Change Mount" }
	SilentRunning       (properties: Array<Property>); // extends OptType { override val toString = "Silent Running" }
	Parachute           (properties: Array<Property>); // extends OptType { override val toString = "Parachute" }
	ReEntryPackage      (properties: Array<Property>); // extends OptType { override val toString = "Re-Entry Package" }
	EjectionSeat        (properties: Array<Property>); // extends OptType { override val toString = "Ejection Seat" }
	EscapePod           (properties: Array<Property>); // extends OptType { override val toString = "Escape Pod" }
	ManeuverPod         (properties: Array<Property>); // extends OptType { override val toString = "Maneuver Pod" }
	VehiclePod          (properties: Array<Property>); // extends OptType { override val toString = "Vehicle Pod" }

	/** Mount Systems **/
	Mount(system: Option<MekSys>, properties: Array<Property>);

	/** Hand Systems **/
	Hand(system: Option<MekSys>, properties: Array<Property>);
}

typedef Mekton = {
	name: String,
	servoList: List<Servo>,
}

enum Servo {
	Torso(sizeClass: SizeClass, armor: Armor, systemList: List<MekSys>);
	Head (sizeClass: SizeClass, armor: Armor, systemList: List<MekSys>);
	Arm  (sizeClass: SizeClass, armor: Armor, systemList: List<MekSys>);
	Leg  (sizeClass: SizeClass, armor: Armor, systemList: List<MekSys>);
	Wing (sizeClass: SizeClass, armor: Armor, systemList: List<MekSys>);
	Tail (sizeClass: SizeClass, armor: Armor, systemList: List<MekSys>);
	Pod  (sizeClass: SizeClass, armor: Armor, systemList: List<MekSys>);
}