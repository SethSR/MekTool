using AST;
using MekSys;

typedef AST_Storage = {
	mektons: Array<AST_Mekton>,
	systems: Array<AST_MekSys>,
}

class Resolver {
	static var storage: AST_Storage;

	static public function resolve(ast: AST_Storage): Array<Mekton> {
		storage = ast;
		var mektons = new Array<Mekton>();
		for (m in storage.mektons) switch m {
			case AST_Mekton(name, servos, propulsion): mektons.push(Mekton(name, [for (s in servos) resolveServo(s)], propulsion));
		}
		return mektons;
	}

	static function resolveServo(servo: AST_Servo): Servo switch servo {
		case AST_Torso(sizeClass, armor, systems): return Torso(sizeClass, armor, [for (s in systems) resolveASTSystems(s)]);
		case AST_Head (sizeClass, armor, systems): return Head (sizeClass, armor, [for (s in systems) resolveASTSystems(s)]);
		case AST_Arm  (sizeClass, armor, systems): return Arm  (sizeClass, armor, [for (s in systems) resolveASTSystems(s)]);
		case AST_Leg  (sizeClass, armor, systems): return Leg  (sizeClass, armor, [for (s in systems) resolveASTSystems(s)]);
		case AST_Wing (sizeClass, armor, systems): return Wing (sizeClass, armor, [for (s in systems) resolveASTSystems(s)]);
		case AST_Tail (sizeClass, armor, systems): return Tail (sizeClass, armor, [for (s in systems) resolveASTSystems(s)]);
		case AST_Pod  (sizeClass, armor, systems): return Pod  (sizeClass, armor, [for (s in systems) resolveASTSystems(s)]);
	}

	static function resolveASTSystem(name: String): MekSys {
		for (s in storage.systems) switch s {
			case AST_Reflector  (n, properties): if (name == n) return Reflector  (n, [for (p in properties) resolveASTProperty(p)]);
			case AST_Ammo       (n, properties): if (name == n) return Ammo       (n, [for (p in properties) resolveASTProperty(p)]);
			case AST_SensorECM  (n, properties): if (name == n) return SensorECM  (n, [for (p in properties) resolveASTProperty(p)]);
			case AST_MissileECM (n, properties): if (name == n) return MissileECM (n, [for (p in properties) resolveASTProperty(p)]);
			case AST_RadarECM   (n, properties): if (name == n) return RadarECM   (n, [for (p in properties) resolveASTProperty(p)]);
			case AST_CounterECM (n, properties): if (name == n) return CounterECM (n, [for (p in properties) resolveASTProperty(p)]);
			case AST_Beam       (n, properties): if (name == n) return Beam       (n, [for (p in properties) resolveASTProperty(p)]);
			case AST_EnergyMelee(n, properties): if (name == n) return EnergyMelee(n, [for (p in properties) resolveASTProperty(p)]);
			case AST_Melee      (n, properties): if (name == n) return Melee      (n, [for (p in properties) resolveASTProperty(p)]);
			case AST_Missile    (n, properties): if (name == n) return Missile    (n, [for (p in properties) resolveASTProperty(p)]);
			case AST_Projectile (n, properties): if (name == n) return Projectile (n, [for (p in properties) resolveASTProperty(p)]);

			case AST_StandardShield(Some(n), armor, sizeClass, properties): if (name == n) return StandardShield(Some(n), armor, sizeClass, [for (p in properties) resolveASTProperty(p)]);
			case AST_ActiveShield  (Some(n), armor, sizeClass, properties): if (name == n) return ActiveShield  (Some(n), armor, sizeClass, [for (p in properties) resolveASTProperty(p)]);
			case AST_ReactiveShield(Some(n), armor, sizeClass, properties): if (name == n) return ReactiveShield(Some(n), armor, sizeClass, [for (p in properties) resolveASTProperty(p)]);

			case AST_StandardShield(None, armor, sizeClass, properties): return StandardShield(None, armor, sizeClass, [for (p in properties) resolveASTProperty(p)]);
			case AST_ActiveShield  (None, armor, sizeClass, properties): return ActiveShield  (None, armor, sizeClass, [for (p in properties) resolveASTProperty(p)]);
			case AST_ReactiveShield(None, armor, sizeClass, properties): return ReactiveShield(None, armor, sizeClass, [for (p in properties) resolveASTProperty(p)]);

			case AST_RemoteControl(n, sizeClass, properties): if (name == n) return RemoteControl(n, sizeClass, [for (p in properties) resolveASTProperty(p)]);
			case AST_Sensor       (n, sizeClass, properties): if (name == n) return Sensor       (n, sizeClass, [for (p in properties) resolveASTProperty(p)]);

			case AST_EnergyPool (n, properties, systems): if (name == n)
				return EnergyPool(name,
					[for (p in properties) resolveASTProperty(p)],
					[for (s in systems) resolveASTSystems(s)]);
			case AST_MatedSystem(n, systems, properties): if (name == n)
				return MatedSystem(name,
					[for (s in systems) resolveASTSystems(s)],
					[for (p in properties) resolveASTProperty(p)]);
			case _: // Do Nothing
		}
		throw 'System not found: $name';
	}

	static function resolveASTSystems(ast_system: AST<AST_MekSys>): MekSys switch ast_system {
		case Resolved(system): return resolveSystem(system);
		case Unresolved(n):    return resolveASTSystem(n);
	}

	static function resolveSystem(system: AST_MekSys): MekSys switch system {
		case AST_Reflector  (name, properties): return Reflector  (name, [for (p in properties) resolveASTProperty(p)]);
		case AST_Ammo       (name, properties): return Ammo       (name, [for (p in properties) resolveASTProperty(p)]);
		case AST_SensorECM  (name, properties): return SensorECM  (name, [for (p in properties) resolveASTProperty(p)]);
		case AST_MissileECM (name, properties): return MissileECM (name, [for (p in properties) resolveASTProperty(p)]);
		case AST_RadarECM   (name, properties): return RadarECM   (name, [for (p in properties) resolveASTProperty(p)]);
		case AST_CounterECM (name, properties): return CounterECM (name, [for (p in properties) resolveASTProperty(p)]);
		case AST_Beam       (name, properties): return Beam       (name, [for (p in properties) resolveASTProperty(p)]);
		case AST_EnergyMelee(name, properties): return EnergyMelee(name, [for (p in properties) resolveASTProperty(p)]);
		case AST_Melee      (name, properties): return Melee      (name, [for (p in properties) resolveASTProperty(p)]);
		case AST_Missile    (name, properties): return Missile    (name, [for (p in properties) resolveASTProperty(p)]);
		case AST_Projectile (name, properties): return Projectile (name, [for (p in properties) resolveASTProperty(p)]);
		case AST_EnergyPool (name, properties, systems):
			return EnergyPool(
				name,
				[for (p in properties) resolveASTProperty(p)],
				[for (s in systems) resolveASTSystems(s)]);

		case AST_StandardShield(name, armor, sizeClass, properties): return StandardShield(name, armor, sizeClass, [for (p in properties) resolveASTProperty(p)]);
		case AST_ActiveShield  (name, armor, sizeClass, properties): return ActiveShield(name, armor, sizeClass, [for (p in properties) resolveASTProperty(p)]);
		case AST_ReactiveShield(name, armor, sizeClass, properties): return ReactiveShield(name, armor, sizeClass, [for (p in properties) resolveASTProperty(p)]);

		case AST_Mount(system, properties):
			var sys = resolveASTSystems(system);
			return Mount(sys != null ? Some(sys) : None, [for (p in properties) resolveASTProperty(p)]);
		case AST_Hand (system, properties):
			var sys = resolveASTSystems(system);
			return Hand(sys != null ? Some(sys) : None, [for (p in properties) resolveASTProperty(p)]);

		case AST_MatedSystem(name, systems, properties):
			return MatedSystem(
				name,
				[for (s in systems) resolveASTSystems(s)],
				[for (p in properties) resolveASTProperty(p)]);

		case AST_RemoteControl(name, sizeClass, properties): return RemoteControl(name, sizeClass, [for (p in properties) resolveASTProperty(p)]);
		case AST_Sensor       (name, sizeClass, properties): return Sensor       (name, sizeClass, [for (p in properties) resolveASTProperty(p)]);

		case AST_Stereo                (properties): return Stereo                ([for (p in properties) resolveASTProperty(p)]);
		case AST_Liftwire              (properties): return Liftwire              ([for (p in properties) resolveASTProperty(p)]);
		case AST_AntiTheftCodeLock     (properties): return AntiTheftCodeLock     ([for (p in properties) resolveASTProperty(p)]);
		case AST_Spotlights            (properties): return Spotlights            ([for (p in properties) resolveASTProperty(p)]);
		case AST_Nightlights           (properties): return Nightlights           ([for (p in properties) resolveASTProperty(p)]);
		case AST_StorageModule         (properties): return StorageModule         ([for (p in properties) resolveASTProperty(p)]);
		case AST_Micromanipulators     (properties): return Micromanipulators     ([for (p in properties) resolveASTProperty(p)]);
		case AST_SlickSpray            (properties): return SlickSpray            ([for (p in properties) resolveASTProperty(p)]);
		case AST_BoggSpray             (properties): return BoggSpray             ([for (p in properties) resolveASTProperty(p)]);
		case AST_DamageControlPackage  (properties): return DamageControlPackage  ([for (p in properties) resolveASTProperty(p)]);
		case AST_QuickChangeMount      (properties): return QuickChangeMount      ([for (p in properties) resolveASTProperty(p)]);
		case AST_SilentRunning         (properties): return SilentRunning         ([for (p in properties) resolveASTProperty(p)]);
		case AST_Parachute             (properties): return Parachute             ([for (p in properties) resolveASTProperty(p)]);
		case AST_ReEntryPackage        (properties): return ReEntryPackage        ([for (p in properties) resolveASTProperty(p)]);
		case AST_EjectionSeat          (properties): return EjectionSeat          ([for (p in properties) resolveASTProperty(p)]);
		case AST_EscapePod             (properties): return EscapePod             ([for (p in properties) resolveASTProperty(p)]);
		case AST_ManeuverPod           (properties): return ManeuverPod           ([for (p in properties) resolveASTProperty(p)]);
		case AST_VehiclePod            (properties): return VehiclePod            ([for (p in properties) resolveASTProperty(p)]);
		case AST_Cockpit               (properties): return Cockpit               ([for (p in properties) resolveASTProperty(p)]);
		case AST_Passenger             (properties): return Passenger             ([for (p in properties) resolveASTProperty(p)]);
		case AST_ExtraCrew             (properties): return ExtraCrew             ([for (p in properties) resolveASTProperty(p)]);
		case AST_AdvancedSensorPackage (properties): return AdvancedSensorPackage ([for (p in properties) resolveASTProperty(p)]);
		case AST_RadioRadarAnalyzer    (properties): return RadioRadarAnalyzer    ([for (p in properties) resolveASTProperty(p)]);
		case AST_ResolutionIntensifiers(properties): return ResolutionIntensifiers([for (p in properties) resolveASTProperty(p)]);
		case AST_SpottingRadar         (properties): return SpottingRadar         ([for (p in properties) resolveASTProperty(p)]);
		case AST_TargetAnalyzer        (properties): return TargetAnalyzer        ([for (p in properties) resolveASTProperty(p)]);
		case AST_MarineSuite           (properties): return MarineSuite           ([for (p in properties) resolveASTProperty(p)]);
		case AST_GravityLens           (properties): return GravityLens           ([for (p in properties) resolveASTProperty(p)]);
		case AST_MagneticResonance     (properties): return MagneticResonance     ([for (p in properties) resolveASTProperty(p)]);
	}

	static function resolveASTProperty(ast_property: AST<AST_Property>): Property switch ast_property {
		case Resolved(property): return resolveProperty(property);
		case Unresolved(name): throw 'unfinished';
	}

	static function resolveProperty(property: AST_Property): Property switch property {
		case AST_Accuracy(n)      : return Accuracy(n);
		case AST_AllPurpose       : return AllPurpose;
		case AST_Ammo(ammo)       : return Property.Ammo([for (a in ammo) resolveAmmo(a)]);
		case AST_AntiMissile(b)   : return AntiMissile(b);
		case AST_AntiPersonnel(b) : return AntiPersonnel(b);
		case AST_ArmorPiercing    : return ArmorPiercing;
		case AST_AttackFactor(n)  : return AttackFactor(n);
		case AST_Beaming(n)       : return Beaming(n);
		case AST_BeamShield(b)    : return BeamShield(b);
		case AST_BinderSpace(n,d) : return BinderSpace(n,d);
		case AST_Blast(n)         : return Blast(n);
		case AST_BurstValue(n)    : return BurstValue(n);
		case AST_ClipFed          : return ClipFed;
		case AST_Clumsy           : return Clumsy;
		case AST_CommRange(n)     : return CommRange(n);
		case AST_ControlRange(n)  : return ControlRange(n);
		case AST_Cost(v)          : return Cost(v);
		case AST_Countermissile(b): return Countermissile(b);
		case AST_Damage(v)        : return Damage(v);
		case AST_DefenseAbility(n): return DefenseAbility(n);
		case AST_Disruptor        : return Disruptor;
		case AST_Entangle         : return Entangle;
		case AST_Flare            : return Flare;
		case AST_Foam             : return Foam;
		case AST_Fragile          : return Fragile;
		case AST_Fuse             : return Fuse;
		case AST_Handy            : return Handy;
		case AST_HighEx           : return HighEx;
		case AST_Hydro            : return Hydro;
		case AST_Hyper            : return Hyper;
		case AST_Hypervelocity    : return Hypervelocity;
		case AST_Incendiary       : return Incendiary;
		case AST_Interference     : return Interference;
		case AST_Kills(v)         : return Kills(v);
		case AST_Kinetic          : return Kinetic;
		case AST_LongRange        : return LongRange;
		case AST_MegaBeam         : return MegaBeam;
		case AST_Mirror           : return Mirror;
		case AST_Morphable        : return Morphable;
		case AST_MultiFeed(n)     : return MultiFeed(n);
		case AST_Nuclear          : return Nuclear;
		case AST_OperationRange(n): return OperationRange(n);
		case AST_Paintball        : return Paintball;
		case AST_Phalanx(b)       : return Phalanx(b);
		case AST_Power(n)         : return Power(n);
		case AST_QualityValue(n)  : return QualityValue(n);
		case AST_Quick            : return Quick;
		case AST_Radius(n)        : return Radius(n);
		case AST_Range(n)         : return Range(n);
		case AST_Rechargeable     : return Rechargeable;
		case AST_Reset(n)         : return Reset(n);
		case AST_Returning        : return Returning;
		case AST_Scatter          : return Scatter;
		case AST_Scattershot      : return Scattershot;
		case AST_Screen           : return Screen;
		case AST_SensorRange(n)   : return SensorRange(n);
		case AST_Shock(b)         : return Shock(b);
		case AST_Shots(n)         : return Shots(n);
		case AST_Skill(n)         : return Skill(n);
		case AST_Smart(n)         : return Smart(n);
		case AST_Smoke            : return Smoke;
		case AST_Space(v)         : return Space(v);
		case AST_StoppingPower(n) : return StoppingPower(n);
		case AST_Surge            : return Surge;
		case AST_Swashbuckling    : return Swashbuckling;
		case AST_Tangler          : return Tangler;
		case AST_Thrown           : return Thrown;
		case AST_Tracer           : return Tracer;
		case AST_TurnsInUse(n)    : return TurnsInUse(n);
		case AST_Value(n)         : return Value(n);
		case AST_WarmUp(n)        : return WarmUp(n);
		case AST_WideAngle(n)     : return WideAngle(n);
		case AST_WireControlled   : return WireControlled;
	}

	static function resolveAmmo(ammo: String): MekSys {
		for (s in storage.systems) switch s {
			case AST_Ammo(name, properties): if (name == ammo) return Ammo(name, [for (p in properties) resolveASTProperty(p)]);
			case _: // This is an error
		}
		throw 'Ammo not found: $ammo';
	}
}