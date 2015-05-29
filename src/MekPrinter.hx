using com.mindrocks.functional.Functional;

using Armor;
using MekSys;

class MekPrinter {
	static public function printMektons(mektons: Array<Mekton>) {
		var str = new StringBuf();
		for (m in mektons) switch m {
			case Mekton(name, servos):
				str.add('\nMekton : \'$name\'');
				str.add(printServos(servos));
		}
		return str.toString();
	}

	static function printServos(servos: Array<Servo>) {
		var str = new StringBuf();
		for (s in servos) switch s {
			case Torso(sizeClass, armor, systems):
				str.add('\n  $sizeClass Torso');
				str.add(printArmor(armor));
				str.add(printNames(systems));
			case Head (sizeClass, armor, systems):
				str.add('\n  $sizeClass Head');
				str.add(printArmor(armor));
				str.add(printNames(systems));
			case Arm  (sizeClass, armor, systems):
				str.add('\n  $sizeClass Arm');
				str.add(printArmor(armor));
				str.add(printNames(systems));
			case Leg  (sizeClass, armor, systems):
				str.add('\n  $sizeClass Leg');
				str.add(printArmor(armor));
				str.add(printNames(systems));
			case Wing (sizeClass, armor, systems):
				str.add('\n  $sizeClass Wing');
				str.add(printArmor(armor));
				str.add(printNames(systems));
			case Tail (sizeClass, armor, systems):
				str.add('\n  $sizeClass Tail');
				str.add(printArmor(armor));
				str.add(printNames(systems));
			case Pod  (sizeClass, armor, systems):
				str.add('\n  $sizeClass Pod');
				str.add(printArmor(armor));
				str.add(printNames(systems));
		}
		return str.toString();
	}

	static function printArmor(armor: Armor) {
		var str = new StringBuf();
		switch armor {
			case StandardArmor(sizeClass, armorClass):
				str.add('\n    ${printSizeClass(sizeClass)}');
				str.add(' $armorClass Armor');
			case RAMArmor(sizeClass, armorClass, ramValue1, ramValue2):
				str.add('\n    ${printSizeClass(sizeClass)}');
				str.add(' $armorClass RAM');
				str.add(' $ramValue1');
				str.add('/$ramValue2');
		}
		return str.toString();
	}

	static public function printSystems(systems: Array<MekSys>) {
		var str = new StringBuf();
		for (ms in systems) switch (ms) {
			case Beam                  (name, properties)                  : str.add('\nBeam : \'$name\'${printProperty(properties)}\n');
			case EnergyMelee           (name, properties)                  : str.add('\nEnergy Melee : \'$name\'${printProperty(properties)}\n');
			case Melee                 (name, properties)                  : str.add('\nMelee : \'$name\'${printProperty(properties)}\n');
			case Missile               (name, properties)                  : str.add('\nMissile : \'$name\'${printProperty(properties)}\n');
			case Projectile            (name, properties)                  : str.add('\nProjectile : \'$name\'${printProperty(properties)}\n');
			case EnergyPool            (name, properties, systems)         : str.add('\nEnergy Pool : \'$name\'${printProperty(properties)}, $systems\n');
			case StandardShield        (name, armor, sizeClass, properties): str.add(printShield('Standard', name, armor, sizeClass, properties));
			case ActiveShield          (name, armor, sizeClass, properties): str.add(printShield('Active', name, armor, sizeClass, properties));
			case ReactiveShield        (name, armor, sizeClass, properties): str.add(printShield('Reactive', name, armor, sizeClass, properties));
			case Mount                 (system, properties)                : str.add('\nMount($system, ${printProperty(properties)}\n');
			case Hand                  (system, properties)                : str.add('\nHand($system, ${printProperty(properties)}\n');
			case MatedSystem           (name, systems, properties)         : str.add('\nMated : \'$name\'$systems, ${printProperty(properties)}\n');
			case Reflector             (name, properties)                  : str.add('\nReflector : \'$name\'${printProperty(properties)}\n');
			case RemoteControl         (name, sizeClass, properties)       : str.add('\nRemote Control : \'$name\'$sizeClass, ${printProperty(properties)}\n');
			case Ammo                  (name, properties)                  : str.add('\nAmmo : \'$name\'${printProperty(properties)}\n');
			case SensorECM             (name, properties)                  : str.add('\nSensor ECM : \'$name\'${printProperty(properties)}\n');
			case MissileECM            (name, properties)                  : str.add('\nMissile ECM : \'$name\'${printProperty(properties)}\n');
			case RadarECM              (name, properties)                  : str.add('\nRadar ECM : \'$name\'${printProperty(properties)}\n');
			case CounterECM            (name, properties)                  : str.add('\nECCM : \'$name\'${printProperty(properties)}\n');
			case Sensor                (name, sizeClass, properties)       : str.add('\nSensor : \'$name\'${printProperty(properties)}\n');
			case Stereo                (properties)                        : str.add('\nStereo${printProperty(properties)}\n');
			case Liftwire              (properties)                        : str.add('\nLiftwire${printProperty(properties)}\n');
			case AntiTheftCodeLock     (properties)                        : str.add('\nAnti-Theft Code Lock${printProperty(properties)}\n');
			case Spotlights            (properties)                        : str.add('\nSpotlights${printProperty(properties)}\n');
			case Nightlights           (properties)                        : str.add('\nNightlights${printProperty(properties)}\n');
			case StorageModule         (properties)                        : str.add('\nStorage Module${printProperty(properties)}\n');
			case Micromanipulators     (properties)                        : str.add('\nMicromanipulators${printProperty(properties)}\n');
			case SlickSpray            (properties)                        : str.add('\nSlick-Spray${printProperty(properties)}\n');
			case BoggSpray             (properties)                        : str.add('\nBogg-Spray${printProperty(properties)}\n');
			case DamageControlPackage  (properties)                        : str.add('\nDamage Control Package${printProperty(properties)}\n');
			case QuickChangeMount      (properties)                        : str.add('\nQuick Change Mount${printProperty(properties)}\n');
			case SilentRunning         (properties)                        : str.add('\nSilent Running${printProperty(properties)}\n');
			case Parachute             (properties)                        : str.add('\nParachute${printProperty(properties)}\n');
			case ReEntryPackage        (properties)                        : str.add('\nRe-Entry Package${printProperty(properties)}\n');
			case EjectionSeat          (properties)                        : str.add('\nEjection Seat${printProperty(properties)}\n');
			case EscapePod             (properties)                        : str.add('\nEscape Pod${printProperty(properties)}\n');
			case ManeuverPod           (properties)                        : str.add('\nManeuver Pod${printProperty(properties)}\n');
			case VehiclePod            (properties)                        : str.add('\nVehicle Pod${printProperty(properties)}\n');
			case Cockpit               (properties)                        : str.add('\nCockpit${printProperty(properties)}\n');
			case Passenger             (properties)                        : str.add('\nPassenger${printProperty(properties)}\n');
			case ExtraCrew             (properties)                        : str.add('\nExtra Crew${printProperty(properties)}\n');
			case AdvancedSensorPackage (properties)                        : str.add('\nAdvanced Sensor Package${printProperty(properties)}\n');
			case RadioRadarAnalyzer    (properties)                        : str.add('\nRadio/Radar Analyzer${printProperty(properties)}\n');
			case ResolutionIntensifiers(properties)                        : str.add('\nResolution Intensifiers${printProperty(properties)}\n');
			case SpottingRadar         (properties)                        : str.add('\nSpotting Radar${printProperty(properties)}\n');
			case TargetAnalyzer        (properties)                        : str.add('\nTarget Analyzer${printProperty(properties)}\n');
			case MarineSuite           (properties)                        : str.add('\nMarine Suite${printProperty(properties)}\n');
			case GravityLens           (properties)                        : str.add('\nGravity Lens${printProperty(properties)}\n');
			case MagneticResonance     (properties)                        : str.add('\nMagnetic Resonance${printProperty(properties)}\n');
		}
		return str.toString();
	}

	static function printSizeClass(sc: SizeClass) switch (sc) {
		case Superlight   : return 'Superlight';
		case Lightweight  : return 'Lightweight';
		case Striker      : return 'Striker';
		case MediumStriker: return 'Medium Striker';
		case HeavyStriker : return 'Heavy Striker';
		case Mediumweight : return 'Mediumweight';
		case LightHeavy   : return 'Light Heavy';
		case MediumHeavy  : return 'Medium Heavy';
		case ArmoredHeavy : return 'Armored Heavy';
		case SuperHeavy   : return 'Super Heavy';
		case MegaHeavy    : return 'Mega Heavy';
	}

	static function printShield(type: String, name: Option<String>, armor: Option<ArmorClass>, sizeClass: SizeClass, properties: Array<Property>) {
		var str = new StringBuf();
		str.add('\n$type ');
		switch (armor) {
			case Some(a): str.add('$a ');
			case None   : str.add('Standard ');
		}
		str.add(printSizeClass(sizeClass) + ' Shield');
		switch (name) {
			case Some(n): str.add(' : \'$n\'');
			case None   : // Do Nothing
		}
		str.add('${printProperty(properties)}\n');
		return str.toString();
	}

	static function printNames(system: Array<MekSys>) {
		var str = new StringBuf();
		for (s in system) switch s {
			case Beam          (name, _)      : str.add('\n    \'$name\'');
			case EnergyMelee   (name, _)      : str.add('\n    \'$name\'');
			case Melee         (name, _)      : str.add('\n    \'$name\'');
			case Missile       (name, _)      : str.add('\n    \'$name\'');
			case Projectile    (name, _)      : str.add('\n    \'$name\'');
			case EnergyPool    (name, _, _)   : str.add('\n    \'$name\'');
			case StandardShield(name, _, _, _): str.add('\n    \'${printNameOption(name)}\'');
			case ActiveShield  (name, _, _, _): str.add('\n    \'${printNameOption(name)}\'');
			case ReactiveShield(name, _, _, _): str.add('\n    \'${printNameOption(name)}\'');
			case MatedSystem   (name, _, _)   : str.add('\n    \'$name\'');
			case Reflector     (name, _)      : str.add('\n    \'$name\'');
			case RemoteControl (name, _, _)   : str.add('\n    \'$name\'');
			case Ammo          (name, _)      : str.add('\n    \'$name\'');
			case SensorECM     (name, _)      : str.add('\n    \'$name\'');
			case MissileECM    (name, _)      : str.add('\n    \'$name\'');
			case RadarECM      (name, _)      : str.add('\n    \'$name\'');
			case CounterECM    (name, _)      : str.add('\n    \'$name\'');
			case Sensor        (name, _, _)   : str.add('\n    \'$name\'');
			case Mount         (system, _)    : str.add('\n    Mount${printOption(system)}');
			case Hand          (system, _)    : str.add('\n    Hand${printOption(system)}');
			case Stereo                (_)    : str.add('\n    Stereo');
			case Liftwire              (_)    : str.add('\n    Liftwire');
			case AntiTheftCodeLock     (_)    : str.add('\n    Anti-Theft Code Lock');
			case Spotlights            (_)    : str.add('\n    Spotlights');
			case Nightlights           (_)    : str.add('\n    Nightlights');
			case StorageModule         (_)    : str.add('\n    Storage Module');
			case Micromanipulators     (_)    : str.add('\n    Micromanipulators');
			case SlickSpray            (_)    : str.add('\n    Slick-Spray');
			case BoggSpray             (_)    : str.add('\n    Bogg-Spray');
			case DamageControlPackage  (_)    : str.add('\n    Damage Control Package');
			case QuickChangeMount      (_)    : str.add('\n    Quick Change Mount');
			case SilentRunning         (_)    : str.add('\n    Silent Running');
			case Parachute             (_)    : str.add('\n    Parachute');
			case ReEntryPackage        (_)    : str.add('\n    Re-Entry Package');
			case EjectionSeat          (_)    : str.add('\n    Ejection Seat');
			case EscapePod             (_)    : str.add('\n    Escape Pod');
			case ManeuverPod           (_)    : str.add('\n    Maneuver Pod');
			case VehiclePod            (_)    : str.add('\n    Vehicle Pod');
			case Cockpit               (_)    : str.add('\n    Cockpit');
			case Passenger             (_)    : str.add('\n    Passenger');
			case ExtraCrew             (_)    : str.add('\n    Extra Crew');
			case AdvancedSensorPackage (_)    : str.add('\n    Advanced Sensor Package');
			case RadioRadarAnalyzer    (_)    : str.add('\n    Radio/Radar Analyzer');
			case ResolutionIntensifiers(_)    : str.add('\n    Resolution Intensifiers');
			case SpottingRadar         (_)    : str.add('\n    Spotting Radar');
			case TargetAnalyzer        (_)    : str.add('\n    Target Analyzer');
			case MarineSuite           (_)    : str.add('\n    Marine Suite');
			case GravityLens           (_)    : str.add('\n    Gravity Lens');
			case MagneticResonance     (_)    : str.add('\n    Magnetic Resonance');
			case _: // Do Nothing
		}
		return str.toString();
	}

	static function printNameOption(opt: Option<String>) switch (opt) {
		case Some(n): return n;
		case None   : return '';
	}

	static function printOption(opt: Option<MekSys>) switch (opt) {
		case Some(ms): return printNames([ms]);
		case None    : return '\n      Empty';
	}

	static function printProperty(properties: Array<Property>) {
		var str = new StringBuf();
		for (p in properties) switch (p) {
			case Accuracy(n)      : str.add('\n  $n Accuracy');
			case AllPurpose       : str.add('\n  All-Purpose');
			case Ammo(ammo)       : str.add('\n  Ammo${printNames(ammo)}');
			case AntiMissile(b)   : str.add('\n  ${b ? 'Variable' : ''} Anti-Missile');
			case AntiPersonnel(b) : str.add('\n  ${b ? 'Variable' : ''} Anti-Personnel');
			case ArmorPiercing    : str.add('\n  Armor-Piercing');
			case AttackFactor(n)  : str.add('\n  $n Attack Factor');
			case Beaming(n)       : str.add('\n  $n Beaming');
			case BeamShield(b)    : str.add('\n  ${b ? 'Variable' : ''} Beam Shield');
			case BinderSpace(n,d) : str.add('\n  -$n/$d Binder Space');
			case Blast(n)         : str.add('\n  Blast $n');
			case BurstValue(n)    : str.add('\n  $n Burst Value');
			case ClipFed          : str.add('\n  Clip-Fed');
			case Clumsy           : str.add('\n  Clumsy');
			case CommRange(n)     : str.add('\n  $n Comm Range');
			case ControlRange(n)  : str.add('\n  $n Control Range');
			case Cost(v)          : str.add('\n  $v Cost');
			case Countermissile(b): str.add('\n  ${b ? 'Variable' : ''} Countermissile');
			case Damage(v)        : str.add('\n  $v Damage');
			case DefenseAbility(n): str.add('\n  $n Defense Ability');
			case Disruptor        : str.add('\n  Disruptor');
			case Entangle         : str.add('\n  Entangle');
			case Flare            : str.add('\n  Flare');
			case Foam             : str.add('\n  Foam');
			case Fragile          : str.add('\n  Fragile');
			case Fuse             : str.add('\n  Fuse');
			case Handy            : str.add('\n  Handy');
			case HighEx           : str.add('\n  High Explosive');
			case Hydro            : str.add('\n  Hydro');
			case Hyper            : str.add('\n  Hyper');
			case Hypervelocity    : str.add('\n  Hypervelocity');
			case Incendiary       : str.add('\n  Incendiary');
			case Interference     : str.add('\n  Interference');
			case Kills(v)         : str.add('\n  $v Kills');
			case Kinetic          : str.add('\n  Kinetic');
			case LongRange        : str.add('\n  Long Range');
			case MegaBeam         : str.add('\n  Mega Beam');
			case Mirror           : str.add('\n  Mirror');
			case Morphable        : str.add('\n  Morphable');
			case MultiFeed(n)     : str.add('\n  $n Multi-Feed');
			case Nuclear          : str.add('\n  Nuclear');
			case OperationRange(n): str.add('\n  $n Operation Range');
			case Paintball        : str.add('\n  Paintball');
			case Phalanx(b)       : str.add('\n  ${b ? 'Variable' : ''} Phalanx');
			case Power(n)         : str.add('\n  $n Power');
			case QualityValue(n)  : str.add('\n  $n Quality Value');
			case Quick            : str.add('\n  Quick');
			case Radius(n)        : str.add('\n  $n Radius');
			case Range(n)         : str.add('\n  $n Range');
			case Rechargeable     : str.add('\n  Rechargeable');
			case Reset(n)         : str.add('\n  $n Reset');
			case Returning        : str.add('\n  Returning');
			case Scatter          : str.add('\n  Scatter');
			case Scattershot      : str.add('\n  Scattershot');
			case Screen           : str.add('\n  Screen');
			case SensorRange(n)   : str.add('\n  $n Sensor Range');
			case Shock(b)         : str.add('\n  ${b ? 'Variable' : ''} Shock');
			case Shots(n)         : str.add('\n  $n Shots');
			case Skill(n)         : str.add('\n  $n Skill');
			case Smart(n)         : str.add('\n  $n Smart');
			case Smoke            : str.add('\n  Smoke');
			case Space(v)         : str.add('\n  $v Space');
			case StoppingPower(n) : str.add('\n  $n Stopping Power');
			case Surge            : str.add('\n  Surge');
			case Swashbuckling    : str.add('\n  Swashbuckling');
			case Tangler          : str.add('\n  Tangler');
			case Thrown           : str.add('\n  Thrown');
			case Tracer           : str.add('\n  Tracer');
			case TurnsInUse(n)    : str.add('\n  $n Turns In Use');
			case Value(n)         : str.add('\n  $n Value');
			case WarmUp(n)        : str.add('\n  $n Warm-Up');
			case WideAngle(n)     : str.add('\n  $n Wide Angle');
			case WireControlled   : str.add('\n  Wire-Controlled');
		}
		return str.toString();
	}
}