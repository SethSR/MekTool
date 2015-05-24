import com.mindrocks.functional.Functional.Option;

typedef Mekton = {
	name: String,
	servoList: List<Servo>,
}

enum MekSys {
	EnergyPool(name: String, power: Int, properties: Array<Property>, systems: Array<MekSys>);
	Mount(system: Option<MekSys>, properties: Array<Property>);
	Hand(system: Option<MekSys>, properties: Array<Property>);
	MatedSystem(name: String, systems: List<MekSys>, properties: Array<Property>);
	Reflector(name: String, quality: Int, properties: Array<Property>);
	RemoteControl(name: String, sizeClass: SizeClass, properties: Array<Property>);
	Ammo(name: String, properties: Array<Property>);
	SensorECM(name: String, properties: Array<Property>);
	MissileECM(name: String, properties: Array<Property>);
	RadarECM(name: String, properties: Array<Property>);
	CounterECM(name: String, properties: Array<Property>);
	Sensor(name: String, sizeClass: SizeClass, properties: Array<Property>);
	Stereo(properties: Array<Property>);
	Liftwire(properties: Array<Property>);
	AntiTheftCodeLock(properties: Array<Property>);
	Spotlights(properties: Array<Property>);
	Nightlights(properties: Array<Property>);
	StorageModule(properties: Array<Property>);
	Micromanipulators(properties: Array<Property>);
	SlickSpray(properties: Array<Property>);
	BoggSpray(properties: Array<Property>);
	DamageControlPackage(properties: Array<Property>);
	QuickChangeMount(properties: Array<Property>);
	SilentRunning(properties: Array<Property>);
	Parachute(properties: Array<Property>);
	ReEntryPackage(properties: Array<Property>);
	EjectionSeat(properties: Array<Property>);
	EscapePod(properties: Array<Property>);
	ManeuverPod(properties: Array<Property>);
	VehiclePod(properties: Array<Property>);
	Cockpit;
	Passenger;
	ExtraCrew;
	AdvancedSensorPackage;
	RadioRadarAnalyzer;
	ResolutionIntensifiers;
	SpottingRadar;
	TargetAnalyzer;
	MarineSuite;
	GravityLens;
	MagneticResonance;
}