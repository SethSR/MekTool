import haxe.Timer;
import sys.io.File;

import com.mindrocks.functional.Functional;

using com.mindrocks.text.Parser;
using com.mindrocks.macros.LazyMacro;

using Type;
import MekTokens.*;
import AST;

using Armor;
using Armor.ArmorClass;
using SizeClass;

@:allow(PropertyTest)
class MekParser {
	static public function tryParse(str: String, output: String -> Void): String {
		try {
			// var res = Timer.measure(function () return fileP()(str.reader()));
			var res = fileP()(str.reader());

			switch (res) {
				case Success(res, rest):
					var remaining = rest.rest();
					if (StringTools.trim(remaining).length == 0)
						trace ('success!');
					else
						trace ('cannot parse $remaining');
					File.saveContent('output.mtz', MekPrinter.printMektons(Resolver.resolve(ast)));
				case Failure(err, rest, _):
					var p = rest.textAround();
					output(p.text);
					output(p.indicator);
					err.map(function (error) output('Error at ${error.pos} : ${error.msg}'));
					return 'failure';
			}
		} catch (e: Dynamic) {
			return 'Error ${Std.string(e)}';
		}
	}

	static public function test(str: String): String {
		return tryParse(str, function (str: String) trace (str));
	}

	static var ast = {
		mektons: new Array<AST_Mekton>(),
		systems: new Array<AST_MekSys>(),
	};


	/************
	 *  Parser  *
	 ***********/
	static var fileP = spacingP._and(definitionP.many()).commit().lazyF();

	static var definitionP = [
		mektonDefP.then(function (p) ast.mektons.push(AST_Mekton(p.a, p.b.b, p.b.a))),
		systemDefP.then(function (p) ast.systems.push(p)),
	].ors().lazyF();

	static var mektonDefP = mektonT._and(nameDeclP).band(propulsionP.many().band(servoP.many())).commit().tag('Mekton').lazyF();

	static var propulsionP = [
		thrustersP
	].ors().commit().tag('Propulsion').lazyF();

	static var thrustersP = numberP.and_(maT._and(thrustersT)).then(function (p) return Propulsion.Thruster(Std.parseInt(p))).lazyF();

	static var servoP = [
		sizeClassP.band(torsoT._and(armorP.band(systemDeclP.many()))).then(function (p) return AST_Torso(p.a, p.b.a, p.b.b)),
		sizeClassP.band(headT ._and(armorP.band(systemDeclP.many()))).then(function (p) return AST_Head (p.a, p.b.a, p.b.b)),
		sizeClassP.band(armT  ._and(armorP.band(systemDeclP.many()))).then(function (p) return AST_Arm  (p.a, p.b.a, p.b.b)),
		sizeClassP.band(legT  ._and(armorP.band(systemDeclP.many()))).then(function (p) return AST_Leg  (p.a, p.b.a, p.b.b)),
		sizeClassP.band(tailT ._and(armorP.band(systemDeclP.many()))).then(function (p) return AST_Tail (p.a, p.b.a, p.b.b)),
		sizeClassP.band(wingT ._and(armorP.band(systemDeclP.many()))).then(function (p) return AST_Wing (p.a, p.b.a, p.b.b)),
		sizeClassP.band(podT  ._and(armorP.band(systemDeclP.many()))).then(function (p) return AST_Pod  (p.a, p.b.a, p.b.b)),
	].ors().commit().tag('Servo').lazyF();

	static var sizeClassP = [
		superlightT           .then(function (p) return Superlight   ),
		lightweightT          .then(function (p) return Lightweight  ),
		strikerT              .then(function (p) return Striker      ),
		mediumT._and(strikerT).then(function (p) return MediumStriker),
		heavyT._and(strikerT) .then(function (p) return HeavyStriker ),
		mediumweightT         .then(function (p) return Mediumweight ),
		lightT._and(heavyT)   .then(function (p) return LightHeavy   ),
		mediumT._and(heavyT)  .then(function (p) return MediumHeavy  ),
		armoredT._and(heavyT) .then(function (p) return ArmoredHeavy ),
		superT._and(heavyT)   .then(function (p) return SuperHeavy   ),
		megaT._and(heavyT)    .then(function (p) return MegaHeavy    ),
	].ors().tag('Size Class').lazyF();

	static var armorP = [
		sizeClassP.band(armorClassP.band(ramT._and(numberP.band(slashT._and(numberP))))).then(function (p) return RAMArmor     (p.a, p.b.a, Std.parseInt(p.b.b.a), Std.parseInt(p.b.b.b))),
		sizeClassP.band(armorClassP).and_(armorT)                                       .then(function (p) return StandardArmor(p.a, p.b)),
		sizeClassP.band(ramT._and(numberP.band(slashT._and(numberP))))                  .then(function (p) return RAMArmor     (p.a, Standard, Std.parseInt(p.b.a), Std.parseInt(p.b.b))),
		sizeClassP.and_(armorT)                                                         .then(function (p) return StandardArmor(p, Standard)),
	].ors().tag('Armor type').lazyF();

	static var armorClassP = [
		ablativeT.then(function (p) return ArmorClass.Ablative),
		standardT.then(function (p) return ArmorClass.Standard),
		alphaT   .then(function (p) return ArmorClass.Alpha   ),
		betaT    .then(function (p) return ArmorClass.Beta    ),
		gammaT   .then(function (p) return ArmorClass.Gamma   ),
	].ors().tag('Armor Class').lazyF();

	static var declarationP = identifierP.then(function (p) return p.substring(1,p.length-1)).lazyF();

	static var nameDeclP = colonT._and(declarationP).lazyF();

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
		declarationP.then(function (p) return Unresolved(p)), // Beam
		declarationP.then(function (p) return Unresolved(p)), // Energy Melee
		declarationP.then(function (p) return Unresolved(p)), // Melee
		declarationP.then(function (p) return Unresolved(p)), // Missile
		declarationP.then(function (p) return Unresolved(p)), // Projectile
		declarationP.then(function (p) return Unresolved(p)), // Energy Pool
	].ors().lazyF();

	static var mountDeclP = [
		mountT._and(mountSystemP).band(systemPropP.many()).then(function (p) return Resolved(AST_Mount(p.a , p.b))),
		mountT.band(emptyT)._and(systemPropP.many())      .then(function (p) return Resolved(AST_Mount(null, p  ))),
	].ors().lazyF();

	static var mountSystemP = [
		weaponDeclP   ,
		// nameDeclP     .trace(p('Ammo')),
		// nameDeclP    .trace(p('Mated')),
		// nameDeclP   .trace(p('Shield')),
		// nameDeclP.trace(p('Reflector')),
		// nameDeclP   .trace(p('Sensor')),
		// nameDeclP  .trace(p('ElecWar')),
		// nameDeclP   .trace(p('Remote')),
		crewDeclP     ,
		reconSysDeclP ,
		optionDeclP   ,
	].ors().lazyF();

	static var crewDeclP = [
		cockpitT          ._and(systemPropP.many()).then(function (p) return Resolved(AST_Cockpit  (p))),
		passengerT        ._and(systemPropP.many()).then(function (p) return Resolved(AST_Passenger(p))),
		extraT._and(crewT)._and(systemPropP.many()).then(function (p) return Resolved(AST_ExtraCrew(p))),
	].ors().lazyF();

	static var optionDeclP = [
		stereoT._and                              (systemPropP.many()).then(function (p) return Resolved(AST_Stereo              (p))),
		liftwireT._and                            (systemPropP.many()).then(function (p) return Resolved(AST_Liftwire            (p))),
		antiTheftT._and(codeT.band(lockT))._and   (systemPropP.many()).then(function (p) return Resolved(AST_AntiTheftCodeLock   (p))),
		spotlightsT._and                          (systemPropP.many()).then(function (p) return Resolved(AST_Spotlights          (p))),
		nightlightsT._and                         (systemPropP.many()).then(function (p) return Resolved(AST_Nightlights         (p))),
		storageT._and(moduleT)._and               (systemPropP.many()).then(function (p) return Resolved(AST_StorageModule       (p))),
		micromanipulatorsT._and                   (systemPropP.many()).then(function (p) return Resolved(AST_Micromanipulators   (p))),
		slickSprayT._and                          (systemPropP.many()).then(function (p) return Resolved(AST_SlickSpray          (p))),
		boggSprayT._and                           (systemPropP.many()).then(function (p) return Resolved(AST_BoggSpray           (p))),
		damageT._and(controlT.band(packageT))._and(systemPropP.many()).then(function (p) return Resolved(AST_DamageControlPackage(p))),
		quickT._and(changeT.band(mountT))._and    (systemPropP.many()).then(function (p) return Resolved(AST_QuickChangeMount    (p))),
		silentT._and(runningT)._and               (systemPropP.many()).then(function (p) return Resolved(AST_SilentRunning       (p))),
		parachuteT._and                           (systemPropP.many()).then(function (p) return Resolved(AST_Parachute           (p))),
		reEntryT._and(packageT)._and              (systemPropP.many()).then(function (p) return Resolved(AST_ReEntryPackage      (p))),
		ejectionT._and(seatT)._and                (systemPropP.many()).then(function (p) return Resolved(AST_EjectionSeat        (p))),
		escapeT._and(podT)._and                   (systemPropP.many()).then(function (p) return Resolved(AST_EscapePod           (p))),
		maneuverT._and(podT)._and                 (systemPropP.many()).then(function (p) return Resolved(AST_ManeuverPod         (p))),
		vehicleT._and(podT)._and                  (systemPropP.many()).then(function (p) return Resolved(AST_VehiclePod          (p))),
	].ors().lazyF();


	static var handDeclP = [
		handT._and(handSystemP).band(systemPropP.many()).then(function (p) return Resolved(AST_Hand(p.a , p.b))),
		handT.band(emptyT)._and(systemPropP.many())     .then(function (p) return Resolved(AST_Hand(null, p  ))),
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
		advancedT._and(sensorT.band(packageT))._and          (systemPropP.many()).then(function (p) return Resolved(AST_AdvancedSensorPackage (p))),
		radioT._and(slashT.band(radarT).band(analyzerT))._and(systemPropP.many()).then(function (p) return Resolved(AST_RadioRadarAnalyzer    (p))),
		resolutionT._and(intensifiersT)._and                 (systemPropP.many()).then(function (p) return Resolved(AST_ResolutionIntensifiers(p))),
		spottingT._and(radarT)._and                          (systemPropP.many()).then(function (p) return Resolved(AST_SpottingRadar         (p))),
		targetT._and(analyzerT)._and                         (systemPropP.many()).then(function (p) return Resolved(AST_TargetAnalyzer        (p))),
		marineT._and(suiteT)._and                            (systemPropP.many()).then(function (p) return Resolved(AST_MarineSuite           (p))),
		gravityT._and(lensT)._and                            (systemPropP.many()).then(function (p) return Resolved(AST_GravityLens           (p))),
		magneticT._and(resonanceT)._and                      (systemPropP.many()).then(function (p) return Resolved(AST_MagneticResonance     (p))),
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

	static var beamDefP        = beamT._and(nameDeclP.band(damagePropP.band(beamPropP.many())))                      .then(function (p) return AST_Beam       (p.a, p.b.b)).lazyF();
	static var energyMeleeDefP = energyT._and(meleeT._and(nameDeclP.band(damagePropP.band(energyMeleePropP.many())))).then(function (p) return AST_EnergyMelee(p.a, p.b.b)).lazyF();
	static var meleeDefP       = meleeT._and(nameDeclP.band(damagePropP.band(meleePropP.many())))                    .then(function (p) return AST_Melee      (p.a, p.b.b)).lazyF();
	static var missileDefP     = missileT._and(nameDeclP.band(damagePropP.band(missilePropP.many())))                .then(function (p) return AST_Missile    (p.a, p.b.b)).lazyF();
	static var projectileDefP  = projectileT._and(nameDeclP.band(damagePropP.band(projectilePropP.many())))          .then(function (p) return AST_Projectile (p.a, p.b.b)).lazyF();
	static var energyPoolDefP  = energyT._and(poolT._and(nameDeclP.band(powerPropP.band(energyPoolPropP.many().band(energyPoolSystemP.many()))))).then(function (p) return AST_EnergyPool (p.a, p.b.b.a, p.b.b.b)).lazyF();

	static var ammoDefP          = ammoT._and(nameDeclP).band(ammoPropP.many())                                           .then(function (p) return AST_MekSys.AST_Ammo       (p.a, p.b)).lazyF();
	static var matedSystemDefP   = matedT._and(nameDeclP.band(systemPropP.many().band(systemDeclP.band(systemDeclP))))    .then(function (p) return AST_MatedSystem(p.a, [p.b.b.a, p.b.b.b], p.b.a)).lazyF();
	static var reflectorDefP     = reflectorT._and(nameDeclP.band(qualityValuePropP.band(systemPropP.many())))            .then(function (p) { p.b.b.push(p.b.a); return AST_Reflector  (p.a, p.b.b); }).lazyF();
	static var sensorDefP        = sizeClassP.band(sensorT._and(nameDeclP.band(sensorPropP.many())))                      .then(function (p) return AST_Sensor     (p.b.a, p.a, p.b.b)).lazyF();
	static var remoteControlDefP = sizeClassP.band(remoteT._and(controlT)._and(nameDeclP).band(remoteControlPropP.many())).then(function (p) return AST_RemoteControl(p.b.a, p.a, p.b.b)).lazyF();
	static var elecWarDefP       = [
		sensorT._and(ecmT) ._and(nameDeclP).band(valuePropP.band(ecmPropP.many())).then(function (p) { p.b.b.push(p.b.a); return AST_SensorECM (p.a, p.b.b); }),
		missileT._and(ecmT)._and(nameDeclP).band(valuePropP.band(ecmPropP.many())).then(function (p) { p.b.b.push(p.b.a); return AST_MissileECM(p.a, p.b.b); }),
		radarT._and(ecmT)  ._and(nameDeclP).band(valuePropP.band(ecmPropP.many())).then(function (p) { p.b.b.push(p.b.a); return AST_RadarECM  (p.a, p.b.b); }),
		eccmT              ._and(nameDeclP).band(valuePropP.band(ecmPropP.many())).then(function (p) { p.b.b.push(p.b.a); return AST_CounterECM(p.a, p.b.b); }),
	].ors().lazyF();

	static var shieldDefP = [
		standardT._and(armorClassP.option().band(sizeClassP.and_(shieldT))).band(nameDeclP.band(shieldPropP.many())).then(function (p) return AST_StandardShield(Some(p.b.a), p.a.a, p.a.b, p.b.b)),
		activeT  ._and(armorClassP.option().band(sizeClassP.and_(shieldT))).band(nameDeclP.band(shieldPropP.many())).then(function (p) return AST_ActiveShield  (Some(p.b.a), p.a.a, p.a.b, p.b.b)),
		reactiveT._and(armorClassP.option().band(sizeClassP.and_(shieldT))).band(nameDeclP.band(shieldPropP.many())).then(function (p) return AST_ReactiveShield(Some(p.b.a), p.a.a, p.a.b, p.b.b)),
		               armorClassP.option().band(sizeClassP.and_(shieldT)) .band(nameDeclP.band(shieldPropP.many())).then(function (p) return AST_StandardShield(Some(p.b.a), p.a.a, p.a.b, p.b.b)),
	].ors().lazyF();

	static var shieldNoNameDefP = [
		standardT.option().band(armorClassP.option().band(sizeClassP.and_(shieldT))).band(shieldPropP.many()).then(function (p) trace ('Parsing a shield definition')),
		activeT  .option().band(armorClassP.option().band(sizeClassP.and_(shieldT))).band(shieldPropP.many()).then(function (p) trace ('Parsing a shield definition')),
		reactiveT.option().band(armorClassP.option().band(sizeClassP.and_(shieldT))).band(shieldPropP.many()).then(function (p) trace ('Parsing a shield definition')),
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
		numberP.and_(powerT) .then(function (p) return AST_Power(Std.parseInt(p))),
		batteryT.and_(powerT).then(function (p) return AST_Power(-1)             ),
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
		ablativeT.or(screenT)                 .then(function (p) return Resolved(AST_Screen       )),
		energyT._and(onlyT).or(interferenceT) .then(function (p) return Resolved(AST_Interference )),
		matterT._and(onlyT).or(kineticT)      .then(function (p) return Resolved(AST_Kinetic      )),
		rangedT._and(onlyT).or(swashbucklingT).then(function (p) return Resolved(AST_Swashbuckling)),
		enclosingT.or(mirrorT)                .then(function (p) return Resolved(AST_Mirror       )),
		offensiveT.or(surgeT)                 .then(function (p) return Resolved(AST_Surge        )),
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

	static var accuracyPropP       = numberP.and_(accuracyT)                                                  .then(function (p) return Resolved(AST_Accuracy(Std.parseInt(p))                        )).lazyF();
	static var allPurposePropP     = allPurposeT                                                              .then(function (p) return Resolved(AST_AllPurpose                                       )).lazyF();
	static var antiMissilePropP    = variableT.option().and_(antiMissileT)                                    .then(function (p) return Resolved(AST_AntiMissile(propSwitch(p))                       )).lazyF();
	static var antiPersonnelPropP  = variableT.option().and_(antiPersonnelT)                                  .then(function (p) return Resolved(AST_AntiPersonnel(propSwitch(p))                     )).lazyF();
	static var armorPiercingPropP  = armorPiercingT                                                           .then(function (p) return Resolved(AST_ArmorPiercing                                    )).lazyF();
	static var attackFactorPropP   = numberP.and_(attackT).and_(factorT)                                      .then(function (p) return Resolved(AST_AttackFactor(Std.parseInt(p))                    )).lazyF();
	static var beamingPropP        = numberP.and_(beamingT)                                                   .then(function (p) return Resolved(AST_Beaming(Std.parseInt(p))                         )).lazyF();
	static var beamShieldPropP     = variableT.option().and_(beamT).and_(shieldT)                             .then(function (p) return Resolved(AST_BeamShield(propSwitch(p))                        )).lazyF();
	static var binderSpacePropP    = dashT._and(numberP.band(slashT._and(numberP))).and_(binderT.band(spaceT)).then(function (p) return Resolved(AST_BinderSpace(Std.parseInt(p.a), Std.parseInt(p.b)))).lazyF();
	static var blastPropP          = blastT._and(numberP)                                                     .then(function (p) return Resolved(AST_Blast(Std.parseInt(p))                           )).lazyF();
	static var burstValuePropP     = numberP.and_(burstT).and_(valueT)                                        .then(function (p) return Resolved(AST_BurstValue(Std.parseInt(p))                      )).lazyF();
	static var clipFedPropP        = clipFedT                                                                 .then(function (p) return Resolved(AST_ClipFed                                          )).lazyF();
	static var clumsyPropP         = clumsyT                                                                  .then(function (p) return Resolved(AST_Clumsy                                           )).lazyF();
	static var commRangePropP      = numberP.and_(kmT.band(commT).band(rangeT))                               .then(function (p) return Resolved(AST_CommRange(Std.parseInt(p))                       )).lazyF();
	static var controlRangePropP   = numberP.and_(controlT).and_(rangeT)                                      .then(function (p) return Resolved(AST_ControlRange(Std.parseInt(p))                    )).lazyF();
	static var costPropP           = numberP.and_(costT)                                                      .then(function (p) return Resolved(AST_Cost(Std.parseFloat(p))                          )).lazyF();
	static var countermissilePropP = variableT.option().and_(countermissileT)                                 .then(function (p) return Resolved(AST_Countermissile(propSwitch(p))                    )).lazyF();
	static var damagePropP         = numberP.and_(damageT)                                                    .then(function (p) return Resolved(AST_Damage(Std.parseFloat(p))                        )).lazyF();
	static var defenseAbilityPropP = numberP.and_(defenseT).and_(abilityT)                                    .then(function (p) return Resolved(AST_DefenseAbility(Std.parseInt(p))                  )).lazyF();
	static var disruptorPropP      = disruptorT                                                               .then(function (p) return Resolved(AST_Disruptor                                        )).lazyF();
	static var entanglePropP       = entangleT                                                                .then(function (p) return Resolved(AST_Entangle                                         )).lazyF();
	static var flarePropP          = flareT                                                                   .then(function (p) return Resolved(AST_Flare                                            )).lazyF();
	static var foamPropP           = foamT                                                                    .then(function (p) return Resolved(AST_Foam                                             )).lazyF();
	static var fragilePropP        = fragileT                                                                 .then(function (p) return Resolved(AST_Fragile                                          )).lazyF();
	static var fusePropP           = fuseT                                                                    .then(function (p) return Resolved(AST_Fuse                                             )).lazyF();
	static var handyPropP          = handyT                                                                   .then(function (p) return Resolved(AST_Handy                                            )).lazyF();
	static var highExPropP         = highExplosiveT                                                           .then(function (p) return Resolved(AST_HighEx                                           )).lazyF();
	static var hydroPropP          = hydroT                                                                   .then(function (p) return Resolved(AST_Hydro                                            )).lazyF();
	static var hyperPropP          = hyperT                                                                   .then(function (p) return Resolved(AST_Hyper                                            )).lazyF();
	static var hypervelocityPropP  = hypervelocityT                                                           .then(function (p) return Resolved(AST_Hypervelocity                                    )).lazyF();
	static var incendiaryPropP     = incendiaryT                                                              .then(function (p) return Resolved(AST_Incendiary                                       )).lazyF();
	static var killsPropP          = numberP.and_(killsT)                                                     .then(function (p) return Resolved(AST_Kills(Std.parseFloat(p))                         )).lazyF();
	static var kineticPropP        = kineticT                                                                 .then(function (p) return Resolved(AST_Kinetic                                          )).lazyF();
	static var longRangePropP      = longT.band(rangeT)                                                       .then(function (p) return Resolved(AST_LongRange                                        )).lazyF();
	static var megaBeamPropP       = megaBeamT                                                                .then(function (p) return Resolved(AST_MegaBeam                                         )).lazyF();
	static var morphablePropP      = morphableT                                                               .then(function (p) return Resolved(AST_Morphable                                        )).lazyF();
	static var multiFeedPropP      = numberP.and_(multiFeedT)                                                 .then(function (p) return Resolved(AST_MultiFeed(Std.parseInt(p))                       )).lazyF();
	static var nuclearPropP        = nuclearT                                                                 .then(function (p) return Resolved(AST_Nuclear                                          )).lazyF();
	static var operationRangePropP = numberP.and_(operationT).and_(rangeT)                                    .then(function (p) return Resolved(AST_OperationRange(Std.parseInt(p))                  )).lazyF();
	static var paintballPropP      = paintballT                                                               .then(function (p) return Resolved(AST_Paintball                                        )).lazyF();
	static var phalanxPropP        = variableT.option().and_(phalanxT)                                        .then(function (p) return Resolved(AST_Phalanx(propSwitch(p))                           )).lazyF();
	static var projAmmoPropP       = ammoT._and(declarationP.many())                                          .then(function (p) return Resolved(AST_Ammo(p)                                               )).lazyF();
	static var qualityValuePropP   = numberP.and_(qualityT).and_(valueT)                                      .then(function (p) return Resolved(AST_QualityValue(Std.parseInt(p))                    )).lazyF();
	static var quickPropP          = quickT                                                                   .then(function (p) return Resolved(AST_Quick                                            )).lazyF();
	static var radiusPropP         = numberP.and_(radiusT)                                                    .then(function (p) return Resolved(AST_Radius(Std.parseInt(p))                          )).lazyF();
	static var rangePropP          = numberP.and_(rangeT)                                                     .then(function (p) return Resolved(AST_Range(Std.parseInt(p))                           )).lazyF();
	static var rechargeablePropP   = rechargeableT                                                            .then(function (p) return Resolved(AST_Rechargeable                                     )).lazyF();
	static var resetPropP          = numberP.and_(resetT)                                                     .then(function (p) return Resolved(AST_Reset(Std.parseInt(p))                           )).lazyF();
	static var returningPropP      = returningT                                                               .then(function (p) return Resolved(AST_Returning                                        )).lazyF();
	static var scatterPropP        = scatterT                                                                 .then(function (p) return Resolved(AST_Scatter                                          )).lazyF();
	static var scattershotPropP    = scattershotT                                                             .then(function (p) return Resolved(AST_Scattershot                                      )).lazyF();
	static var sensorRangePropP    = numberP.and_(kmT.band(sensorT).band(rangeT))                             .then(function (p) return Resolved(AST_SensorRange(Std.parseInt(p))                     )).lazyF();
	static var shockPropP          = shockT._and(onlyT.or(addedT)).or(shockT)                                 .then(function (p) return Resolved(AST_Shock(switch (p) {
																																																																																		case 'Only' : true;
																																																																																		case _      : false;
																																																																																	})                                                  )).lazyF();
	static var shotsPropP          = numberP.and_(shotsT)                                                     .then(function (p) return Resolved(AST_Shots(Std.parseInt(p))                           )).lazyF();
	static var skillPropP          = numberP.and_(skillT)                                                     .then(function (p) return Resolved(AST_Skill(Std.parseInt(p))                           )).lazyF();
	static var smartPropP          = numberP.and_(smartT)                                                     .then(function (p) return Resolved(AST_Smart(Std.parseInt(p))                           )).lazyF();
	static var smokePropP          = smokeT                                                                   .then(function (p) return Resolved(AST_Smoke                                            )).lazyF();
	static var spacePropP          = numberP.and_(spaceT)                                                     .then(function (p) return Resolved(AST_Space(Std.parseFloat(p))                         )).lazyF();
	static var stoppingPowerPropP  = numberP.and_(stoppingT).and_(powerT)                                     .then(function (p) return Resolved(AST_StoppingPower(Std.parseInt(p))                   )).lazyF();
	static var tanglerPropP        = tanglerT                                                                 .then(function (p) return Resolved(AST_Tangler                                          )).lazyF();
	static var thrownPropP         = thrownT                                                                  .then(function (p) return Resolved(AST_Thrown                                           )).lazyF();
	static var tracerPropP         = tracerT                                                                  .then(function (p) return Resolved(AST_Tracer                                           )).lazyF();
	static var turnsInUsePropP     = numberP.and_(turnsT).and_(inT).and_(useT)                                .then(function (p) return Resolved(AST_TurnsInUse(Std.parseInt(p))                      )).lazyF();
	static var valuePropP          = numberP.and_(valueT)                                                     .then(function (p) return Resolved(AST_Value(Std.parseInt(p))                           )).lazyF();
	static var warmUpPropP         = numberP.and_(warmUpT)                                                    .then(function (p) return Resolved(AST_WarmUp(Std.parseInt(p))                          )).lazyF();
	static var wideAnglePropP      = numberP.and_(wideT).and_(angleT)                                         .then(function (p) return Resolved(AST_WideAngle(Std.parseInt(p))                       )).lazyF();
	static var wireControlledPropP = wireControlledT                                                          .then(function (p) return Resolved(AST_WireControlled                                   )).lazyF();
}