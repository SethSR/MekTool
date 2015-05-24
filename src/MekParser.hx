import haxe.Timer;

import com.mindrocks.functional.Functional;

using com.mindrocks.text.Parser;
using com.mindrocks.macros.LazyMacro;

import MekTokens.*;

using Armor;
using Armor.ArmorClass;
using SizeClass;
using ServoType;
using OptionalSystem;
using AST;

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


	/************
	 *  Parser  *
	 ***********/
	static var fileP = definitionP.many().commit().lazyF();

	static var definitionP = [
		mektonDefP,
		systemDefP,
	].ors().lazyF();

	static var nameDeclP = colonT._and(quoteT._and(identifierP.and_(quoteT))).lazyF();

	static var mektonDefP = mektonT._and(nameDeclP).band(servoP.many()).then(function (p) trace ('Parsing a mekton definition')).lazyF().lazyF();

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

	static var servoP = sizeClassP.band(servoTypeP).band(armorP).band(systemDeclP.many()).lazyF();

	static var sizeClassP = [
		superlightT,
		lightweightT,
		strikerT,
		mediumT._and(strikerT),
		heavyT._and(strikerT),
		mediumweightT,
		lightT._and(heavyT),
		mediumT._and(heavyT),
		armoredT._and(heavyT),
		superT._and(heavyT),
		megaT._and(heavyT),
	].ors().lazyF();

	static var servoTypeP = [
		torsoT,
		headT,
		armT,
		legT,
		tailT,
		wingT,
		podT,
	].ors().lazyF();

	static var armorP = [
		sizeClassP.band(armorClassP.option()).and_(armorT),
		sizeClassP.band(armorClassP.option()).and_(ramT._and(numberP.band(slashT._and(numberP)))), //TODO this will need to be fixed
	].ors().lazyF();

	static var armorClassP = [
		ablativeT.then(function (p) return ArmorClass.Ablative),
		standardT.then(function (p) return ArmorClass.Standard),
		alphaT.then   (function (p) return ArmorClass.Alpha   ),
		betaT.then    (function (p) return ArmorClass.Beta    ),
		gammaT.then   (function (p) return ArmorClass.Gamma   ),
	].ors().lazyF();

	static var systemDeclP = [
		declarationP.then(function (p) trace ('Parsing a declaration')) ,
		mountDeclP   ,
		handDeclP    ,
		crewDeclP    ,
		reconSysDeclP,
		optionDeclP  ,
	].ors().lazyF();

	static var declarationP = quoteT._and(identifierP.and_(quoteT)).then(function (p) return 0).lazyF();

	static var mountDeclP = [
		mountT._and(mountSystemP).band(systemPropP.many()).then(function (p) trace ('Parsing a mount declaration')),
		mountT.band(emptyT)._and(systemPropP.many()).then      (function (p) trace ('Parsing a mount declaration')),
	].ors().lazyF();

	static var mountSystemP = [
		declarationP.then(function (p) trace ('Parsing a declaration')),
		crewDeclP,
		optionDeclP,
	].ors().lazyF();

	static var crewDeclP = [
		cockpitT.then         (function (p) trace ('Parsing a crew declaration')),
		passengerT.then       (function (p) trace ('Parsing a crew declaration')),
		extraT.band(crewT).then(function (p) trace ('Parsing a crew declaration')),
	].ors().lazyF();

	static var optionDeclP = [
		stereoT._and(systemPropP.many()).then                            (function (p) trace ('Parsing an option declaration')),
		liftwireT._and(systemPropP.many()).then                          (function (p) trace ('Parsing an option declaration')),
		antiTheftT.band(codeT).band(lockT)._and(systemPropP.many()).then   (function (p) trace ('Parsing an option declaration')),
		spotlightsT._and(systemPropP.many()).then                        (function (p) trace ('Parsing an option declaration')),
		nightlightsT._and(systemPropP.many()).then                       (function (p) trace ('Parsing an option declaration')),
		storageT.band(moduleT)._and(systemPropP.many()).then              (function (p) trace ('Parsing an option declaration')),
		micromanipulatorsT._and(systemPropP.many()).then                 (function (p) trace ('Parsing an option declaration')),
		slickSprayT._and(systemPropP.many()).then                        (function (p) trace ('Parsing an option declaration')),
		boggSprayT._and(systemPropP.many()).then                         (function (p) trace ('Parsing an option declaration')),
		damageT.band(controlT).band(packageT)._and(systemPropP.many()).then(function (p) trace ('Parsing an option declaration')),
		quickT.band(changeT).band(mountT)._and(systemPropP.many()).then    (function (p) trace ('Parsing an option declaration')),
		silentT.band(runningT)._and(systemPropP.many()).then              (function (p) trace ('Parsing an option declaration')),
		parachuteT._and(systemPropP.many()).then                         (function (p) trace ('Parsing an option declaration')),
		reEntryT.band(packageT)._and(systemPropP.many()).then             (function (p) trace ('Parsing an option declaration')),
		ejectionT.band(seatT)._and(systemPropP.many()).then               (function (p) trace ('Parsing an option declaration')),
		escapeT.band(podT)._and(systemPropP.many()).then                  (function (p) trace ('Parsing an option declaration')),
		maneuverT.band(podT)._and(systemPropP.many()).then                (function (p) trace ('Parsing an option declaration')),
		vehicleT.band(podT)._and(systemPropP.many()).then                 (function (p) trace ('Parsing an option declaration')),
	].ors().lazyF();

	static var systemPropP = [
		costPropP ,
		spacePropP,
		killsPropP,
	].ors().lazyF();


	static var handDeclP = [
		handT._and(declarationP).band(systemPropP.many()).then(function (p) trace ('Parsing a hand declaration')),
		handT.band(emptyT)._and(systemPropP.many()).then      (function (p) trace ('Parsing a hand declaration')),
	].ors().lazyF();

	static var reconSysDeclP = reconSysTypeP.band(systemPropP.many()).then(function (p) trace ('Parsing a recon system declaration')).lazyF();

	static var reconSysTypeP = [
		advancedT.band(sensorT).band(packageT).then         (function (p) trace ('Parsing a recon system')),
		radioT.band(slashT).band(radarT).band(analyzerT).then(function (p) trace ('Parsing a recon system')),
		resolutionT.band(intensifiersT).then               (function (p) trace ('Parsing a recon system')),
		spottingT.band(radarT).then                        (function (p) trace ('Parsing a recon system')),
		targetT.band(analyzerT).then                       (function (p) trace ('Parsing a recon system')),
		marineT.band(suiteT).then                          (function (p) trace ('Parsing a recon system')),
		gravityT.band(lensT).then                          (function (p) trace ('Parsing a recon system')),
		magneticT.band(resonanceT).then                    (function (p) trace ('Parsing a recon system')),
	].ors().lazyF();

	static var weaponDefP = [
		beamDefP,
		energyMeleeDefP,
		meleeDefP,
		missileDefP,
		projectileDefP,
		energyPoolDefP,
	].ors().lazyF();

	static var beamDefP = beamT._and(nameDeclP).band(damagePropP).band(beamPropP.many()).then(function (p) trace ('Parsing beam weapon definition')).lazyF().lazyF();

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

	static var energyMeleeDefP = energyT._and(meleeT)._and(nameDeclP).band(damagePropP).band(energyMeleePropP.many()).then(function (p) trace ('Parsing an energy melee definition')).lazyF();

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

	static var meleeDefP = meleeT._and(nameDeclP).band(damagePropP).band(meleePropP.many()).then(function (p) trace ('Parsing a melee weapon definition')).lazyF();

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

	static var missileDefP = missileT._and(nameDeclP).band(damagePropP).band(missilePropP.many()).then(function (p) trace ('Parsing a missile weapon definition')).lazyF();

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

	static var projectileDefP = projectileT._and(nameDeclP).band(damagePropP).band(projectilePropP.many()).then(function (p) trace ('Parsing a projectile weapon definition')).lazyF();

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

	static var energyPoolDefP = energyT._and(poolT)._and(nameDeclP).band(powerPropP).band(energyPoolPropP.many()).then(function (p) trace ('Parsing an energy pool definition')).lazyF();

	static var powerPropP = [
		numberP.and_(powerT).then(function (p) trace ('Parsing a power property')),
		batteryT.and_(powerT).then(function (p) trace ('Parsing a power property')),
	].ors().lazyF();

	static var energyPoolPropP = [
		systemPropP,
		morphablePropP,
	].ors().lazyF();

	static var ammoDefP = ammoT._and(nameDeclP).band(ammoPropP.many()).then(function (p) trace ('Parsing an ammo definition')).lazyF();

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

	static var matedSystemDefP = matedT._and(nameDeclP).band(systemPropP.many()).band(systemDeclP).band(systemDeclP).then(function (p) trace ('Parsing a mated system')).lazyF();

	static var shieldDefP = [
		shieldTypeP.option().band(armorClassP.option()).band(sizeClassP).and_(shieldT).band(nameDeclP).band(shieldPropP.many()).then(function (p) trace ('Parsing a shield definition')),
		shieldTypeP.option().band(armorClassP.option()).band(sizeClassP).and_(shieldT).band(shieldPropP.many()).then(function (p) trace ('Parsing a shield definition')),
	].ors().lazyF();

	static var shieldTypeP = [
		standardT,
		activeT,
		reactiveT,
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
		ablativeT.or(screenT).then                 (function (p) return Property.Screen),
		energyT._and(onlyT).or(interferenceT).then (function (p) return Property.Interference),
		matterT._and(onlyT).or(kineticT).then      (function (p) return Property.Kinetic),
		rangedT._and(onlyT).or(swashbucklingT).then(function (p) return Property.Swashbuckling),
		enclosingT.or(mirrorT).then                (function (p) return Property.Mirror),
		offensiveT.or(surgeT).then                 (function (p) return Property.Surge),
	].ors().lazyF();

	static var reflectorDefP = reflectorT._and(nameDeclP).band(qualityValuePropP).band(systemPropP.many()).then(function (p) trace ('Parsing a reflector definition')).lazyF();

	static var sensorDefP = sizeClassP.band(sensorT._and(nameDeclP)).band(sensorPropP.many()).then(function (p) trace ('Parsing a sensor definition')).lazyF();

	static var sensorPropP = [
		systemPropP,
		sensorRangePropP,
		commRangePropP,
	].ors().lazyF();

	static var elecWarDefP = ecmTypeP.band(nameDeclP).band(valuePropP).band(ecmPropP.many()).then(function (p) trace ('Parsing an ECM definition')).lazyF().lazyF();

	static var ecmTypeP = [
		sensorT._and(ecmT),
		missileT._and(ecmT),
		radarT._and(ecmT),
		eccmT,
	].ors().lazyF();

	static var ecmPropP = [
		systemPropP,
		radiusPropP,
		beamingPropP,
	].ors().lazyF();

	static var remoteControlDefP = sizeClassP.band(remoteT._and(controlT)._and(nameDeclP)).band(remoteControlPropP.many()).then(function (p) trace ('Parsing a remote control definition')).lazyF();

	static var remoteControlPropP = [
		systemPropP,
		controlRangePropP,
		operationRangePropP,
		wireControlledPropP,
	].ors().lazyF();

	/*************************
	*                        *
	*    Property Parsers    *
	*                        *
	*************************/
	static var costPropP           = numberP.and_(costT).then                                                      (function (p) return Property.Cost(Std.parseFloat(p))).lazyF();
	static var spacePropP          = numberP.and_(spaceT).then                                                     (function (p) return Property.Space(Std.parseFloat(p))).lazyF();
	static var killsPropP          = numberP.and_(killsT).then                                                     (function (p) return Property.Kills(Std.parseFloat(p))).lazyF();
	static var damagePropP         = numberP.and_(damageT).then                                                    (function (p) return Property.Damage(Std.parseFloat(p))).lazyF();
	static var accuracyPropP       = numberP.and_(accuracyT).then                                                  (function (p) return Property.Accuracy(Std.parseInt(p))).lazyF();
	static var rangePropP          = numberP.and_(rangeT).then                                                     (function (p) return Property.Range(Std.parseInt(p))).lazyF();
	static var shotsPropP          = numberP.and_(shotsT).then                                                     (function (p) return Property.Shots(Std.parseInt(p))).lazyF();
	static var warmUpPropP         = numberP.and_(warmUpT).then                                                    (function (p) return Property.WarmUp(Std.parseInt(p))).lazyF();
	static var wideAnglePropP      = numberP.and_(wideT).and_(angleT).then                                         (function (p) return Property.WideAngle(Std.parseInt(p))).lazyF();
	static var burstValuePropP     = numberP.and_(burstT).and_(valueT).then                                        (function (p) return Property.BurstValue(Std.parseInt(p))).lazyF();
	static var antiMissilePropP    = variableT.option().and_(antiMissileT).then                                    (function (p) return Property.AntiMissile(switch (p) { case Some(b): true; case None: false; })).lazyF();
	static var antiPersonnelPropP  = variableT.option().and_(antiPersonnelT).then                                  (function (p) return Property.AntiPersonnel(switch (p) { case Some(b): true; case None: false; })).lazyF();
	static var allPurposePropP     = allPurposeT.then                                                              (function (p) return Property.AllPurpose).lazyF();
	static var clipFedPropP        = clipFedT.then                                                                 (function (p) return Property.ClipFed).lazyF();
	static var megaBeamPropP       = megaBeamT.then                                                                (function (p) return Property.MegaBeam).lazyF();
	static var longRangePropP      = longT.band(rangeT).then                                                       (function (p) return Property.LongRange).lazyF();
	static var fragilePropP        = fragileT.then                                                                 (function (p) return Property.Fragile).lazyF();
	static var disruptorPropP      = disruptorT.then                                                               (function (p) return Property.Disruptor).lazyF();
	static var hydroPropP          = hydroT.then                                                                   (function (p) return Property.Hydro).lazyF();
	static var attackFactorPropP   = numberP.and_(attackT).and_(factorT).then                                      (function (p) return Property.AttackFactor(Std.parseInt(p))).lazyF();
	static var turnsInUsePropP     = numberP.and_(turnsT).and_(inT).and_(useT).then                                (function (p) return Property.TurnsInUse(Std.parseInt(p))).lazyF();
	static var beamShieldPropP     = variableT.option().and_(beamT).and_(shieldT).then                             (function (p) return Property.BeamShield(switch (p) { case Some(b): true; case None: false; })).lazyF();
	static var rechargeablePropP   = rechargeableT.then                                                            (function (p) return Property.Rechargeable).lazyF();
	static var thrownPropP         = thrownT.then                                                                  (function (p) return Property.Thrown).lazyF();
	static var quickPropP          = quickT.then                                                                   (function (p) return Property.Quick).lazyF();
	static var hyperPropP          = hyperT.then                                                                   (function (p) return Property.Hyper).lazyF();
	static var shockPropP          = shockT._and(onlyT.or(addedT)).or(shockT).then                                 (function (p) return Property.Shock(switch (p) { case 'Only': true; case 'Added': false; case _: false; })).lazyF();
	static var returningPropP      = returningT.then                                                               (function (p) return Property.Returning).lazyF();
	static var handyPropP          = handyT.then                                                                   (function (p) return Property.Handy).lazyF();
	static var clumsyPropP         = clumsyT.then                                                                  (function (p) return Property.Clumsy).lazyF();
	static var entanglePropP       = entangleT.then                                                                (function (p) return Property.Entangle).lazyF();
	static var armorPiercingPropP  = armorPiercingT.then                                                           (function (p) return Property.ArmorPiercing).lazyF();
	static var blastPropP          = blastT._and(numberP).then                                                     (function (p) return Property.Blast(Std.parseInt(p))).lazyF();
	static var smartPropP          = numberP.and_(smartT).then                                                     (function (p) return Property.Smart(Std.parseInt(p))).lazyF();
	static var skillPropP          = numberP.and_(skillT).then                                                     (function (p) return Property.Skill(Std.parseInt(p))).lazyF();
	static var hypervelocityPropP  = hypervelocityT.then                                                           (function (p) return Property.Hypervelocity).lazyF();
	static var countermissilePropP = variableT.option().and_(countermissileT).then                                 (function (p) return Property.Countermissile(switch (p) { case Some(b): true; case None: false; })).lazyF();
	static var fusePropP           = fuseT.then                                                                    (function (p) return Property.Fuse).lazyF();
	static var nuclearPropP        = nuclearT.then                                                                 (function (p) return Property.Nuclear).lazyF();
	static var foamPropP           = foamT.then                                                                    (function (p) return Property.Foam).lazyF();
	static var flarePropP          = flareT.then                                                                   (function (p) return Property.Flare).lazyF();
	static var scatterPropP        = scatterT.then                                                                 (function (p) return Property.Scatter).lazyF();
	static var smokePropP          = smokeT.then                                                                   (function (p) return Property.Smoke).lazyF();
	static var multiFeedPropP      = numberP.and_(multiFeedT).then                                                 (function (p) return Property.MultiFeed(Std.parseInt(p))).lazyF();
	static var phalanxPropP        = variableT.option().and_(phalanxT).then                                        (function (p) return Property.Phalanx(switch (p) { case Some(b): true; case None: false; })).lazyF();
	static var projAmmoPropP       = ammoT._and(declarationP.many()).then                                          (function (p) return Property.Ammo(p)).lazyF();
	static var morphablePropP      = morphableT.then                                                               (function (p) return Property.Morphable).lazyF();
	static var paintballPropP      = paintballT.then                                                               (function (p) return Property.Paintball).lazyF();
	static var highExPropP         = highExplosiveT.then                                                           (function (p) return Property.HighEx).lazyF();
	static var tracerPropP         = tracerT.then                                                                  (function (p) return Property.Tracer).lazyF();
	static var kineticPropP        = kineticT.then                                                                 (function (p) return Property.Kinetic).lazyF();
	static var tanglerPropP        = tanglerT.then                                                                 (function (p) return Property.Tangler).lazyF();
	static var incendiaryPropP     = incendiaryT.then                                                              (function (p) return Property.Incendiary).lazyF();
	static var scattershotPropP    = scattershotT.then                                                             (function (p) return Property.Scattershot).lazyF();
	static var stoppingPowerPropP  = numberP.and_(stoppingT).and_(powerT).then                                     (function (p) return Property.StoppingPower(Std.parseInt(p))).lazyF();
	static var defenseAbilityPropP = numberP.and_(defenseT).and_(abilityT).then                                    (function (p) return Property.DefenseAbility(Std.parseInt(p))).lazyF();
	static var binderSpacePropP    = dashT._and(numberP.and_(slashT).band(numberP)).and_(binderT.band(spaceT)).then(function (p) return Property.BinderSpace(Std.parseInt(p.a), Std.parseInt(p.b))).lazyF();
	static var resetPropP          = numberP.and_(resetT).then                                                     (function (p) return Property.Reset(Std.parseInt(p))).lazyF();
	static var qualityValuePropP   = numberP.and_(qualityT).and_(valueT).then                                      (function (p) return Property.QualityValue(Std.parseInt(p))).lazyF();
	static var sensorRangePropP    = numberP.and_(kmT.band(sensorT).band(rangeT)).then                             (function (p) return Property.SensorRange(Std.parseInt(p))).lazyF();
	static var commRangePropP      = numberP.and_(kmT.band(commT).band(rangeT)).then                               (function (p) return Property.CommRange(Std.parseInt(p))).lazyF();
	static var valuePropP          = numberP.and_(valueT).then                                                     (function (p) return Property.Value(Std.parseInt(p))).lazyF();
	static var radiusPropP         = numberP.and_(radiusT).then                                                    (function (p) return Property.Radius(Std.parseInt(p))).lazyF();
	static var beamingPropP        = numberP.and_(beamingT).then                                                   (function (p) return Property.Beaming(Std.parseInt(p))).lazyF();
	static var controlRangePropP   = numberP.and_(controlT).and_(rangeT).then                                      (function (p) return Property.ControlRange(Std.parseInt(p))).lazyF();
	static var operationRangePropP = numberP.and_(operationT).and_(rangeT).then                                    (function (p) return Property.OperationRange(Std.parseInt(p)))              .lazyF();
	static var wireControlledPropP = wireControlledT.then                                                          (function (p) return Property.WireControlled).lazyF();
}

class MekTest extends haxe.unit.TestCase {
	public function testCostPropP()                   propertyTest('1 Cost',                  MekParser.costPropP(),           Cost(1)              );
	public function testSpacePropP()                  propertyTest('1 Space',                 MekParser.spacePropP(),          Space(1)             );
	public function testKillsPropP()                  propertyTest('1 Kills',                 MekParser.killsPropP(),          Kills(1)             );
	public function testAccuracyPropP()               propertyTest('1 Accuracy',              MekParser.accuracyPropP(),       Accuracy(1)          );
	public function testRangePropP()                  propertyTest('1 Range',                 MekParser.rangePropP(),          Range(1)             );
	public function testShotsPropP()                  propertyTest('1 Shots',                 MekParser.shotsPropP(),          Shots(1)             );
	public function testWarmUpPropP()                 propertyTest('1 Warm-Up',               MekParser.warmUpPropP(),         WarmUp(1)            );
	public function testWideAnglePropP()              propertyTest('1 Wide Angle',            MekParser.wideAnglePropP(),      WideAngle(1)         );
	public function testBurstValuePropP()             propertyTest('1 Burst Value',           MekParser.burstValuePropP(),     BurstValue(1)        );
	public function testAntiMissilePropP()            propertyTest('Anti-Missile',            MekParser.antiMissilePropP(),    AntiMissile(false)   );
	public function testVariableAntiMissilePropP()    propertyTest('Variable Anti-Missile',   MekParser.antiMissilePropP(),    AntiMissile(true)    );
	public function testAntiPersonnelPropP()          propertyTest('Anti-Personnel',          MekParser.antiPersonnelPropP(),  AntiPersonnel(false) );
	public function testVariableAntiPersonnelPropP()  propertyTest('Variable Anti-Personnel', MekParser.antiPersonnelPropP(),  AntiPersonnel(true)  );
	public function testAllPurposePropP()             propertyTest('All-Purpose',             MekParser.allPurposePropP(),     AllPurpose           );
	public function testClipFedPropP()                propertyTest('Clip-Fed',                MekParser.clipFedPropP(),        ClipFed              );
	public function testMegaBeamPropP()               propertyTest('Mega-Beam',               MekParser.megaBeamPropP(),       MegaBeam             );
	public function testLongRangePropP()              propertyTest('Long Range',              MekParser.longRangePropP(),      LongRange            );
	public function testFragilePropP()                propertyTest('Fragile',                 MekParser.fragilePropP(),        Fragile              );
	public function testDisruptorPropP()              propertyTest('Disruptor',               MekParser.disruptorPropP(),      Disruptor            );
	public function testHydroPropP()                  propertyTest('Hydro',                   MekParser.hydroPropP(),          Hydro                );
	public function testAttackFactorPropP()           propertyTest('1 Attack Factor',         MekParser.attackFactorPropP(),   AttackFactor(1)      );
	public function testTurnsInUsePropP()             propertyTest('1 Turns In Use',          MekParser.turnsInUsePropP(),     TurnsInUse(1)        );
	public function testBeamShieldPropP()             propertyTest('Beam Shield',             MekParser.beamShieldPropP(),     BeamShield(false)    );
	public function testVariableBeamShieldPropP()     propertyTest('Variable Beam Shield',    MekParser.beamShieldPropP(),     BeamShield(true)     );
	public function testRechargeablePropP()           propertyTest('Rechargeable',            MekParser.rechargeablePropP(),   Rechargeable         );
	public function testThrownPropP()                 propertyTest('Thrown',                  MekParser.thrownPropP(),         Thrown               );
	public function testQuickPropP()                  propertyTest('Quick',                   MekParser.quickPropP(),          Quick                );
	public function testHyperPropP()                  propertyTest('Hyper',                   MekParser.hyperPropP(),          Hyper                );
	public function testShockPropP()                  propertyTest('Shock',                   MekParser.shockPropP(),          Shock(false)         );
	public function testShockAddedPropP()             propertyTest('Shock Added',             MekParser.shockPropP(),          Shock(false)         );
	public function testShockOnlyPropP()              propertyTest('Shock Only',              MekParser.shockPropP(),          Shock(true)          );
	public function testReturningPropP()              propertyTest('Returning',               MekParser.returningPropP(),      Returning            );
	public function testHandyPropP()                  propertyTest('Handy',                   MekParser.handyPropP(),          Handy                );
	public function testClumsyPropP()                 propertyTest('Clumsy',                  MekParser.clumsyPropP(),         Clumsy               );
	public function testEntanglePropP()               propertyTest('Entangle',                MekParser.entanglePropP(),       Entangle             );
	public function testArmorPiercingPropP()          propertyTest('Armor-Piercing',          MekParser.armorPiercingPropP(),  ArmorPiercing        );
	public function testBlastPropP()                  propertyTest('Blast 1',                 MekParser.blastPropP(),          Blast(1)             );
	public function testSmartPropP()                  propertyTest('1 Smart',                 MekParser.smartPropP(),          Smart(1)             );
	public function testSkillPropP()                  propertyTest('1 Skill',                 MekParser.skillPropP(),          Skill(1)             );
	public function testHypervelocityPropP()          propertyTest('Hypervelocity',           MekParser.hypervelocityPropP(),  Hypervelocity        );
	public function testCountermissilePropP()         propertyTest('Countermissile',          MekParser.countermissilePropP(), Countermissile(false));
	public function testVariableCountermissilePropP() propertyTest('Variable Countermissile', MekParser.countermissilePropP(), Countermissile(true) );
	public function testFusePropP()                   propertyTest('Fuse',                    MekParser.fusePropP(),           Fuse                 );
	public function testNuclearPropP()                propertyTest('Nuclear',                 MekParser.nuclearPropP(),        Nuclear              );
	public function testFoamPropP()                   propertyTest('Foam',                    MekParser.foamPropP(),           Foam                 );
	public function testFlarePropP()                  propertyTest('Flare',                   MekParser.flarePropP(),          Flare                );
	public function testScatterPropP()                propertyTest('Scatter',                 MekParser.scatterPropP(),        Scatter              );
	public function testSmokePropP()                  propertyTest('Smoke',                   MekParser.smokePropP(),          Smoke                );
	public function testMultiFeedPropP()              propertyTest('1 Multi-Feed',            MekParser.multiFeedPropP(),      MultiFeed(1)         );
	public function testPhalanxPropP()                propertyTest('Phalanx',                 MekParser.phalanxPropP(),        Phalanx(false)       );
	public function testVariablePhalanxPropP()        propertyTest('Variable Phalanx',        MekParser.phalanxPropP(),        Phalanx(true)        );
	public function testMorphablePropP()              propertyTest('Morphable',               MekParser.morphablePropP(),      Morphable            );
	public function testPaintballPropP()              propertyTest('Paintball',               MekParser.paintballPropP(),      Paintball            );
	public function testHighExPropP()                 propertyTest('High-Explosive',          MekParser.highExPropP(),         HighEx               );
	public function testTracerPropP()                 propertyTest('Tracer',                  MekParser.tracerPropP(),         Tracer               );
	public function testKineticPropP()                propertyTest('Kinetic',                 MekParser.kineticPropP(),        Kinetic              );
	public function testTanglerPropP()                propertyTest('Tangler',                 MekParser.tanglerPropP(),        Tangler              );
	public function testIncendiaryPropP()             propertyTest('Incendiary',              MekParser.incendiaryPropP(),     Incendiary           );
	public function testScattershotPropP()            propertyTest('Scattershot',             MekParser.scattershotPropP(),    Scattershot          );
	public function testStoppingPowerPropP()          propertyTest('1 Stopping Power',        MekParser.stoppingPowerPropP(),  StoppingPower(1)     );
	public function testDefenseAbilityPropP()         propertyTest('1 Defense Ability',       MekParser.defenseAbilityPropP(), DefenseAbility(1)    );
	public function testBinderSpacePropP()            propertyTest('-1/2 Binder Space',       MekParser.binderSpacePropP(),    BinderSpace(1,2)     );
	public function testResetPropP()                  propertyTest('1 Reset',                 MekParser.resetPropP(),          Reset(1)             );
	public function testQualityValuePropP()           propertyTest('1 Quality Value',         MekParser.qualityValuePropP(),   QualityValue(1)      );
	public function testSensorRangePropP()            propertyTest('1km Sensor Range',        MekParser.sensorRangePropP(),    SensorRange(1)       );
	public function testCommRangePropP()              propertyTest('1km Comm Range',          MekParser.commRangePropP(),      CommRange(1)         );
	public function testValuePropP()                  propertyTest('1 Value',                 MekParser.valuePropP(),          Value(1)             );
	public function testRadiusPropP()                 propertyTest('1 Radius',                MekParser.radiusPropP(),         Radius(1)            );
	public function testBeamingPropP()                propertyTest('1 Beaming',               MekParser.beamingPropP(),        Beaming(1)           );
	public function testControlRangePropP()           propertyTest('1 Control Range',         MekParser.controlRangePropP(),   ControlRange(1)      );
	public function testOperationRangePropP()         propertyTest('1 Operation Range',       MekParser.operationRangePropP(), OperationRange(1)    );
	public function testWireControlledPropP()         propertyTest('Wire-Controlled',         MekParser.wireControlledPropP(), WireControlled       );

	public function testProjAmmoPropP() {
		switch (MekParser.projAmmoPropP()('Ammo'.reader())) {
			case Failure(_,_): assertTrue(false);
			case Success(p,_): switch (p) {
				case Ammo(list):
					assertEquals(list, new Array<Int>());
				case _         : assertTrue(false);
			}
		}
		propertyTest('Ammo',                    MekParser.projAmmoPropP(),       Ammo([])             );
	}

	function propertyTest(str: String, parser: Parser<String, Property>, prop: Property) {
		switch (parser(str.reader())) {
			case Failure(_,_): assertTrue(false);
			case Success(p,_): assertEquals(p, prop);
		}
	}
}