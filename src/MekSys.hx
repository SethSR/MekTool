import com.mindrocks.functional.Functional.Option;

typedef Mekton = {
	name: String,
	servos: Array<Servo>,
}

enum MekSys {
	/** Weapon Systems **/
	Beam       (name: String, damage: Int, properties: Array<Property>);
	EnergyMelee(name: String, damage: Int, properties: Array<Property>);
	Melee      (name: String, damage: Int, properties: Array<Property>);
	Missile    (name: String, damage: Int, properties: Array<Property>);
	Projectile (name: String, damage: Int, properties: Array<Property>, ammo   : Array<MekSys>);
	EnergyPool (name: String, power : Int, properties: Array<Property>, systems: Array<MekSys>);

	/** Mount Systems **/
	Mount(system: Option<MekSys>, properties: Array<Property>);
	Hand (system: Option<MekSys>, properties: Array<Property>);

	/** Mated Systems **/
	MatedSystem(name: String, systems: List<MekSys>, properties: Array<Property>);

	/** Reflector Systems **/
	Reflector(name: String, quality: Int, properties: Array<Property>);

	/** Remote Control Systems **/
	RemoteControl(name: String, sizeClass: SizeClass, properties: Array<Property>);

	/** Ammo Systems **/
	Ammo(name: String, properties: Array<Property>);

	/** Electronic Warfare Systems **/
	SensorECM (name: String, properties: Array<Property>);
	MissileECM(name: String, properties: Array<Property>);
	RadarECM  (name: String, properties: Array<Property>);
	CounterECM(name: String, properties: Array<Property>);

	/** Sensor Systems **/
	Sensor(name: String, sizeClass: SizeClass, properties: Array<Property>);

	/** Optional Systems **/
	Stereo              (properties: Array<Property>);
	Liftwire            (properties: Array<Property>);
	AntiTheftCodeLock   (properties: Array<Property>);
	Spotlights          (properties: Array<Property>);
	Nightlights         (properties: Array<Property>);
	StorageModule       (properties: Array<Property>);
	Micromanipulators   (properties: Array<Property>);
	SlickSpray          (properties: Array<Property>);
	BoggSpray           (properties: Array<Property>);
	DamageControlPackage(properties: Array<Property>);
	QuickChangeMount    (properties: Array<Property>);
	SilentRunning       (properties: Array<Property>);
	Parachute           (properties: Array<Property>);
	ReEntryPackage      (properties: Array<Property>);
	EjectionSeat        (properties: Array<Property>);
	EscapePod           (properties: Array<Property>);
	ManeuverPod         (properties: Array<Property>);
	VehiclePod          (properties: Array<Property>);

	/** Crew Systems **/
	Cockpit;
	Passenger;
	ExtraCrew;

	/** Recon Systems **/
	AdvancedSensorPackage;
	RadioRadarAnalyzer;
	ResolutionIntensifiers;
	SpottingRadar;
	TargetAnalyzer;
	MarineSuite;
	GravityLens;
	MagneticResonance;
}