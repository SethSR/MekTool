using com.mindrocks.functional.Functional;

enum AST<T> {
	Resolved  (m: T);
	Unresolved(s: String);
}

enum AST_Mekton {
	AST_Mekton(name: String, servos: Array<AST_Servo>);
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
	AST_Accuracy(n: Int);
	AST_AllPurpose;
	AST_Ammo(ammo: Array<String>);
	AST_AntiMissile(b: Bool);
	AST_AntiPersonnel(b: Bool);
	AST_ArmorPiercing;
	AST_AttackFactor(n: Int);
	AST_Beaming(n: Int);
	AST_BeamShield(b: Bool);
	AST_BinderSpace(n: Int,d: Int);
	AST_Blast(n: Int);
	AST_BurstValue(n: Int);
	AST_ClipFed;
	AST_Clumsy;
	AST_CommRange(n: Int);
	AST_ControlRange(n: Int);
	AST_Cost(v: Float);
	AST_Countermissile(b: Bool);
	AST_Damage(v: Float);
	AST_DefenseAbility(n: Int);
	AST_Disruptor;
	AST_Entangle;
	AST_Flare;
	AST_Foam;
	AST_Fragile;
	AST_Fuse;
	AST_Handy;
	AST_HighEx;
	AST_Hydro;
	AST_Hyper;
	AST_Hypervelocity;
	AST_Incendiary;
	AST_Interference;
	AST_Kills(v: Float);
	AST_Kinetic;
	AST_LongRange;
	AST_MegaBeam;
	AST_Mirror;
	AST_Morphable;
	AST_MultiFeed(n: Int);
	AST_Nuclear;
	AST_OperationRange(n: Int);
	AST_Paintball;
	AST_Phalanx(value: Bool);
	AST_Power(n: Int);
	AST_QualityValue(n: Int);
	AST_Quick;
	AST_Radius(n: Int);
	AST_Range(n: Int);
	AST_Rechargeable;
	AST_Reset(n: Int);
	AST_Returning;
	AST_Scatter;
	AST_Scattershot;
	AST_Screen;
	AST_SensorRange(n: Int);
	AST_Shock(b: Bool);
	AST_Shots(n: Int);
	AST_Skill(n: Int);
	AST_Smart(n: Int);
	AST_Smoke;
	AST_Space(v: Float);
	AST_StoppingPower(n: Int);
	AST_Surge;
	AST_Swashbuckling;
	AST_Tangler;
	AST_Thrown;
	AST_Tracer;
	AST_TurnsInUse(n: Int);
	AST_Value(n: Int);
	AST_WarmUp(n: Int);
	AST_WideAngle(n: Int);
	AST_WireControlled;
}

enum AST_MekSys {
	/** Weapon Systems **/
	Beam       (name: String, properties: Array<AST<AST_Property>>);
	EnergyMelee(name: String, properties: Array<AST<AST_Property>>);
	Melee      (name: String, properties: Array<AST<AST_Property>>);
	Missile    (name: String, properties: Array<AST<AST_Property>>);
	Projectile (name: String, properties: Array<AST<AST_Property>>);
	EnergyPool (name: String, properties: Array<AST<AST_Property>>, systems: Array<AST<AST_MekSys>>);

	/** Shield Systems **/
	StandardShield(name: Option<String>, armor: Option<Armor.ArmorClass>, sizeClass: SizeClass, properties: Array<AST<AST_Property>>);
	ActiveShield  (name: Option<String>, armor: Option<Armor.ArmorClass>, sizeClass: SizeClass, properties: Array<AST<AST_Property>>);
	ReactiveShield(name: Option<String>, armor: Option<Armor.ArmorClass>, sizeClass: SizeClass, properties: Array<AST<AST_Property>>);

	/** Mount Systems **/
	Mount(system: AST<AST_MekSys>, properties: Array<AST<AST_Property>>);
	Hand (system: AST<AST_MekSys>, properties: Array<AST<AST_Property>>);

	/** Mated Systems **/
	MatedSystem(name: String, systems: Array<AST<AST_MekSys>>, properties: Array<AST<AST_Property>>);

	/** Reflector Systems **/
	Reflector(name: String, properties: Array<AST<AST_Property>>);

	/** Remote Control Systems **/
	RemoteControl(name: String, sizeClass: SizeClass, properties: Array<AST<AST_Property>>);

	/** Ammo Systems **/
	Ammo(name: String, properties: Array<AST<AST_Property>>);

	/** Electronic Warfare Systems **/
	SensorECM (name: String, properties: Array<AST<AST_Property>>);
	MissileECM(name: String, properties: Array<AST<AST_Property>>);
	RadarECM  (name: String, properties: Array<AST<AST_Property>>);
	CounterECM(name: String, properties: Array<AST<AST_Property>>);

	/** Sensor Systems **/
	Sensor(name: String, sizeClass: SizeClass, properties: Array<AST<AST_Property>>);

	/** Optional Systems **/
	Stereo              (properties: Array<AST<AST_Property>>);
	Liftwire            (properties: Array<AST<AST_Property>>);
	AntiTheftCodeLock   (properties: Array<AST<AST_Property>>);
	Spotlights          (properties: Array<AST<AST_Property>>);
	Nightlights         (properties: Array<AST<AST_Property>>);
	StorageModule       (properties: Array<AST<AST_Property>>);
	Micromanipulators   (properties: Array<AST<AST_Property>>);
	SlickSpray          (properties: Array<AST<AST_Property>>);
	BoggSpray           (properties: Array<AST<AST_Property>>);
	DamageControlPackage(properties: Array<AST<AST_Property>>);
	QuickChangeMount    (properties: Array<AST<AST_Property>>);
	SilentRunning       (properties: Array<AST<AST_Property>>);
	Parachute           (properties: Array<AST<AST_Property>>);
	ReEntryPackage      (properties: Array<AST<AST_Property>>);
	EjectionSeat        (properties: Array<AST<AST_Property>>);
	EscapePod           (properties: Array<AST<AST_Property>>);
	ManeuverPod         (properties: Array<AST<AST_Property>>);
	VehiclePod          (properties: Array<AST<AST_Property>>);

	/** Crew Systems **/
	Cockpit  (properties: Array<AST<AST_Property>>);
	Passenger(properties: Array<AST<AST_Property>>);
	ExtraCrew(properties: Array<AST<AST_Property>>);

	/** Recon Systems **/
	AdvancedSensorPackage (properties: Array<AST<AST_Property>>);
	RadioRadarAnalyzer    (properties: Array<AST<AST_Property>>);
	ResolutionIntensifiers(properties: Array<AST<AST_Property>>);
	SpottingRadar         (properties: Array<AST<AST_Property>>);
	TargetAnalyzer        (properties: Array<AST<AST_Property>>);
	MarineSuite           (properties: Array<AST<AST_Property>>);
	GravityLens           (properties: Array<AST<AST_Property>>);
	MagneticResonance     (properties: Array<AST<AST_Property>>);
}