import haxe.Timer;

import com.mindrocks.functional.Functional;

using com.mindrocks.text.Parser;
using com.mindrocks.macros.LazyMacro;

using Type;

import MekTokens.*;
import AST;

using Armor;
using Armor.ArmorClass;
using SizeClass;

@:allow(MekTest)
class MekParser {
	static function tryParse<T>(str: String, parser: Parser<String, T>, withResult: T -> Void, output: String -> Void) {
		try {
			var res = Timer.measure(function () return parser(str.reader()));

			switch (res) {
				case Success(res, rest):
					var remaining = rest.rest();
					if (StringTools.trim(remaining).length == 0) {
						trace ('success!');
					} else {
						trace ('cannot parse ' + remaining);
					}
					withResult(res);
				case Failure(err, rest, _):
					var p = rest.textAround();
					output(p.text);
					output(p.indicator);
					err.map(function (error) {
						output('Error at ' + error.pos + ' : ' + error.msg);
					});
			}
		} catch (e: Dynamic) {
			trace ('Error ' + Std.string(e));
		}
	}

	static public function test(str: String) {
		function toOutput(str: String) {
			trace (StringTools.replace(str, ' ', '_'));
		}

		tryParse(
			str,
			fileP(),
			function (res) trace ('Parsed ' + Std.string(res)),
			toOutput
		);
	}

	static var resolved_systems: Map<String, Map<String, MekSys>> = [
		'beam'        => new Map<String, MekSys>(),
		'energyMelee' => new Map<String, MekSys>(),
		'melee'       => new Map<String, MekSys>(),
		'missile'     => new Map<String, MekSys>(),
		'projectile'  => new Map<String, MekSys>(),
		'energyPool'  => new Map<String, MekSys>(),
		'ammo'        => new Map<String, MekSys>(),
		'mated'       => new Map<String, MekSys>(),
		'shield'      => new Map<String, MekSys>(),
		'reflector'   => new Map<String, MekSys>(),
		'sensor'      => new Map<String, MekSys>(),
		'electronic'  => new Map<String, MekSys>(),
		'remote'      => new Map<String, MekSys>(),
	];
	// static var resolved_mektons = new Array<Mekton>();

	static function resolve(c: String, s: String, ms: MekSys) {
		var mek_map = resolved_systems.get(c);
		if (!mek_map.exists(s))
			mek_map.set(s, ms);
		else
			trace (s + ' already defined!');
	}

	static function get(c: String, s: String)
		return Parsers.success(resolved_systems.exists(c) ? resolved_systems.get(c).exists(s) ? resolved_systems.get(c).get(s) : null : null);

	static function p<T>(s: String): T -> String
		return function (t: T) return 'parsed ' + s;

	static var ast = {
		mektons: new Array<AST_Mekton>(),
		systems: new Array<AST_MekSys>(),
	};


	/************
	 *  Parser  *
	 ***********/
	static var fileP = definitionP.many().commit().lazyF();

	static var definitionP = [
		mektonDefP.then(function (p) ast.mektons.push(AST_Mekton(p.a, p.b))),
		systemDefP.then(function (p) ast.systems.push(p)),
	].ors().lazyF();

	static var mektonDefP = mektonT._and(nameDeclP).band(servoP.many()).trace(p('Mekton')).tag('Mekton').lazyF();

	static var servoP = [
		sizeClassP.band(torsoT.trace(p('Torso'))._and(armorP.band(systemDeclP.many()))).then(function (p) return Torso(p.a, p.b.a, p.b.b)),
		sizeClassP.band(headT .trace(p('Head' ))._and(armorP.band(systemDeclP.many()))).then(function (p) return Head (p.a, p.b.a, p.b.b)),
		sizeClassP.band(armT  .trace(p('Arm'  ))._and(armorP.band(systemDeclP.many()))).then(function (p) return Arm  (p.a, p.b.a, p.b.b)),
		sizeClassP.band(legT  .trace(p('Leg'  ))._and(armorP.band(systemDeclP.many()))).then(function (p) return Leg  (p.a, p.b.a, p.b.b)),
		sizeClassP.band(tailT .trace(p('Tail' ))._and(armorP.band(systemDeclP.many()))).then(function (p) return Tail (p.a, p.b.a, p.b.b)),
		sizeClassP.band(wingT .trace(p('Wing' ))._and(armorP.band(systemDeclP.many()))).then(function (p) return Wing (p.a, p.b.a, p.b.b)),
		sizeClassP.band(podT  .trace(p('Pod'  ))._and(armorP.band(systemDeclP.many()))).then(function (p) return Pod  (p.a, p.b.a, p.b.b)),
	].ors().tag('Servo').lazyF();

	static var sizeClassP = [
		superlightT           .trace(p('Superlight'   )).then(function (p) return Superlight   ),
		lightweightT          .trace(p('Lightweight'  )).then(function (p) return Lightweight  ),
		strikerT              .trace(p('Striker'      )).then(function (p) return Striker      ),
		mediumT._and(strikerT).trace(p('MediumStriker')).then(function (p) return MediumStriker),
		heavyT._and(strikerT) .trace(p('HeavyStriker' )).then(function (p) return HeavyStriker ),
		mediumweightT         .trace(p('Mediumweight' )).then(function (p) return Mediumweight ),
		lightT._and(heavyT)   .trace(p('LightHeavy'   )).then(function (p) return LightHeavy   ),
		mediumT._and(heavyT)  .trace(p('MediumHeavy'  )).then(function (p) return MediumHeavy  ),
		armoredT._and(heavyT) .trace(p('ArmoredHeavy' )).then(function (p) return ArmoredHeavy ),
		superT._and(heavyT)   .trace(p('SuperHeavy'   )).then(function (p) return SuperHeavy   ),
		megaT._and(heavyT)    .trace(p('MegaHeavy'    )).then(function (p) return MegaHeavy    ),
	].ors().tag('Size Class').lazyF();

	static var armorP = [
		sizeClassP.band(armorClassP.band(ramT._and(numberP.band(slashT._and(numberP))))).trace(p('RAM Armor')).then(function (p) return RAMArmor     (p.a, p.b.a, Std.parseInt(p.b.b.a), Std.parseInt(p.b.b.b))),
		sizeClassP.band(armorClassP).and_(armorT)                                       .trace(p('Armor'    )).then(function (p) return StandardArmor(p.a, p.b)),
		sizeClassP.band(ramT._and(numberP.band(slashT._and(numberP))))                  .trace(p('RAM Armor')).then(function (p) return RAMArmor     (p.a, Standard, Std.parseInt(p.b.a), Std.parseInt(p.b.b))),
		sizeClassP.and_(armorT)                                                         .trace(p('Armor'    )).then(function (p) return StandardArmor(p, Standard)),
	].ors().tag('Armor type').lazyF();

	static var armorClassP = [
		ablativeT.trace(p('Ablative')).then(function (p) return ArmorClass.Ablative),
		standardT.trace(p('Standard')).then(function (p) return ArmorClass.Standard),
		alphaT   .trace(p('Alpha'   )).then(function (p) return ArmorClass.Alpha   ),
		betaT    .trace(p('Beta'    )).then(function (p) return ArmorClass.Beta    ),
		gammaT   .trace(p('Gamma'   )).then(function (p) return ArmorClass.Gamma   ),
	].ors().tag('Armor Class').lazyF();

	static var nameDeclP = colonT._and(quoteT._and(identifierP.and_(quoteT))).lazyF();

	static var systemDeclP = [
		weaponDeclP   ,
		// ammoDeclP     ,
		// matedDeclP    ,
		// shieldDeclP   ,
		// reflectorDeclP,
		// sensorDeclP   ,
		// elecWarDeclP  ,
		// remoteDeclP   ,
		mountDeclP    ,
		handDeclP     ,
		crewDeclP     ,
		reconSysDeclP ,
		optionDeclP   ,
	].ors().lazyF();

	static var weaponDeclP = [
		nameDeclP.trace(p('Beam')       ),
		nameDeclP.trace(p('EnergyMelee')),
		nameDeclP.trace(p('Melee')      ),
		nameDeclP.trace(p('Missile')    ),
		nameDeclP.trace(p('Projectile') ),
		nameDeclP.trace(p('EnergyPool') ),
	].ors().then(function (p) return Unresolved(p)).lazyF();

	static var mountDeclP = [
		mountT._and(mountSystemP).band(systemPropP.many()).trace(p('Mount')).then(function (p) return Resolved(Mount(p.a , p.b))),
		mountT.band(emptyT)._and(systemPropP.many())      .trace(p('Mount')).then(function (p) return Resolved(Mount(null, p  ))),
	].ors().lazyF();

	static var mountSystemP = [
		weaponDeclP   .trace(p('Weapon')),
		// nameDeclP     .trace(p('Ammo')),
		// nameDeclP    .trace(p('Mated')),
		// nameDeclP   .trace(p('Shield')),
		// nameDeclP.trace(p('Reflector')),
		// nameDeclP   .trace(p('Sensor')),
		// nameDeclP  .trace(p('ElecWar')),
		// nameDeclP   .trace(p('Remote')),
		crewDeclP     .trace(p('Crew')),
		reconSysDeclP .trace(p('ReconSys')),
		optionDeclP   .trace(p('Option')),
	].ors().trace(p('Mount System')).lazyF();

	static var crewDeclP = [
		cockpitT          ._and(systemPropP.many()).trace(p('Cockpit'   )).then(function (p) return Resolved(Cockpit  (p))),
		passengerT        ._and(systemPropP.many()).trace(p('Passenger' )).then(function (p) return Resolved(Passenger(p))),
		extraT._and(crewT)._and(systemPropP.many()).trace(p('Extra Crew')).then(function (p) return Resolved(ExtraCrew(p))),
	].ors().lazyF();

	static var optionDeclP = [
		stereoT._and                              (systemPropP.many()).trace(p('Stereo'                )).then(function (p) return Resolved(Stereo              (p))),
		liftwireT._and                            (systemPropP.many()).trace(p('Liftwire'              )).then(function (p) return Resolved(Liftwire            (p))),
		antiTheftT._and(codeT.band(lockT))._and   (systemPropP.many()).trace(p('Anti-Theft Code Lock'  )).then(function (p) return Resolved(AntiTheftCodeLock   (p))),
		spotlightsT._and                          (systemPropP.many()).trace(p('Spotlights'            )).then(function (p) return Resolved(Spotlights          (p))),
		nightlightsT._and                         (systemPropP.many()).trace(p('Nightlights'           )).then(function (p) return Resolved(Nightlights         (p))),
		storageT._and(moduleT)._and               (systemPropP.many()).trace(p('Storage Module'        )).then(function (p) return Resolved(StorageModule       (p))),
		micromanipulatorsT._and                   (systemPropP.many()).trace(p('Micromanipulators'     )).then(function (p) return Resolved(Micromanipulators   (p))),
		slickSprayT._and                          (systemPropP.many()).trace(p('Slick Spray'           )).then(function (p) return Resolved(SlickSpray          (p))),
		boggSprayT._and                           (systemPropP.many()).trace(p('Bogg Spray'            )).then(function (p) return Resolved(BoggSpray           (p))),
		damageT._and(controlT.band(packageT))._and(systemPropP.many()).trace(p('Damage Control Package')).then(function (p) return Resolved(DamageControlPackage(p))),
		quickT._and(changeT.band(mountT))._and    (systemPropP.many()).trace(p('Quick Change Mount'    )).then(function (p) return Resolved(QuickChangeMount    (p))),
		silentT._and(runningT)._and               (systemPropP.many()).trace(p('Silent Running'        )).then(function (p) return Resolved(SilentRunning       (p))),
		parachuteT._and                           (systemPropP.many()).trace(p('Parachute'             )).then(function (p) return Resolved(Parachute           (p))),
		reEntryT._and(packageT)._and              (systemPropP.many()).trace(p('Re-Entry Package'      )).then(function (p) return Resolved(ReEntryPackage      (p))),
		ejectionT._and(seatT)._and                (systemPropP.many()).trace(p('Ejection Seat'         )).then(function (p) return Resolved(EjectionSeat        (p))),
		escapeT._and(podT)._and                   (systemPropP.many()).trace(p('Escape Pod'            )).then(function (p) return Resolved(EscapePod           (p))),
		maneuverT._and(podT)._and                 (systemPropP.many()).trace(p('Maneuver Pod'          )).then(function (p) return Resolved(ManeuverPod         (p))),
		vehicleT._and(podT)._and                  (systemPropP.many()).trace(p('Vehicle Pod'           )).then(function (p) return Resolved(VehiclePod          (p))),
	].ors().lazyF();


	static var handDeclP = [
		handT._and(handSystemP).band(systemPropP.many()).trace(p('Hand')).then(function (p) return Resolved(Hand(p.a , p.b))),
		handT.band(emptyT)._and(systemPropP.many())     .trace(p('Hand')).then(function (p) return Resolved(Hand(null, p  ))),
	].ors().lazyF();

	static var handSystemP = [
		weaponDeclP   ,
		// ammoDeclP     ,
		// matedDeclP    ,
		// shieldDeclP   ,
		// reflectorDeclP,
		// sensorDeclP   ,
		// elecWarDeclP  ,
		// remoteDeclP   ,
		crewDeclP     ,
		reconSysDeclP ,
		optionDeclP   ,
	].ors().lazyF();

	static var reconSysDeclP = [
		advancedT._and(sensorT.band(packageT))._and          (systemPropP.many()).trace(p('Advanced Sensor Package')).then(function (p) return Resolved(AdvancedSensorPackage (p))),
		radioT._and(slashT.band(radarT).band(analyzerT))._and(systemPropP.many()).trace(p('Radio Radar Analyzer'   )).then(function (p) return Resolved(RadioRadarAnalyzer    (p))),
		resolutionT._and(intensifiersT)._and                 (systemPropP.many()).trace(p('Resolution Intensifiers')).then(function (p) return Resolved(ResolutionIntensifiers(p))),
		spottingT._and(radarT)._and                          (systemPropP.many()).trace(p('Spotting Radar'         )).then(function (p) return Resolved(SpottingRadar         (p))),
		targetT._and(analyzerT)._and                         (systemPropP.many()).trace(p('Target Analyzer'        )).then(function (p) return Resolved(TargetAnalyzer        (p))),
		marineT._and(suiteT)._and                            (systemPropP.many()).trace(p('Marine Suite'           )).then(function (p) return Resolved(MarineSuite           (p))),
		gravityT._and(lensT)._and                            (systemPropP.many()).trace(p('Gravity Lens'           )).then(function (p) return Resolved(GravityLens           (p))),
		magneticT._and(resonanceT)._and                      (systemPropP.many()).trace(p('Magnetic Resonance'     )).then(function (p) return Resolved(MagneticResonance     (p))),
	].ors().lazyF();

	static var energyPoolSystemP = [
		weaponDeclP,
		// shieldDeclP,
	].ors().lazyF();

	static var systemDefP = [
		weaponDefP       ,
		ammoDefP         ,
		matedSystemDefP  ,
		shieldDefP       ,
		reflectorDefP    ,
		sensorDefP       ,
		elecWarDefP      ,
		remoteControlDefP,
	].ors().lazyF();

	static var weaponDefP = [
		beamDefP,
		energyMeleeDefP,
		meleeDefP,
		missileDefP,
		projectileDefP,
		energyPoolDefP,
	].ors().lazyF();

	static var beamDefP        = beamT._and(nameDeclP.band(damagePropP.band(beamPropP.many())))                      .trace(p('')).then(function (p) return Beam       (p.a, p.b.b)).lazyF();
	static var energyMeleeDefP = energyT._and(meleeT._and(nameDeclP.band(damagePropP.band(energyMeleePropP.many())))).trace(p('')).then(function (p) return EnergyMelee(p.a, p.b.b)).lazyF();
	static var meleeDefP       = meleeT._and(nameDeclP.band(damagePropP.band(meleePropP.many())))                    .trace(p('')).then(function (p) return Melee      (p.a, p.b.b)).lazyF();
	static var missileDefP     = missileT._and(nameDeclP.band(damagePropP.band(missilePropP.many())))                .trace(p('')).then(function (p) return Missile    (p.a, p.b.b)).lazyF();
	static var projectileDefP  = projectileT._and(nameDeclP.band(damagePropP.band(projectilePropP.many())))          .trace(p('')).then(function (p) return Projectile (p.a, p.b.b)).lazyF();
	static var energyPoolDefP  = energyT._and(poolT._and(nameDeclP.band(powerPropP.band(energyPoolPropP.many().band(energyPoolSystemP.many()))))).trace(p('')).then(function (p) return EnergyPool (p.a, p.b.b.a, p.b.b.b)).lazyF();

	static var ammoDefP          = ammoT._and(nameDeclP).band(ammoPropP.many())                                           .trace(p('')).then(function (p) return Ammo       (p.a, p.b)).lazyF();
	static var matedSystemDefP   = matedT._and(nameDeclP.band(systemPropP.many().band(systemDeclP.band(systemDeclP))))    .trace(p('')).then(function (p) return MatedSystem(p.a, [p.b.b.a, p.b.b.b], p.b.a)).lazyF();
	static var reflectorDefP     = reflectorT._and(nameDeclP.band(qualityValuePropP.band(systemPropP.many())))            .trace(p('')).then(function (p) { p.b.b.push(p.b.a); return Reflector  (p.a, p.b.b); }).lazyF();
	static var sensorDefP        = sizeClassP.band(sensorT._and(nameDeclP.band(sensorPropP.many())))                      .trace(p('')).then(function (p) return Sensor     (p.b.a, p.a, p.b.b)).lazyF();
	static var elecWarDefP       = [
		sensorT._and(ecmT) ._and(nameDeclP).band(valuePropP.band(ecmPropP.many())).trace(p('Sensor ECM' )).then(function (p) { p.b.b.push(p.b.a); return SensorECM (p.a, p.b.b); }),
		missileT._and(ecmT)._and(nameDeclP).band(valuePropP.band(ecmPropP.many())).trace(p('Missile ECM')).then(function (p) { p.b.b.push(p.b.a); return MissileECM(p.a, p.b.b); }),
		radarT._and(ecmT)  ._and(nameDeclP).band(valuePropP.band(ecmPropP.many())).trace(p('Radar ECM'  )).then(function (p) { p.b.b.push(p.b.a); return RadarECM  (p.a, p.b.b); }),
		eccmT              ._and(nameDeclP).band(valuePropP.band(ecmPropP.many())).trace(p('Counter ECM')).then(function (p) { p.b.b.push(p.b.a); return CounterECM(p.a, p.b.b); }),
	].ors().lazyF();
	static var remoteControlDefP = sizeClassP.band(remoteT._and(controlT)._and(nameDeclP).band(remoteControlPropP.many())).trace(p('')).then(function (p) return RemoteControl(p.b.a, p.a, p.b.b)).lazyF();

	static var shieldDefP = [
		standardT._and(armorClassP.option().band(sizeClassP.and_(shieldT))).band(nameDeclP.band(shieldPropP.many())).trace(p('Standard Shield')).then(function (p) return StandardShield(Some(p.b.a), p.a.a, p.a.b, p.b.b)),
		activeT  ._and(armorClassP.option().band(sizeClassP.and_(shieldT))).band(nameDeclP.band(shieldPropP.many())).trace(p('Active Shield'  )).then(function (p) return ActiveShield  (Some(p.b.a), p.a.a, p.a.b, p.b.b)),
		reactiveT._and(armorClassP.option().band(sizeClassP.and_(shieldT))).band(nameDeclP.band(shieldPropP.many())).trace(p('Reactive Shield')).then(function (p) return ReactiveShield(Some(p.b.a), p.a.a, p.a.b, p.b.b)),
		               armorClassP.option().band(sizeClassP.and_(shieldT)) .band(nameDeclP.band(shieldPropP.many())).trace(p('Standard Shield')).then(function (p) return StandardShield(Some(p.b.a), p.a.a, p.a.b, p.b.b)),
	].ors().lazyF();

	static var shieldNoNameDefP = [
		standardT.option().band(armorClassP.option().band(sizeClassP.and_(shieldT))).band(shieldPropP.many()).trace(p('Standard Shield')).then(function (p) trace ('Parsing a shield definition')),
		activeT  .option().band(armorClassP.option().band(sizeClassP.and_(shieldT))).band(shieldPropP.many()).trace(p('Active Shield'  )).then(function (p) trace ('Parsing a shield definition')),
		reactiveT.option().band(armorClassP.option().band(sizeClassP.and_(shieldT))).band(shieldPropP.many()).trace(p('Reactive Shield')).then(function (p) trace ('Parsing a shield definition')),
	].ors().lazyF();

	static var shieldTypeP = [
		standardT,
		activeT,
		reactiveT,
	].ors().lazyF();



	/********************************
	*                               *
	*    System Property Parsers    *
	*                               *
	********************************/
	static var systemPropP = [
		costPropP ,
		spacePropP,
		killsPropP,
	].ors().lazyF();

	static var beamPropP = [
		systemPropP,
		accuracyPropP,
		rangePropP,
		shotsPropP,
		warmUpPropP,
		wideAnglePropP,
		burstValuePropP,
		antiMissilePropP,
		antiPersonnelPropP,
		allPurposePropP,
		clipFedPropP,
		megaBeamPropP,
		longRangePropP,
		fragilePropP,
		disruptorPropP,
		hydroPropP,
	].ors().lazyF();

	static var energyMeleePropP = [
		systemPropP,
		accuracyPropP,
		attackFactorPropP,
		turnsInUsePropP,
		beamShieldPropP,
		rechargeablePropP,
		thrownPropP,
		quickPropP,
		hyperPropP,
	].ors().lazyF();

	static var meleePropP = [
		systemPropP,
		accuracyPropP,
		shockPropP,
		thrownPropP,
		returningPropP,
		handyPropP,
		clumsyPropP,
		entanglePropP,
		quickPropP,
		armorPiercingPropP,
		disruptorPropP,
	].ors().lazyF();

	static var missilePropP = [
		systemPropP,
		rangePropP,
		accuracyPropP,
		blastPropP,
		smartPropP,
		skillPropP,
		longRangePropP,
		hypervelocityPropP,
		countermissilePropP,
		fusePropP,
		nuclearPropP,
		foamPropP,
		flarePropP,
		scatterPropP,
		smokePropP,
	].ors().lazyF();

	static var projectilePropP = [
		systemPropP,
		accuracyPropP,
		rangePropP,
		burstValuePropP,
		longRangePropP,
		hypervelocityPropP,
		multiFeedPropP,
		phalanxPropP,
		antiPersonnelPropP,
		allPurposePropP,
		projAmmoPropP,
	].ors().lazyF();

	static var powerPropP = [
		numberP.and_(powerT) .trace(p('')).then(function (p) return AST_Power(Std.parseInt(p))),
		batteryT.and_(powerT).trace(p('')).then(function (p) return AST_Power(-1)             ),
	].ors().lazyF();

	static var energyPoolPropP = [
		systemPropP,
		morphablePropP,
	].ors().lazyF();

	static var ammoPropP = [
		systemPropP,
		shockPropP,
		blastPropP,
		paintballPropP,
		foamPropP,
		highExPropP,
		tracerPropP,
		kineticPropP,
		tanglerPropP,
		armorPiercingPropP,
		disruptorPropP,
		incendiaryPropP,
		scattershotPropP,
		nuclearPropP,
	].ors().lazyF();

	static var shieldPropP = [
		systemPropP,
		stoppingPowerPropP,
		defenseAbilityPropP,
		binderSpacePropP,
		resetPropP,
		turnsInUsePropP,
		weaknessPropP,
	].ors().lazyF();

	static var weaknessPropP = [
		ablativeT.or(screenT)                 .trace(p('')).then(function (p) return Resolved(AST_Screen       )),
		energyT._and(onlyT).or(interferenceT) .trace(p('')).then(function (p) return Resolved(AST_Interference )),
		matterT._and(onlyT).or(kineticT)      .trace(p('')).then(function (p) return Resolved(AST_Kinetic      )),
		rangedT._and(onlyT).or(swashbucklingT).trace(p('')).then(function (p) return Resolved(AST_Swashbuckling)),
		enclosingT.or(mirrorT)                .trace(p('')).then(function (p) return Resolved(AST_Mirror       )),
		offensiveT.or(surgeT)                 .trace(p('')).then(function (p) return Resolved(AST_Surge        )),
	].ors().lazyF();

	static var sensorPropP = [
		systemPropP,
		sensorRangePropP,
		commRangePropP,
	].ors().lazyF();

	static var ecmPropP = [
		systemPropP,
		radiusPropP,
		beamingPropP,
	].ors().lazyF();

	static var remoteControlPropP = [
		systemPropP,
		controlRangePropP,
		operationRangePropP,
		wireControlledPropP,
	].ors().lazyF();



	/*******************************
	*                              *
	*    Basic Property Parsers    *
	*                              *
	*******************************/
	static function propSwitch<T>(p: Option<T>) switch (p) {
		case Some(b): return true;
		case None   : return false;
	}

	static var accuracyPropP       = numberP.and_(accuracyT)                                                  .trace(p('')).then(function (p) return Resolved(AST_Accuracy(Std.parseInt(p))                        )).lazyF();
	static var allPurposePropP     = allPurposeT                                                              .trace(p('')).then(function (p) return Resolved(AST_AllPurpose                                       )).lazyF();
	static var antiMissilePropP    = variableT.option().and_(antiMissileT)                                    .trace(p('')).then(function (p) return Resolved(AST_AntiMissile(propSwitch(p))                       )).lazyF();
	static var antiPersonnelPropP  = variableT.option().and_(antiPersonnelT)                                  .trace(p('')).then(function (p) return Resolved(AST_AntiPersonnel(propSwitch(p))                     )).lazyF();
	static var armorPiercingPropP  = armorPiercingT                                                           .trace(p('')).then(function (p) return Resolved(AST_ArmorPiercing                                    )).lazyF();
	static var attackFactorPropP   = numberP.and_(attackT).and_(factorT)                                      .trace(p('')).then(function (p) return Resolved(AST_AttackFactor(Std.parseInt(p))                    )).lazyF();
	static var beamingPropP        = numberP.and_(beamingT)                                                   .trace(p('')).then(function (p) return Resolved(AST_Beaming(Std.parseInt(p))                         )).lazyF();
	static var beamShieldPropP     = variableT.option().and_(beamT).and_(shieldT)                             .trace(p('')).then(function (p) return Resolved(AST_BeamShield(propSwitch(p))                        )).lazyF();
	static var binderSpacePropP    = dashT._and(numberP.band(slashT._and(numberP))).and_(binderT.band(spaceT)).trace(p('')).then(function (p) return Resolved(AST_BinderSpace(Std.parseInt(p.a), Std.parseInt(p.b)))).lazyF();
	static var blastPropP          = blastT._and(numberP)                                                     .trace(p('')).then(function (p) return Resolved(AST_Blast(Std.parseInt(p))                           )).lazyF();
	static var burstValuePropP     = numberP.and_(burstT).and_(valueT)                                        .trace(p('')).then(function (p) return Resolved(AST_BurstValue(Std.parseInt(p))                      )).lazyF();
	static var clipFedPropP        = clipFedT                                                                 .trace(p('')).then(function (p) return Resolved(AST_ClipFed                                          )).lazyF();
	static var clumsyPropP         = clumsyT                                                                  .trace(p('')).then(function (p) return Resolved(AST_Clumsy                                           )).lazyF();
	static var commRangePropP      = numberP.and_(kmT.band(commT).band(rangeT))                               .trace(p('')).then(function (p) return Resolved(AST_CommRange(Std.parseInt(p))                       )).lazyF();
	static var controlRangePropP   = numberP.and_(controlT).and_(rangeT)                                      .trace(p('')).then(function (p) return Resolved(AST_ControlRange(Std.parseInt(p))                    )).lazyF();
	static var costPropP           = numberP.and_(costT)                                                      .trace(p('')).then(function (p) return Resolved(AST_Cost(Std.parseFloat(p))                          )).lazyF();
	static var countermissilePropP = variableT.option().and_(countermissileT)                                 .trace(p('')).then(function (p) return Resolved(AST_Countermissile(propSwitch(p))                    )).lazyF();
	static var damagePropP         = numberP.and_(damageT)                                                    .trace(p('')).then(function (p) return Resolved(AST_Damage(Std.parseFloat(p))                        )).lazyF();
	static var defenseAbilityPropP = numberP.and_(defenseT).and_(abilityT)                                    .trace(p('')).then(function (p) return Resolved(AST_DefenseAbility(Std.parseInt(p))                  )).lazyF();
	static var disruptorPropP      = disruptorT                                                               .trace(p('')).then(function (p) return Resolved(AST_Disruptor                                        )).lazyF();
	static var entanglePropP       = entangleT                                                                .trace(p('')).then(function (p) return Resolved(AST_Entangle                                         )).lazyF();
	static var flarePropP          = flareT                                                                   .trace(p('')).then(function (p) return Resolved(AST_Flare                                            )).lazyF();
	static var foamPropP           = foamT                                                                    .trace(p('')).then(function (p) return Resolved(AST_Foam                                             )).lazyF();
	static var fragilePropP        = fragileT                                                                 .trace(p('')).then(function (p) return Resolved(AST_Fragile                                          )).lazyF();
	static var fusePropP           = fuseT                                                                    .trace(p('')).then(function (p) return Resolved(AST_Fuse                                             )).lazyF();
	static var handyPropP          = handyT                                                                   .trace(p('')).then(function (p) return Resolved(AST_Handy                                            )).lazyF();
	static var highExPropP         = highExplosiveT                                                           .trace(p('')).then(function (p) return Resolved(AST_HighEx                                           )).lazyF();
	static var hydroPropP          = hydroT                                                                   .trace(p('')).then(function (p) return Resolved(AST_Hydro                                            )).lazyF();
	static var hyperPropP          = hyperT                                                                   .trace(p('')).then(function (p) return Resolved(AST_Hyper                                            )).lazyF();
	static var hypervelocityPropP  = hypervelocityT                                                           .trace(p('')).then(function (p) return Resolved(AST_Hypervelocity                                    )).lazyF();
	static var incendiaryPropP     = incendiaryT                                                              .trace(p('')).then(function (p) return Resolved(AST_Incendiary                                       )).lazyF();
	static var killsPropP          = numberP.and_(killsT)                                                     .trace(p('')).then(function (p) return Resolved(AST_Kills(Std.parseFloat(p))                         )).lazyF();
	static var kineticPropP        = kineticT                                                                 .trace(p('')).then(function (p) return Resolved(AST_Kinetic                                          )).lazyF();
	static var longRangePropP      = longT.band(rangeT)                                                       .trace(p('')).then(function (p) return Resolved(AST_LongRange                                        )).lazyF();
	static var megaBeamPropP       = megaBeamT                                                                .trace(p('')).then(function (p) return Resolved(AST_MegaBeam                                         )).lazyF();
	static var morphablePropP      = morphableT                                                               .trace(p('')).then(function (p) return Resolved(AST_Morphable                                        )).lazyF();
	static var multiFeedPropP      = numberP.and_(multiFeedT)                                                 .trace(p('')).then(function (p) return Resolved(AST_MultiFeed(Std.parseInt(p))                       )).lazyF();
	static var nuclearPropP        = nuclearT                                                                 .trace(p('')).then(function (p) return Resolved(AST_Nuclear                                          )).lazyF();
	static var operationRangePropP = numberP.and_(operationT).and_(rangeT)                                    .trace(p('')).then(function (p) return Resolved(AST_OperationRange(Std.parseInt(p))                  )).lazyF();
	static var paintballPropP      = paintballT                                                               .trace(p('')).then(function (p) return Resolved(AST_Paintball                                        )).lazyF();
	static var phalanxPropP        = variableT.option().and_(phalanxT)                                        .trace(p('')).then(function (p) return Resolved(AST_Phalanx(propSwitch(p))                           )).lazyF();
	static var projAmmoPropP       = ammoT._and(nameDeclP.many())                                             .trace(p('')).then(function (p) return Resolved(AST_Ammo(p)                                               )).lazyF();
	static var qualityValuePropP   = numberP.and_(qualityT).and_(valueT)                                      .trace(p('')).then(function (p) return Resolved(AST_QualityValue(Std.parseInt(p))                    )).lazyF();
	static var quickPropP          = quickT                                                                   .trace(p('')).then(function (p) return Resolved(AST_Quick                                            )).lazyF();
	static var radiusPropP         = numberP.and_(radiusT)                                                    .trace(p('')).then(function (p) return Resolved(AST_Radius(Std.parseInt(p))                          )).lazyF();
	static var rangePropP          = numberP.and_(rangeT)                                                     .trace(p('')).then(function (p) return Resolved(AST_Range(Std.parseInt(p))                           )).lazyF();
	static var rechargeablePropP   = rechargeableT                                                            .trace(p('')).then(function (p) return Resolved(AST_Rechargeable                                     )).lazyF();
	static var resetPropP          = numberP.and_(resetT)                                                     .trace(p('')).then(function (p) return Resolved(AST_Reset(Std.parseInt(p))                           )).lazyF();
	static var returningPropP      = returningT                                                               .trace(p('')).then(function (p) return Resolved(AST_Returning                                        )).lazyF();
	static var scatterPropP        = scatterT                                                                 .trace(p('')).then(function (p) return Resolved(AST_Scatter                                          )).lazyF();
	static var scattershotPropP    = scattershotT                                                             .trace(p('')).then(function (p) return Resolved(AST_Scattershot                                      )).lazyF();
	static var sensorRangePropP    = numberP.and_(kmT.band(sensorT).band(rangeT))                             .trace(p('')).then(function (p) return Resolved(AST_SensorRange(Std.parseInt(p))                     )).lazyF();
	static var shockPropP          = shockT._and(onlyT.or(addedT)).or(shockT)                                 .trace(p('')).then(function (p) return Resolved(AST_Shock(switch (p) {
																																																																																		case 'Only' : true;
																																																																																		case _      : false;
																																																																																	})                                                  )).lazyF();
	static var shotsPropP          = numberP.and_(shotsT)                                                     .trace(p('')).then(function (p) return Resolved(AST_Shots(Std.parseInt(p))                           )).lazyF();
	static var skillPropP          = numberP.and_(skillT)                                                     .trace(p('')).then(function (p) return Resolved(AST_Skill(Std.parseInt(p))                           )).lazyF();
	static var smartPropP          = numberP.and_(smartT)                                                     .trace(p('')).then(function (p) return Resolved(AST_Smart(Std.parseInt(p))                           )).lazyF();
	static var smokePropP          = smokeT                                                                   .trace(p('')).then(function (p) return Resolved(AST_Smoke                                            )).lazyF();
	static var spacePropP          = numberP.and_(spaceT)                                                     .trace(p('')).then(function (p) return Resolved(AST_Space(Std.parseFloat(p))                         )).lazyF();
	static var stoppingPowerPropP  = numberP.and_(stoppingT).and_(powerT)                                     .trace(p('')).then(function (p) return Resolved(AST_StoppingPower(Std.parseInt(p))                   )).lazyF();
	static var tanglerPropP        = tanglerT                                                                 .trace(p('')).then(function (p) return Resolved(AST_Tangler                                          )).lazyF();
	static var thrownPropP         = thrownT                                                                  .trace(p('')).then(function (p) return Resolved(AST_Thrown                                           )).lazyF();
	static var tracerPropP         = tracerT                                                                  .trace(p('')).then(function (p) return Resolved(AST_Tracer                                           )).lazyF();
	static var turnsInUsePropP     = numberP.and_(turnsT).and_(inT).and_(useT)                                .trace(p('')).then(function (p) return Resolved(AST_TurnsInUse(Std.parseInt(p))                      )).lazyF();
	static var valuePropP          = numberP.and_(valueT)                                                     .trace(p('')).then(function (p) return Resolved(AST_Value(Std.parseInt(p))                           )).lazyF();
	static var warmUpPropP         = numberP.and_(warmUpT)                                                    .trace(p('')).then(function (p) return Resolved(AST_WarmUp(Std.parseInt(p))                          )).lazyF();
	static var wideAnglePropP      = numberP.and_(wideT).and_(angleT)                                         .trace(p('')).then(function (p) return Resolved(AST_WideAngle(Std.parseInt(p))                       )).lazyF();
	static var wireControlledPropP = wireControlledT                                                          .trace(p('')).then(function (p) return Resolved(AST_WireControlled                                   )).lazyF();
}

class MekTest extends haxe.unit.TestCase {
	public function testCostPropP()                   propertyTest('1 Cost',                  MekParser.costPropP(),           AST_Cost(1)              );
	public function testSpacePropP()                  propertyTest('1 Space',                 MekParser.spacePropP(),          AST_Space(1)             );
	public function testKillsPropP()                  propertyTest('1 Kills',                 MekParser.killsPropP(),          AST_Kills(1)             );
	public function testAccuracyPropP()               propertyTest('1 Accuracy',              MekParser.accuracyPropP(),       AST_Accuracy(1)          );
	public function testRangePropP()                  propertyTest('1 Range',                 MekParser.rangePropP(),          AST_Range(1)             );
	public function testShotsPropP()                  propertyTest('1 Shots',                 MekParser.shotsPropP(),          AST_Shots(1)             );
	public function testWarmUpPropP()                 propertyTest('1 Warm-Up',               MekParser.warmUpPropP(),         AST_WarmUp(1)            );
	public function testWideAnglePropP()              propertyTest('1 Wide Angle',            MekParser.wideAnglePropP(),      AST_WideAngle(1)         );
	public function testBurstValuePropP()             propertyTest('1 Burst Value',           MekParser.burstValuePropP(),     AST_BurstValue(1)        );
	public function testAntiMissilePropP()            propertyTest('Anti-Missile',            MekParser.antiMissilePropP(),    AST_AntiMissile(false)   );
	public function testVariableAntiMissilePropP()    propertyTest('Variable Anti-Missile',   MekParser.antiMissilePropP(),    AST_AntiMissile(true)    );
	public function testAntiPersonnelPropP()          propertyTest('Anti-Personnel',          MekParser.antiPersonnelPropP(),  AST_AntiPersonnel(false) );
	public function testVariableAntiPersonnelPropP()  propertyTest('Variable Anti-Personnel', MekParser.antiPersonnelPropP(),  AST_AntiPersonnel(true)  );
	public function testAllPurposePropP()             propertyTest('All-Purpose',             MekParser.allPurposePropP(),     AST_AllPurpose           );
	public function testClipFedPropP()                propertyTest('Clip-Fed',                MekParser.clipFedPropP(),        AST_ClipFed              );
	public function testMegaBeamPropP()               propertyTest('Mega-Beam',               MekParser.megaBeamPropP(),       AST_MegaBeam             );
	public function testLongRangePropP()              propertyTest('Long Range',              MekParser.longRangePropP(),      AST_LongRange            );
	public function testFragilePropP()                propertyTest('Fragile',                 MekParser.fragilePropP(),        AST_Fragile              );
	public function testDisruptorPropP()              propertyTest('Disruptor',               MekParser.disruptorPropP(),      AST_Disruptor            );
	public function testHydroPropP()                  propertyTest('Hydro',                   MekParser.hydroPropP(),          AST_Hydro                );
	public function testAttackFactorPropP()           propertyTest('1 Attack Factor',         MekParser.attackFactorPropP(),   AST_AttackFactor(1)      );
	public function testTurnsInUsePropP()             propertyTest('1 Turns In Use',          MekParser.turnsInUsePropP(),     AST_TurnsInUse(1)        );
	public function testBeamShieldPropP()             propertyTest('Beam Shield',             MekParser.beamShieldPropP(),     AST_BeamShield(false)    );
	public function testVariableBeamShieldPropP()     propertyTest('Variable Beam Shield',    MekParser.beamShieldPropP(),     AST_BeamShield(true)     );
	public function testRechargeablePropP()           propertyTest('Rechargeable',            MekParser.rechargeablePropP(),   AST_Rechargeable         );
	public function testThrownPropP()                 propertyTest('Thrown',                  MekParser.thrownPropP(),         AST_Thrown               );
	public function testQuickPropP()                  propertyTest('Quick',                   MekParser.quickPropP(),          AST_Quick                );
	public function testHyperPropP()                  propertyTest('Hyper',                   MekParser.hyperPropP(),          AST_Hyper                );
	public function testShockPropP()                  propertyTest('Shock',                   MekParser.shockPropP(),          AST_Shock(false)         );
	public function testShockAddedPropP()             propertyTest('Shock Added',             MekParser.shockPropP(),          AST_Shock(false)         );
	public function testShockOnlyPropP()              propertyTest('Shock Only',              MekParser.shockPropP(),          AST_Shock(true)          );
	public function testReturningPropP()              propertyTest('Returning',               MekParser.returningPropP(),      AST_Returning            );
	public function testHandyPropP()                  propertyTest('Handy',                   MekParser.handyPropP(),          AST_Handy                );
	public function testClumsyPropP()                 propertyTest('Clumsy',                  MekParser.clumsyPropP(),         AST_Clumsy               );
	public function testEntanglePropP()               propertyTest('Entangle',                MekParser.entanglePropP(),       AST_Entangle             );
	public function testArmorPiercingPropP()          propertyTest('Armor-Piercing',          MekParser.armorPiercingPropP(),  AST_ArmorPiercing        );
	public function testBlastPropP()                  propertyTest('Blast 1',                 MekParser.blastPropP(),          AST_Blast(1)             );
	public function testSmartPropP()                  propertyTest('1 Smart',                 MekParser.smartPropP(),          AST_Smart(1)             );
	public function testSkillPropP()                  propertyTest('1 Skill',                 MekParser.skillPropP(),          AST_Skill(1)             );
	public function testHypervelocityPropP()          propertyTest('Hypervelocity',           MekParser.hypervelocityPropP(),  AST_Hypervelocity        );
	public function testCountermissilePropP()         propertyTest('Countermissile',          MekParser.countermissilePropP(), AST_Countermissile(false));
	public function testVariableCountermissilePropP() propertyTest('Variable Countermissile', MekParser.countermissilePropP(), AST_Countermissile(true) );
	public function testFusePropP()                   propertyTest('Fuse',                    MekParser.fusePropP(),           AST_Fuse                 );
	public function testNuclearPropP()                propertyTest('Nuclear',                 MekParser.nuclearPropP(),        AST_Nuclear              );
	public function testFoamPropP()                   propertyTest('Foam',                    MekParser.foamPropP(),           AST_Foam                 );
	public function testFlarePropP()                  propertyTest('Flare',                   MekParser.flarePropP(),          AST_Flare                );
	public function testScatterPropP()                propertyTest('Scatter',                 MekParser.scatterPropP(),        AST_Scatter              );
	public function testSmokePropP()                  propertyTest('Smoke',                   MekParser.smokePropP(),          AST_Smoke                );
	public function testMultiFeedPropP()              propertyTest('1 Multi-Feed',            MekParser.multiFeedPropP(),      AST_MultiFeed(1)         );
	public function testPhalanxPropP()                propertyTest('Phalanx',                 MekParser.phalanxPropP(),        AST_Phalanx(false)       );
	public function testVariablePhalanxPropP()        propertyTest('Variable Phalanx',        MekParser.phalanxPropP(),        AST_Phalanx(true)        );
	public function testMorphablePropP()              propertyTest('Morphable',               MekParser.morphablePropP(),      AST_Morphable            );
	public function testPaintballPropP()              propertyTest('Paintball',               MekParser.paintballPropP(),      AST_Paintball            );
	public function testHighExPropP()                 propertyTest('High-Explosive',          MekParser.highExPropP(),         AST_HighEx               );
	public function testTracerPropP()                 propertyTest('Tracer',                  MekParser.tracerPropP(),         AST_Tracer               );
	public function testKineticPropP()                propertyTest('Kinetic',                 MekParser.kineticPropP(),        AST_Kinetic              );
	public function testTanglerPropP()                propertyTest('Tangler',                 MekParser.tanglerPropP(),        AST_Tangler              );
	public function testIncendiaryPropP()             propertyTest('Incendiary',              MekParser.incendiaryPropP(),     AST_Incendiary           );
	public function testScattershotPropP()            propertyTest('Scattershot',             MekParser.scattershotPropP(),    AST_Scattershot          );
	public function testStoppingPowerPropP()          propertyTest('1 Stopping Power',        MekParser.stoppingPowerPropP(),  AST_StoppingPower(1)     );
	public function testDefenseAbilityPropP()         propertyTest('1 Defense Ability',       MekParser.defenseAbilityPropP(), AST_DefenseAbility(1)    );
	public function testBinderSpacePropP()            propertyTest('-1/2 Binder Space',       MekParser.binderSpacePropP(),    AST_BinderSpace(1,2)     );
	public function testResetPropP()                  propertyTest('1 Reset',                 MekParser.resetPropP(),          AST_Reset(1)             );
	public function testQualityValuePropP()           propertyTest('1 Quality Value',         MekParser.qualityValuePropP(),   AST_QualityValue(1)      );
	public function testSensorRangePropP()            propertyTest('1km Sensor Range',        MekParser.sensorRangePropP(),    AST_SensorRange(1)       );
	public function testCommRangePropP()              propertyTest('1km Comm Range',          MekParser.commRangePropP(),      AST_CommRange(1)         );
	public function testValuePropP()                  propertyTest('1 Value',                 MekParser.valuePropP(),          AST_Value(1)             );
	public function testRadiusPropP()                 propertyTest('1 Radius',                MekParser.radiusPropP(),         AST_Radius(1)            );
	public function testBeamingPropP()                propertyTest('1 Beaming',               MekParser.beamingPropP(),        AST_Beaming(1)           );
	public function testControlRangePropP()           propertyTest('1 Control Range',         MekParser.controlRangePropP(),   AST_ControlRange(1)      );
	public function testOperationRangePropP()         propertyTest('1 Operation Range',       MekParser.operationRangePropP(), AST_OperationRange(1)    );
	public function testWireControlledPropP()         propertyTest('Wire-Controlled',         MekParser.wireControlledPropP(), AST_WireControlled       );

	public function testProjAmmoPropP() {
		switch (MekParser.projAmmoPropP()('Ammo'.reader())) {
			case Failure(_,_): assertTrue(false);
			case Success(a,_): switch (a) {
				case Resolved  (p): switch (p) {
					case AST_Ammo(list): assertEquals(list, []);
					case _             : assertTrue(false);
				}
				case Unresolved(s): assertTrue(false);
			}
		}
	}

	function propertyTest(str: String, parser: Parser<String, AST<AST_Property>>, prop: AST_Property) {
		switch (parser(str.reader())) {
			case Failure(_,_): assertTrue(false);
			case Success(a,_): switch (a) {
				case Resolved  (p): assertEquals(p, prop);
				case Unresolved(s): assertTrue(false);
			}
		}
	}
}