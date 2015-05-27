using com.mindrocks.functional.Functional;

using Armor;
using AST;

class MekPrinter {
	static public function printSystems(systems: Array<AST_MekSys>) {
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

	static function printShield(type: String, name: Option<String>, armor: Option<ArmorClass>, sizeClass: SizeClass, properties: Array<AST<AST_Property>>) {
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

	static function printAmmo(ammo: Array<String>) {
		var str = new StringBuf();
		for (a in ammo)
			str.add('\n    \'$a\'');
		return str.toString();
	}

	static function printProperty(properties: Array<AST<AST_Property>>) {
		var str = new StringBuf();
		for (a in properties) switch (a) {
			case Resolved(p): switch (p) {
				case AST_Accuracy(n)      : str.add('\n  $n Accuracy');
				case AST_AllPurpose       : str.add('\n  All-Purpose');
				case AST_Ammo(ammo)       : str.add('\n  Ammo${printAmmo(ammo)}');
				case AST_AntiMissile(b)   : str.add('\n  ${b ? 'Variable' : ''} Anti-Missile');
				case AST_AntiPersonnel(b) : str.add('\n  ${b ? 'Variable' : ''} Anti-Personnel');
				case AST_ArmorPiercing    : str.add('\n  Armor-Piercing');
				case AST_AttackFactor(n)  : str.add('\n  $n Attack Factor');
				case AST_Beaming(n)       : str.add('\n  $n Beaming');
				case AST_BeamShield(b)    : str.add('\n  ${b ? 'Variable' : ''} Beam Shield');
				case AST_BinderSpace(n,d) : str.add('\n  -$n/$d Binder Space');
				case AST_Blast(n)         : str.add('\n  Blast $n');
				case AST_BurstValue(n)    : str.add('\n  $n Burst Value');
				case AST_ClipFed          : str.add('\n  Clip-Fed');
				case AST_Clumsy           : str.add('\n  Clumsy');
				case AST_CommRange(n)     : str.add('\n  $n Comm Range');
				case AST_ControlRange(n)  : str.add('\n  $n Control Range');
				case AST_Cost(v)          : str.add('\n  $v Cost');
				case AST_Countermissile(b): str.add('\n  ${b ? 'Variable' : ''} Countermissile');
				case AST_Damage(v)        : str.add('\n  $v Damage');
				case AST_DefenseAbility(n): str.add('\n  $n Defense Ability');
				case AST_Disruptor        : str.add('\n  Disruptor');
				case AST_Entangle         : str.add('\n  Entangle');
				case AST_Flare            : str.add('\n  Flare');
				case AST_Foam             : str.add('\n  Foam');
				case AST_Fragile          : str.add('\n  Fragile');
				case AST_Fuse             : str.add('\n  Fuse');
				case AST_Handy            : str.add('\n  Handy');
				case AST_HighEx           : str.add('\n  High Explosive');
				case AST_Hydro            : str.add('\n  Hydro');
				case AST_Hyper            : str.add('\n  Hyper');
				case AST_Hypervelocity    : str.add('\n  Hypervelocity');
				case AST_Incendiary       : str.add('\n  Incendiary');
				case AST_Interference     : str.add('\n  Interference');
				case AST_Kills(v)         : str.add('\n  $v Kills');
				case AST_Kinetic          : str.add('\n  Kinetic');
				case AST_LongRange        : str.add('\n  Long Range');
				case AST_MegaBeam         : str.add('\n  Mega Beam');
				case AST_Mirror           : str.add('\n  Mirror');
				case AST_Morphable        : str.add('\n  Morphable');
				case AST_MultiFeed(n)     : str.add('\n  $n Multi-Feed');
				case AST_Nuclear          : str.add('\n  Nuclear');
				case AST_OperationRange(n): str.add('\n  $n Operation Range');
				case AST_Paintball        : str.add('\n  Paintball');
				case AST_Phalanx(b)       : str.add('\n  ${b ? 'Variable' : ''} Phalanx');
				case AST_Power(n)         : str.add('\n  $n Power');
				case AST_QualityValue(n)  : str.add('\n  $n Quality Value');
				case AST_Quick            : str.add('\n  Quick');
				case AST_Radius(n)        : str.add('\n  $n Radius');
				case AST_Range(n)         : str.add('\n  $n Range');
				case AST_Rechargeable     : str.add('\n  Rechargeable');
				case AST_Reset(n)         : str.add('\n  $n Reset');
				case AST_Returning        : str.add('\n  Returning');
				case AST_Scatter          : str.add('\n  Scatter');
				case AST_Scattershot      : str.add('\n  Scattershot');
				case AST_Screen           : str.add('\n  Screen');
				case AST_SensorRange(n)   : str.add('\n  $n Sensor Range');
				case AST_Shock(b)         : str.add('\n  ${b ? 'Variable' : ''} Shock');
				case AST_Shots(n)         : str.add('\n  $n Shots');
				case AST_Skill(n)         : str.add('\n  $n Skill');
				case AST_Smart(n)         : str.add('\n  $n Smart');
				case AST_Smoke            : str.add('\n  Smoke');
				case AST_Space(v)         : str.add('\n  $v Space');
				case AST_StoppingPower(n) : str.add('\n  $n Stopping Power');
				case AST_Surge            : str.add('\n  Surge');
				case AST_Swashbuckling    : str.add('\n  Swashbuckling');
				case AST_Tangler          : str.add('\n  Tangler');
				case AST_Thrown           : str.add('\n  Thrown');
				case AST_Tracer           : str.add('\n  Tracer');
				case AST_TurnsInUse(n)    : str.add('\n  $n Turns In Use');
				case AST_Value(n)         : str.add('\n  $n Value');
				case AST_WarmUp(n)        : str.add('\n  $n Warm-Up');
				case AST_WideAngle(n)     : str.add('\n  $n Wide Angle');
				case AST_WireControlled   : str.add('\n  Wire-Controlled');
			}
			case Unresolved(s): str.add('\'$s\'');
		}
		return str.toString();
	}
}