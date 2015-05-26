using com.mindrocks.functional.Functional;

enum AST<T> {
	Resolved  (msys: T);
	Unresolved(type: String, name: String);
}

enum AST_Mekton {
	Mekton(name: String, servos: Array<AST_Servo>);
}

enum AST_Servo {
	Torso(sizeClass: SizeClass, armor: Armor, systems: Array<AST<AST_MekSys>>);
	Head (sizeClass: SizeClass, armor: Armor, systems: Array<AST<AST_MekSys>>);
	Arm  (sizeClass: SizeClass, armor: Armor, systems: Array<AST<AST_MekSys>>);
	Leg  (sizeClass: SizeClass, armor: Armor, systems: Array<AST<AST_MekSys>>);
	Wing (sizeClass: SizeClass, armor: Armor, systems: Array<AST<AST_MekSys>>);
	Tail (sizeClass: SizeClass, armor: Armor, systems: Array<AST<AST_MekSys>>);
	Pod  (sizeClass: SizeClass, armor: Armor, systems: Array<AST<AST_MekSys>>);
}

enum AST_Property {
	AST_Ammo(ams: Array<AST<MekSys>>);
}

enum AST_MekSys {
	/** Weapon Systems **/
	Beam       (name: String, properties: Array<AST<Property>>);
	EnergyMelee(name: String, properties: Array<AST<Property>>);
	Melee      (name: String, properties: Array<AST<Property>>);
	Missile    (name: String, properties: Array<AST<Property>>);
	Projectile (name: String, properties: Map<String, Option<AST<Property>>>);
	EnergyPool (name: String, properties: Array<AST<Property>>, systems: Map<String, Option<AST_MekSys>>);

	/** Mount Systems **/
	Mount(system: AST<AST_MekSys>, properties: Array<AST<Property>>);
	Hand (system: AST<AST_MekSys>, properties: Array<AST<Property>>);

	/** Mated Systems **/
	MatedSystem(name: String, systems: Map<String, Option<AST_MekSys>>, properties: Array<AST<Property>>);

	/** Reflector Systems **/
	Reflector(name: String, quality: Int, properties: Array<AST<Property>>);

	/** Remote Control Systems **/
	RemoteControl(name: String, sizeClass: SizeClass, properties: Array<AST<Property>>);

	/** Ammo Systems **/
	Ammo(name: String, properties: Array<AST<Property>>);

	/** Electronic Warfare Systems **/
	SensorECM (name: String, properties: Array<AST<Property>>);
	MissileECM(name: String, properties: Array<AST<Property>>);
	RadarECM  (name: String, properties: Array<AST<Property>>);
	CounterECM(name: String, properties: Array<AST<Property>>);

	/** Sensor Systems **/
	Sensor(name: String, sizeClass: SizeClass, properties: Array<AST<Property>>);

	/** Optional Systems **/
	Stereo              (properties: Array<AST<Property>>);
	Liftwire            (properties: Array<AST<Property>>);
	AntiTheftCodeLock   (properties: Array<AST<Property>>);
	Spotlights          (properties: Array<AST<Property>>);
	Nightlights         (properties: Array<AST<Property>>);
	StorageModule       (properties: Array<AST<Property>>);
	Micromanipulators   (properties: Array<AST<Property>>);
	SlickSpray          (properties: Array<AST<Property>>);
	BoggSpray           (properties: Array<AST<Property>>);
	DamageControlPackage(properties: Array<AST<Property>>);
	QuickChangeMount    (properties: Array<AST<Property>>);
	SilentRunning       (properties: Array<AST<Property>>);
	Parachute           (properties: Array<AST<Property>>);
	ReEntryPackage      (properties: Array<AST<Property>>);
	EjectionSeat        (properties: Array<AST<Property>>);
	EscapePod           (properties: Array<AST<Property>>);
	ManeuverPod         (properties: Array<AST<Property>>);
	VehiclePod          (properties: Array<AST<Property>>);

	/** Crew Systems **/
	Cockpit  (properties: Array<AST<Property>>);
	Passenger(properties: Array<AST<Property>>);
	ExtraCrew(properties: Array<AST<Property>>);

	/** Recon Systems **/
	AdvancedSensorPackage (properties: Array<AST<Property>>);
	RadioRadarAnalyzer    (properties: Array<AST<Property>>);
	ResolutionIntensifiers(properties: Array<AST<Property>>);
	SpottingRadar         (properties: Array<AST<Property>>);
	TargetAnalyzer        (properties: Array<AST<Property>>);
	MarineSuite           (properties: Array<AST<Property>>);
	GravityLens           (properties: Array<AST<Property>>);
	MagneticResonance     (properties: Array<AST<Property>>);
}