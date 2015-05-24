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
	static function tryParse<T>(
		str       : String,
		parser    : Parser<String, T>,
		withResult: T -> Void,
		output    : String -> Void
	) {
		try {
			var res = Timer.measure(function () return parser(str.reader()));
		}
	}

	static public function test() {
		function toOutput(str: String) {
			trace (StringTools.replace(str, ' ', '_'));
		}

		tryParse(
			'Mekton',
			fileP(),
			function (res) trace ('Parsed ' + Std.string(res)),
			toOutput
		);
	}


	/************
	 *  Parser  *
	 ***********/
	static var fileP = definitionP.many();

	static var definitionP = [
		mektonDefP,
		systemDefP,
	].ors();

	static var nameDeclP = colonT._and(identifierP);

	static var mektonDefP = mektonT._and(nameDeclP).and(servoP.many()).then(function (p) trace ('Parsing a mekton definition'));

	static var systemDefP = [
		weaponDefP       ,
		ammoDefP         ,
		matedSystemDefP  ,
		shieldDefP       ,
		reflectorDefP    ,
		sensorDefP       ,
		elecWarDefP      ,
		remoteControlDefP,
	].ors();

	static var servoP = sizeClassP.and(servoTypeP).and(armorP).and(systemDeclP.many());

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
	].ors();

	static var servoTypeP = [
		torsoT,
		headT,
		armT,
		legT,
		tailT,
		wingT,
		podT,
	].ors();

	static var armorP = [
		sizeClassP.and(armorClassP.option()).and_(armorT),
		sizeClassP.and(armorClassP.option()).and_(ramT._and(numberP.and(slashT._and(numberP)))), //TODO this will need to be fixed
	].ors();

	static var armorClassP = [
		ablativeT,
		standardT,
		alphaT,
		betaT,
		gammaT,
	].ors();

	static var systemDeclP = [
		declarationP.then(function (p) trace ('Parsing a declaration')) ,
		mountDeclP   ,
		handDeclP    ,
		crewDeclP    ,
		reconSysDeclP,
		optionDeclP  ,
	].ors();

	static var declarationP = identifierP.then(function (p) return 0);

	static var mountDeclP = [
		mountT._and(mountSystemP).and(systemPropP.many()).then(function (p) trace ('Parsing a mount declaration')),
		mountT.and(emptyT)._and(systemPropP.many()).then      (function (p) trace ('Parsing a mount declaration')),
	].ors();

	static var mountSystemP = [
		declarationP.then(function (p) trace ('Parsing a declaration')),
		crewDeclP,
		optionDeclP,
	].ors();

	static var crewDeclP = [
		cockpitT.then         (function (p) trace ('Parsing a crew declaration')),
		passengerT.then       (function (p) trace ('Parsing a crew declaration')),
		extraT.and(crewT).then(function (p) trace ('Parsing a crew declaration')),
	].ors();

	static var optionDeclP = [
		stereoT._and(systemPropP.many()).then                            (function (p) trace ('Parsing an option declaration')),
		liftwireT._and(systemPropP.many()).then                          (function (p) trace ('Parsing an option declaration')),
		antiTheftT.and(codeT).and(lockT)._and(systemPropP.many()).then   (function (p) trace ('Parsing an option declaration')),
		spotlightsT._and(systemPropP.many()).then                        (function (p) trace ('Parsing an option declaration')),
		nightlightsT._and(systemPropP.many()).then                       (function (p) trace ('Parsing an option declaration')),
		storageT.and(moduleT)._and(systemPropP.many()).then              (function (p) trace ('Parsing an option declaration')),
		micromanipulatorsT._and(systemPropP.many()).then                 (function (p) trace ('Parsing an option declaration')),
		slickSprayT._and(systemPropP.many()).then                        (function (p) trace ('Parsing an option declaration')),
		boggSprayT._and(systemPropP.many()).then                         (function (p) trace ('Parsing an option declaration')),
		damageT.and(controlT).and(packageT)._and(systemPropP.many()).then(function (p) trace ('Parsing an option declaration')),
		quickT.and(changeT).and(mountT)._and(systemPropP.many()).then    (function (p) trace ('Parsing an option declaration')),
		silentT.and(runningT)._and(systemPropP.many()).then              (function (p) trace ('Parsing an option declaration')),
		parachuteT._and(systemPropP.many()).then                         (function (p) trace ('Parsing an option declaration')),
		reEntryT.and(packageT)._and(systemPropP.many()).then             (function (p) trace ('Parsing an option declaration')),
		ejectionT.and(seatT)._and(systemPropP.many()).then               (function (p) trace ('Parsing an option declaration')),
		escapeT.and(podT)._and(systemPropP.many()).then                  (function (p) trace ('Parsing an option declaration')),
		maneuverT.and(podT)._and(systemPropP.many()).then                (function (p) trace ('Parsing an option declaration')),
		vehicleT.and(podT)._and(systemPropP.many()).then                 (function (p) trace ('Parsing an option declaration')),
	].ors();

	static var systemPropP = [
		costPropP ,
		spacePropP,
		killsPropP,
	].ors();


	static var handDeclP = [
		handT._and(declarationP).and(systemPropP.many()).then(function (p) trace ('Parsing a hand declaration')),
		handT.and(emptyT)._and(systemPropP.many()).then      (function (p) trace ('Parsing a hand declaration')),
	].ors();

	static var reconSysDeclP = reconSysTypeP.and(systemPropP.many()).then(function (p) trace ('Parsing a recon system declaration'));

	static var reconSysTypeP = [
		advancedT.and(sensorT).and(packageT).then         (function (p) trace ('Parsing a recon system')),
		radioT.and(slashT).and(radarT).and(analyzerT).then(function (p) trace ('Parsing a recon system')),
		resolutionT.and(intensifiersT).then               (function (p) trace ('Parsing a recon system')),
		spottingT.and(radarT).then                        (function (p) trace ('Parsing a recon system')),
		targetT.and(analyzerT).then                       (function (p) trace ('Parsing a recon system')),
		marineT.and(suiteT).then                          (function (p) trace ('Parsing a recon system')),
		gravityT.and(lensT).then                          (function (p) trace ('Parsing a recon system')),
		magneticT.and(resonanceT).then                    (function (p) trace ('Parsing a recon system')),
	].ors();

	static var weaponDefP = [
		beamDefP,
		energyMeleeDefP,
		meleeDefP,
		missileDefP,
		projectileDefP,
		energyPoolDefP,
	].ors();

	static var beamDefP = beamT._and(nameDeclP).and(damagePropP).and(beamPropP.many()).then(function (p) trace ('Parsing beam weapon definition'));

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
	].ors();

	static var energyMeleeDefP = energyT._and(meleeT)._and(nameDeclP).and(damagePropP).and(energyMeleePropP.many()).then(function (p) trace ('Parsing an energy melee definition'));

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
	].ors();

		static var meleeDefP = meleeT._and(nameDeclP).and(damagePropP).and(meleePropP.many()).then(function (p) trace ('Parsing a melee weapon definition'));

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
		].ors();

		static var missileDefP = missileT._and(nameDeclP).and(damagePropP).and(missilePropP.many()).then(function (p) trace ('Parsing a missile weapon definition'));

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
		].ors();

		static var projectileDefP = projectileT._and(nameDeclP).and(damagePropP).and(projectilePropP.many()).then(function (p) trace ('Parsing a projectile weapon definition'));

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
		].ors();

		static var energyPoolDefP = energyT._and(poolT)._and(nameDeclP).and(powerPropP).and(energyPoolPropP.many()).then(function (p) trace ('Parsing an energy pool definition'));

		static var powerPropP = [
			numberP.and_(powerT).then(function (p) trace ('Parsing a power property')),
			batteryT.and_(powerT).then(function (p) trace ('Parsing a power property')),
		].ors();

		static var energyPoolPropP = [
			systemPropP,
			morphablePropP,
		].ors();

		static var ammoDefP = ammoT._and(nameDeclP).and(ammoPropP.many()).then(function (p) trace ('Parsing an ammo definition'));

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
		].ors();

		static var matedSystemDefP = matedT._and(nameDeclP).and(systemPropP.many()).and(systemDeclP).and(systemDeclP).then(function (p) trace ('Parsing a mated system'));

		static var shieldDefP = [
			shieldTypeP.option().and(armorClassP.option()).and(sizeClassP).and_(shieldT).and(nameDeclP).and(shieldPropP.many()).then(function (p) trace ('Parsing a shield definition')),
			shieldTypeP.option().and(armorClassP.option()).and(sizeClassP).and_(shieldT).and(shieldPropP.many()).then(function (p) trace ('Parsing a shield definition')),
		].ors();

		static var shieldTypeP = [
			standardT,
			activeT,
			reactiveT,
		].ors();

		static var shieldPropP = [
			systemPropP,
			stoppingPowerPropP,
			defenseAbilityPropP,
			binderSpacePropP,
			resetPropP,
			turnsInUsePropP,
			weaknessPropP,
		].ors();

	static var weaknessPropP = [
		ablativeT.or(screenT).then                 (function (p) return Property.Screen),
		energyT._and(onlyT).or(interferenceT).then (function (p) return Property.Interference),
		matterT._and(onlyT).or(kineticT).then      (function (p) return Property.Kinetic),
		rangedT._and(onlyT).or(swashbucklingT).then(function (p) return Property.Swashbuckling),
		enclosingT.or(mirrorT).then                (function (p) return Property.Mirror),
		offensiveT.or(surgeT).then                 (function (p) return Property.Surge),
	].ors();

	static var reflectorDefP = reflectorT._and(nameDeclP).and(qualityPropP).and(systemPropP.many()).then(function (p) trace ('Parsing a reflector definition'));

	static var sensorDefP = sizeClassP.and(sensorT._and(nameDeclP)).and(sensorPropP.many()).then(function (p) trace ('Parsing a sensor definition'));

	static var sensorPropP = [
		systemPropP,
		sensorRangePropP,
		commRangePropP,
	].ors();

	static var elecWarDefP = ecmTypeP.and(nameDeclP).and(valuePropP).and(ecmPropP.many()).then(function (p) trace ('Parsing an ECM definition'));

	static var ecmTypeP = [
		sensorT._and(ecmT),
		missileT._and(ecmT),
		radarT._and(ecmT),
		eccmT,
	].ors();

	static var ecmPropP = [
		systemPropP,
		radiusPropP,
		beamingPropP,
	].ors();

	static var remoteControlDefP = sizeClassP.and(remoteT._and(controlT)._and(nameDeclP)).and(remoteControlPropP.many()).then(function (p) trace ('Parsing a remote control definition'));

	static var remoteControlPropP = [
		systemPropP,
		controlRangePropP,
		operationRangePropP,
		wireControlledPropP,
	].ors();

	/*************************
	*                        *
	*    Property Parsers    *
	*                        *
	*************************/
	static var costPropP           = numberP.and_(costT).then                                                    (function (p) return Property.Cost(Std.parseFloat(p)));
	static var spacePropP          = numberP.and_(spaceT).then                                                   (function (p) return Property.Space(Std.parseFloat(p)));
	static var killsPropP          = numberP.and_(killsT).then                                                   (function (p) return Property.Kills(Std.parseFloat(p)));
	static var damagePropP         = numberP.and_(damageT).then                                                  (function (p) return Property.Damage(Std.parseFloat(p)));
	static var accuracyPropP       = numberP.and_(accuracyT).then                                                (function (p) return Property.Accuracy(Std.parseInt(p)));
	static var rangePropP          = numberP.and_(rangeT).then                                                   (function (p) return Property.Range(Std.parseInt(p)));
	static var shotsPropP          = numberP.and_(shotsT).then                                                   (function (p) return Property.Shots(Std.parseInt(p)));
	static var warmUpPropP         = numberP.and_(warmUpT).then                                                  (function (p) return Property.WarmUp(Std.parseInt(p)));
	static var wideAnglePropP      = numberP.and_(wideT).and_(angleT).then                                       (function (p) return Property.WideAngle(Std.parseInt(p)));
	static var burstValuePropP     = numberP.and_(burstT).and_(valueT).then                                      (function (p) return Property.BurstValue(Std.parseInt(p)));
	static var antiMissilePropP    = variableT.option().and_(antiMissileT).then                                  (function (p) return Property.AntiMissile(switch (p) { case Some(b): true; case None: false; }));
	static var antiPersonnelPropP  = variableT.option().and_(antiPersonnelT).then                                (function (p) return Property.AntiPersonnel(switch (p) { case Some(b): true; case None: false; }));
	static var allPurposePropP     = allPurposeT.then                                                            (function (p) return Property.AllPurpose);
	static var clipFedPropP        = clipFedT.then                                                               (function (p) return Property.ClipFed);
	static var megaBeamPropP       = megaBeamT.then                                                              (function (p) return Property.MegaBeam);
	static var longRangePropP      = longT.and(rangeT).then                                                      (function (p) return Property.LongRange);
	static var fragilePropP        = fragileT.then                                                               (function (p) return Property.Fragile);
	static var disruptorPropP      = disruptorT.then                                                             (function (p) return Property.Disruptor);
	static var hydroPropP          = hydroT.then                                                                 (function (p) return Property.Hydro);
	static var attackFactorPropP   = numberP.and_(attackT).and_(factorT).then                                    (function (p) return Property.AttackFactor(Std.parseInt(p)));
	static var turnsInUsePropP     = numberP.and_(turnsT).and_(inT).and_(useT).then                              (function (p) return Property.TurnsInUse(Std.parseInt(p)));
	static var beamShieldPropP     = variableT.option().and_(beamT).and_(shieldT).then                           (function (p) return Property.BeamShield(switch (p) { case Some(b): true; case None: false; }));
	static var rechargeablePropP   = rechargeableT.then                                                          (function (p) return Property.Rechargeable);
	static var thrownPropP         = thrownT.then                                                                (function (p) return Property.Thrown);
	static var quickPropP          = quickT.then                                                                 (function (p) return Property.Quick);
	static var hyperPropP          = hyperT.then                                                                 (function (p) return Property.Hyper);
	static var shockPropP          = shockT._and(onlyT.or(addedT)).then                                          (function (p) return Property.Shock(switch (p) { case 'Only': true; case 'Added': false; case _: false; }));
	static var returningPropP      = returningT.then                                                             (function (p) return Property.Returning);
	static var handyPropP          = handyT.then                                                                 (function (p) return Property.Handy);
	static var clumsyPropP         = clumsyT.then                                                                (function (p) return Property.Clumsy);
	static var entanglePropP       = entangleT.then                                                              (function (p) return Property.Entangle);
	static var armorPiercingPropP  = armorPiercingT.then                                                         (function (p) return Property.ArmorPiercing);
	static var blastPropP          = blastT._and(numberP).then                                                   (function (p) return Property.Blast(Std.parseInt(p)));
	static var smartPropP          = numberP.and_(smartT).then                                                   (function (p) return Property.Smart(Std.parseInt(p)));
	static var skillPropP          = numberP.and_(skillT).then                                                   (function (p) return Property.Skill(Std.parseInt(p)));
	static var hypervelocityPropP  = hypervelocityT.then                                                         (function (p) return Property.Hypervelocity);
	static var countermissilePropP = variableT.option().and_(countermissileT).then                               (function (p) return Property.Countermissile(switch (p) { case Some(b): true; case None: false; }));
	static var fusePropP           = fuseT.then                                                                  (function (p) return Property.Fuse);
	static var nuclearPropP        = nuclearT.then                                                               (function (p) return Property.Nuclear);
	static var foamPropP           = foamT.then                                                                  (function (p) return Property.Foam);
	static var flarePropP          = flareT.then                                                                 (function (p) return Property.Flare);
	static var scatterPropP        = scatterT.then                                                               (function (p) return Property.Scatter);
	static var smokePropP          = smokeT.then                                                                 (function (p) return Property.Smoke);
	static var multiFeedPropP      = numberP.and_(multiFeedT).then                                               (function (p) return Property.MultiFeed(Std.parseInt(p)));
	static var phalanxPropP        = variableT.option().and_(phalanxT).then                                      (function (p) return Property.Phalanx(switch (p) { case Some(b): true; case None: false; }));
	static var projAmmoPropP       = ammoT._and(declarationP.many()).then                                        (function (p) return Property.Ammo(p));
	static var morphablePropP      = morphableT.then                                                             (function (p) return Property.Morphable);
	static var paintballPropP      = paintballT.then                                                             (function (p) return Property.Paintball);
	static var highExPropP         = highExplosiveT.then                                                         (function (p) return Property.HighEx);
	static var tracerPropP         = tracerT.then                                                                (function (p) return Property.Tracer);
	static var kineticPropP        = kineticT.then                                                               (function (p) return Property.Kinetic);
	static var tanglerPropP        = tanglerT.then                                                               (function (p) return Property.Tangler);
	static var incendiaryPropP     = incendiaryT.then                                                            (function (p) return Property.Incendiary);
	static var scattershotPropP    = scattershotT.then                                                           (function (p) return Property.Scattershot);
	static var stoppingPowerPropP  = numberP.and_(stoppingT).and_(powerT).then                                   (function (p) return Property.StoppingPower(Std.parseInt(p)));
	static var defenseAbilityPropP = numberP.and_(defenseT).and_(abilityT).then                                  (function (p) return Property.DefenseAbility(Std.parseInt(p)));
	static var binderSpacePropP    = dashT._and(numberP.and_(slashT).and(numberP)).and_(binderT.and(spaceT)).then(function (p) return Property.BinderSpace(Std.parseInt(p.a), Std.parseInt(p.b)));
	static var resetPropP          = numberP.and_(resetT).then                                                   (function (p) return Property.Reset(Std.parseInt(p)));
	static var qualityPropP        = numberP.and_(qualityT).and_(valueT).then                                    (function (p) return Property.Quality(Std.parseInt(p)));
	static var sensorRangePropP    = numberP.and_(kmT.and(sensorT).and(rangeT)).then                             (function (p) return Property.SensorRange(Std.parseInt(p)));
	static var commRangePropP      = numberP.and_(kmT.and(commT).and(rangeT)).then                               (function (p) return Property.CommRange(Std.parseInt(p)));
	static var valuePropP          = numberP.and_(valueT).then                                                   (function (p) return Property.Value(Std.parseInt(p)));
	static var radiusPropP         = numberP.and_(radiusT).then                                                  (function (p) return Property.Radius(Std.parseInt(p)));
	static var beamingPropP        = numberP.and_(beamingT).then                                                 (function (p) return Property.Beaming(Std.parseInt(p)));
	static var controlRangePropP   = numberP.and_(controlT).and_(rangeT).then                                    (function (p) return Property.ControlRange(Std.parseInt(p)));
	static var operationRangePropP = numberP.and_(operationT).and_(rangeT).then                                  (function (p) return Property.OperationRange(Std.parseInt(p)))              ;
	static var wireControlledPropP = wireControlledT.then                                                        (function (p) return Property.WireControlled);
}

class MekTest extends haxe.unit.TestCase {
	function testProperty(str: String, parser: Parser<String, Property>, prop: Property) {
		switch (parser(str.reader())) {
			case Failure(_,_): assertTrue(false);
			case Success(p,_): assertEquals(p, prop);
		}
	}

	public function testCostPropP()                testProperty('1 Cost', MekParser.costPropP(), Cost(1));
	public function testSpacePropP()               testProperty('1 Space', MekParser.spacePropP(), Space(1));
	public function testKillsPropP()               testProperty('1 Kills', MekParser.killsPropP(), Kills(1));
	public function testAccuracyPropP()            testProperty('1 Accuracy', MekParser.accuracyPropP(), Accuracy(1));
	public function testRangePropP()               testProperty('1 Range', MekParser.rangePropP(), Range(1));
	public function testShotsPropP()               testProperty('1 Shots', MekParser.shotsPropP(), Shots(1));
	public function testWarmUpPropP()              testProperty('1 Warm-Up', MekParser.warmUpPropP(), WarmUp(1));
	public function testWideAnglePropP()           testProperty('1 Wide-Angle', MekParser.wideAnglePropP(), WideAngle(1));
	public function testBurstValuePropP()          testProperty('1 Burst Value', MekParser.burstValuePropP(), BurstValue(1));
	public function testAntiMissilePropP()         testProperty('Anti-Missile', MekParser.antiMissilePropP(), AntiMissile(false));
	public function testVariableAntiMissilePropP() testProperty('Variable Anti-Missile', MekParser.antiMissilePropP(), AntiMissile(true));
	public function testAntiPersonnelPropP()       testProperty('', MekParser.antiPersonnelPropP(), AntiPersonnel());
	public function testAllPurposePropP()          testProperty('', MekParser.allPurposePropP(), AllPurpose());
	public function testClipFedPropP()             testProperty('', MekParser.clipFedPropP(), ClipFed());
	public function testMegaBeamPropP()            testProperty('', MekParser.megaBeamPropP(), MegaBeam());
	public function testLongRangePropP()           testProperty('', MekParser.longRangePropP(), LongRange());
	public function testFragilePropP()             testProperty('', MekParser.fragilePropP(), Fragile());
	public function testDisruptorPropP()           testProperty('', MekParser.disruptorPropP(), Disruptor());
	public function testHydroPropP()               testProperty('', MekParser.hydroPropP(), Hydro());
	public function testAttackFactorPropP()        testProperty('', MekParser.attackFactorPropP(), AttackFactor());
	public function testTurnsInUsePropP()          testProperty('', MekParser.turnsInUsePropP(), TurnsInUse());
	public function testBeamShieldPropP()          testProperty('', MekParser.beamShieldPropP(), BeamShield());
	public function testRechargeablePropP()        testProperty('', MekParser.rechargeablePropP(), Rechargeable());
	public function testThrownPropP()              testProperty('', MekParser.thrownPropP(), Thrown());
	public function testQuickPropP()               testProperty('', MekParser.quickPropP(), Quick());
	public function testHyperPropP()               testProperty('', MekParser.hyperPropP(), Hyper());
	public function testShockPropP()               testProperty('', MekParser.shockPropP(), Shock());
	public function testReturningPropP()           testProperty('', MekParser.returningPropP(), Returning());
	public function testHandyPropP()               testProperty('', MekParser.handyPropP(), Handy());
	public function testClumsyPropP()              testProperty('', MekParser.clumsyPropP(), Clumsy());
	public function testEntanglePropP()            testProperty('', MekParser.entanglePropP(), Entangle());
	public function testArmorPiercingPropP()       testProperty('', MekParser.armorPiercingPropP(), ArmorPiercing());
	public function testBlastPropP()               testProperty('', MekParser.blastPropP(), Blast());
	public function testSmartPropP()               testProperty('', MekParser.smartPropP(), Smart());
	public function testSkillPropP()               testProperty('', MekParser.skillPropP(), Skill());
	public function testHypervelocityPropP()       testProperty('', MekParser.hypervelocityPropP(), Hypervelocity());
	public function testCountermissilePropP()      testProperty('', MekParser.countermissilePropP(), Countermissile());
	public function testFusePropP()                testProperty('', MekParser.fusePropP(), Fuse());
	public function testNuclearPropP()             testProperty('', MekParser.nuclearPropP(), Nuclear());
	public function testFoamPropP()                testProperty('', MekParser.foamPropP(), Foam());
	public function testFlarePropP()               testProperty('', MekParser.flarePropP(), Flare());
	public function testScatterPropP()             testProperty('', MekParser.scatterPropP(), Scatter());
	public function testSmokePropP()               testProperty('', MekParser.smokePropP(), Smoke());
	public function testMultiFeedPropP()           testProperty('', MekParser.multiFeedPropP(), MultiFeed());
	public function testPhalanxPropP()             testProperty('', MekParser.phalanxPropP(), Phalanx());
	public function testProjAmmoPropP()            testProperty('', MekParser.projAmmoPropP(), ProjAmmo());
	public function testMorphablePropP()           testProperty('', MekParser.morphablePropP(), Morphable());
	public function testPaintballPropP()           testProperty('', MekParser.paintballPropP(), Paintball());
	public function testHighExPropP()              testProperty('', MekParser.highExPropP(), HighEx());
	public function testTracerPropP()              testProperty('', MekParser.tracerPropP(), Tracer());
	public function testKineticPropP()             testProperty('', MekParser.kineticPropP(), Kinetic());
	public function testTanglerPropP()             testProperty('', MekParser.tanglerPropP(), Tangler());
	public function testIncendiaryPropP()          testProperty('', MekParser.incendiaryPropP(), Incendiary());
	public function testScattershotPropP()         testProperty('', MekParser.scattershotPropP(), Scattershot());
	public function testStoppingPowerPropP()       testProperty('', MekParser.stoppingPowerPropP(), StoppingPower());
	public function testDefenseAbilityPropP()      testProperty('', MekParser.defenseAbilityPropP(), DefenseAbility());
	public function testBinderSpacePropP()         testProperty('', MekParser.binderSpacePropP(), BinderSpace());
	public function testResetPropP()               testProperty('', MekParser.resetPropP(), Reset());
	public function testQualityPropP()             testProperty('', MekParser.qualityPropP(), Quality());
	public function testSensorRangePropP()         testProperty('', MekParser.sensorRangePropP(), SensorRange());
	public function testCommRangePropP()           testProperty('', MekParser.commRangePropP(), CommRange());
	public function testValuePropP()               testProperty('', MekParser.valuePropP(), Value());
	public function testRadiusPropP()              testProperty('', MekParser.radiusPropP(), Radius());
	public function testBeamingPropP()             testProperty('', MekParser.beamingPropP(), Beaming());
	public function testControlRangePropP()        testProperty('', MekParser.controlRangePropP(), ControlRange());
	public function testOperationRangePropP()      testProperty('', MekParser.operationRangePropP(), OperationRange());
	public function testWireControlledPropP()      testProperty('', MekParser.wireControlledPropP(), WireControlled());
}