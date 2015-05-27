using com.mindrocks.functional.Functional;

enum AST<T> {
	Resolved  (m: T);
	Unresolved(s: String);
}

enum AST_Mekton {
	AST_Mekton(name: String, servos: Array<AST_Servo>);
}

enum AST_Servo {
	AST_Torso(sizeClass: SizeClass, armor: Armor, systems: Array<AST<AST_MekSys>>);
	AST_Head (sizeClass: SizeClass, armor: Armor, systems: Array<AST<AST_MekSys>>);
	AST_Arm  (sizeClass: SizeClass, armor: Armor, systems: Array<AST<AST_MekSys>>);
	AST_Leg  (sizeClass: SizeClass, armor: Armor, systems: Array<AST<AST_MekSys>>);
	AST_Wing (sizeClass: SizeClass, armor: Armor, systems: Array<AST<AST_MekSys>>);
	AST_Tail (sizeClass: SizeClass, armor: Armor, systems: Array<AST<AST_MekSys>>);
	AST_Pod  (sizeClass: SizeClass, armor: Armor, systems: Array<AST<AST_MekSys>>);
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
	AST_Phalanx(b: Bool);
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
	AST_Beam       (name: String, properties: Array<AST<AST_Property>>);
	AST_EnergyMelee(name: String, properties: Array<AST<AST_Property>>);
	AST_Melee      (name: String, properties: Array<AST<AST_Property>>);
	AST_Missile    (name: String, properties: Array<AST<AST_Property>>);
	AST_Projectile (name: String, properties: Array<AST<AST_Property>>);
	AST_EnergyPool (name: String, properties: Array<AST<AST_Property>>, systems: Array<AST<AST_MekSys>>);

	/** Shield Systems **/
	AST_StandardShield(name: Option<String>, armor: Option<Armor.ArmorClass>, sizeClass: SizeClass, properties: Array<AST<AST_Property>>);
	AST_ActiveShield  (name: Option<String>, armor: Option<Armor.ArmorClass>, sizeClass: SizeClass, properties: Array<AST<AST_Property>>);
	AST_ReactiveShield(name: Option<String>, armor: Option<Armor.ArmorClass>, sizeClass: SizeClass, properties: Array<AST<AST_Property>>);

	/** Mount Systems **/
	AST_Mount(system: AST<AST_MekSys>, properties: Array<AST<AST_Property>>);
	AST_Hand (system: AST<AST_MekSys>, properties: Array<AST<AST_Property>>);

	/** Mated Systems **/
	AST_MatedSystem(name: String, systems: Array<AST<AST_MekSys>>, properties: Array<AST<AST_Property>>);

	/** Reflector Systems **/
	AST_Reflector(name: String, properties: Array<AST<AST_Property>>);

	/** Remote Control Systems **/
	AST_RemoteControl(name: String, sizeClass: SizeClass, properties: Array<AST<AST_Property>>);

	/** Ammo Systems **/
	AST_Ammo(name: String, properties: Array<AST<AST_Property>>);

	/** Electronic Warfare Systems **/
	AST_SensorECM (name: String, properties: Array<AST<AST_Property>>);
	AST_MissileECM(name: String, properties: Array<AST<AST_Property>>);
	AST_RadarECM  (name: String, properties: Array<AST<AST_Property>>);
	AST_CounterECM(name: String, properties: Array<AST<AST_Property>>);

	/** Sensor Systems **/
	AST_Sensor(name: String, sizeClass: SizeClass, properties: Array<AST<AST_Property>>);

	/** Optional Systems **/
	AST_Stereo              (properties: Array<AST<AST_Property>>);
	AST_Liftwire            (properties: Array<AST<AST_Property>>);
	AST_AntiTheftCodeLock   (properties: Array<AST<AST_Property>>);
	AST_Spotlights          (properties: Array<AST<AST_Property>>);
	AST_Nightlights         (properties: Array<AST<AST_Property>>);
	AST_StorageModule       (properties: Array<AST<AST_Property>>);
	AST_Micromanipulators   (properties: Array<AST<AST_Property>>);
	AST_SlickSpray          (properties: Array<AST<AST_Property>>);
	AST_BoggSpray           (properties: Array<AST<AST_Property>>);
	AST_DamageControlPackage(properties: Array<AST<AST_Property>>);
	AST_QuickChangeMount    (properties: Array<AST<AST_Property>>);
	AST_SilentRunning       (properties: Array<AST<AST_Property>>);
	AST_Parachute           (properties: Array<AST<AST_Property>>);
	AST_ReEntryPackage      (properties: Array<AST<AST_Property>>);
	AST_EjectionSeat        (properties: Array<AST<AST_Property>>);
	AST_EscapePod           (properties: Array<AST<AST_Property>>);
	AST_ManeuverPod         (properties: Array<AST<AST_Property>>);
	AST_VehiclePod          (properties: Array<AST<AST_Property>>);

	/** Crew Systems **/
	AST_Cockpit  (properties: Array<AST<AST_Property>>);
	AST_Passenger(properties: Array<AST<AST_Property>>);
	AST_ExtraCrew(properties: Array<AST<AST_Property>>);

	/** Recon Systems **/
	AST_AdvancedSensorPackage (properties: Array<AST<AST_Property>>);
	AST_RadioRadarAnalyzer    (properties: Array<AST<AST_Property>>);
	AST_ResolutionIntensifiers(properties: Array<AST<AST_Property>>);
	AST_SpottingRadar         (properties: Array<AST<AST_Property>>);
	AST_TargetAnalyzer        (properties: Array<AST<AST_Property>>);
	AST_MarineSuite           (properties: Array<AST<AST_Property>>);
	AST_GravityLens           (properties: Array<AST<AST_Property>>);
	AST_MagneticResonance     (properties: Array<AST<AST_Property>>);
}