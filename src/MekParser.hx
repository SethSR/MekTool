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
		declarationP ,
		mountDeclP   ,
		handDeclP    ,
		crewDeclP    ,
		reconSysDeclP,
		optionDeclP  ,
	].ors();

	static var declarationP = identifierP.then(function (p) trace ('Parsing a declaration'));

	static var mountDeclP = [
		mountT._and(mountSystemP).and(systemPropP.many()).then(function (p) trace ('Parsing a mount declaration')),
		mountT.and(emptyT)._and(systemPropP.many()).then      (function (p) trace ('Parsing a mount declaration')),
	].ors();

	static var mountSystemP = [
		declarationP,
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

	static var costPropP  = numberP.and_(costT).then(function (p) trace ('Parsing a | property'));

	static var spacePropP = numberP.and_(spaceT).then(function (p) trace ('Parsing a | property'));

	static var killsPropP = numberP.and_(killsT).then(function (p) trace ('Parsing a | property'));


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

	static var damagePropP = numberP.and_(damageT).then(function (p) trace ('Parsing damage property'));

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

	static var accuracyPropP = numberP.and_(accuracyT).then(function (p) trace ('Parsing an accuracy property'));

	static var rangePropP = numberP.and_(rangeT).then(function (p) trace ('Parsing a | property'));

	static var shotsPropP = numberP.and_(shotsT).then(function (p) trace ('Parsing a | property'));

	static var warmUpPropP = numberP.and_(warmUpT).then(function (p) trace ('Parsing a | property'));

	static var wideAnglePropP = numberP.and_(wideT).and_(angleT).then(function (p) trace ('Parsing a | property'));

	static var burstValuePropP = numberP.and_(burstT).and_(valueT).then(function (p) trace ('Parsing a | property'));

	static var antiMissilePropP = numberP.and_(antiMissileT).then(function (p) trace ('Parsing a | property'));

	static var antiPersonnelPropP = numberP.and_(antiPersonnelT).then(function (p) trace ('Parsing a | property'));

	static var allPurposePropP = numberP.and_(allPurposeT).then(function (p) trace ('Parsing a | property'));

	static var clipFedPropP = numberP.and_(clipFedT).then(function (p) trace ('Parsing a | property'));

	static var megaBeamPropP = numberP.and_(megaBeamT).then(function (p) trace ('Parsing a | property'));

	static var longRangePropP = numberP.and_(longT).and_(rangeT).then(function (p) trace ('Parsing a | property'));

	static var fragilePropP = numberP.and_(fragileT).then(function (p) trace ('Parsing a | property'));

	static var disruptorPropP = numberP.and_(disruptorT).then(function (p) trace ('Parsing a | property'));

	static var hydroPropP = numberP.and_(hydroT).then(function (p) trace ('Parsing a | property'));

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

		static var attackFactorPropP = numberP.and_(attackT).and_(factorT).then(function (p) trace ('Parsing a | property'));

		static var turnsInUsePropP = numberP.and_(turnsT).and_(inT).and_(useT).then(function (p) trace ('Parsing a | property'));

		static var beamShieldPropP = numberP.and_(beamT).and_(shieldT).then(function (p) trace ('Parsing a | property'));

		static var rechargeablePropP = numberP.and_(rechargeableT).then(function (p) trace ('Parsing a | property'));

		static var thrownPropP = numberP.and_(thrownT).then(function (p) trace ('Parsing a | property'));

		static var quickPropP = numberP.and_(quickT).then(function (p) trace ('Parsing a | property'));

		static var hyperPropP = numberP.and_(hyperT).then(function (p) trace ('Parsing a | property'));

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

		static var shockPropP = numberP.and_(shockT).then(function (p) trace ('Parsing a | property'));

		static var returningPropP = numberP.and_(returningT).then(function (p) trace ('Parsing a | property'));

		static var handyPropP = numberP.and_(handyT).then(function (p) trace ('Parsing a | property'));

		static var clumsyPropP = numberP.and_(clumsyT).then(function (p) trace ('Parsing a | property'));

		static var entanglePropP = numberP.and_(entangleT).then(function (p) trace ('Parsing a | property'));

		static var armorPiercingPropP = numberP.and_(armorPiercingT).then(function (p) trace ('Parsing a | property'));

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

		static var blastPropP = numberP.and_(blastT).then(function (p) trace ('Parsing a | property'));

		static var smartPropP = numberP.and_(smartT).then(function (p) trace ('Parsing a | property'));

		static var skillPropP = numberP.and_(skillT).then(function (p) trace ('Parsing a | property'));

		static var hypervelocityPropP = numberP.and_(hypervelocityT).then(function (p) trace ('Parsing a | property'));

		static var countermissilePropP = numberP.and_(countermissileT).then(function (p) trace ('Parsing a | property'));

		static var fusePropP = numberP.and_(fuseT).then(function (p) trace ('Parsing a | property'));

		static var nuclearPropP = numberP.and_(nuclearT).then(function (p) trace ('Parsing a | property'));

		static var foamPropP = numberP.and_(foamT).then(function (p) trace ('Parsing a | property'));

		static var flarePropP = numberP.and_(flareT).then(function (p) trace ('Parsing a | property'));

		static var scatterPropP = numberP.and_(scatterT).then(function (p) trace ('Parsing a | property'));

		static var smokePropP = numberP.and_(smokeT).then(function (p) trace ('Parsing a | property'));

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

		static var multiFeedPropP = numberP.and_(multiFeedT).then(function (p) trace ('Parsing a | property'));

		static var phalanxPropP = numberP.and_(phalanxT).then(function (p) trace ('Parsing a | property'));

		static var projAmmoPropP = ammoT._and(declarationP.many()).then(function (p) trace ('Parsing a projectile ammo property'));

		static var energyPoolDefP = energyT._and(poolT)._and(nameDeclP).and(powerPropP).and(energyPoolPropP.many()).then(function (p) trace ('Parsing an energy pool definition'));

		static var powerPropP = [
			numberP.and_(powerT).then(function (p) trace ('Parsing a power property')),
			batteryT.and_(powerT).then(function (p) trace ('Parsing a power property')),
		].ors();

		static var energyPoolPropP = [
			systemPropP,
			morphablePropP,
		].ors();

		static var morphablePropP = morphableT.then(function (p) trace ('Parsing a morphable property'));

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

		static var paintballPropP = numberP.and_(paintballT).then(function (p) trace ('Parsing a | property'));

		static var highExPropP = numberP.and_(highExplosiveT).then(function (p) trace ('Parsing a | property'));

		static var tracerPropP = numberP.and_(tracerT).then(function (p) trace ('Parsing a | property'));

		static var kineticPropP = numberP.and_(kineticT).then(function (p) trace ('Parsing a | property'));

		static var tanglerPropP = numberP.and_(tanglerT).then(function (p) trace ('Parsing a | property'));

		static var incendiaryPropP = numberP.and_(incendiaryT).then(function (p) trace ('Parsing a | property'));

		static var scattershotPropP = numberP.and_(scattershotT).then(function (p) trace ('Parsing a | property'));

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

		static var stoppingPowerPropP = numberP.and_(stoppingT).and_(powerT).then(function (p) trace ('Parsing a | property'));

		static var defenseAbilityPropP = numberP.and_(defenseT).and_(abilityT).then(function (p) trace ('Parsing a | property'));

		static var binderSpacePropP = numberP.and_(binderT).and_(spaceT).then(function (p) trace ('Parsing a | property'));

		static var resetPropP = numberP.and_(resetT).then(function (p) trace ('Parsing a | property'));

	static var weaknessPropP = [
		ablativeT.or(screenT).then(function (p) trace ('Parsing screen property')),
		energyT._and(onlyT).or(interferenceT).then(function (p) trace ('Parsing interference property')),
		matterT._and(onlyT).or(kineticT).then(function (p) trace ('Parsing kinetic property')),
		rangedT._and(onlyT).or(swashbucklingT).then(function (p) trace ('Parsing swashbuckling property')),
		enclosingT.or(mirrorT).then(function (p) trace ('Parsing mirror property')),
		offensiveT.or(surgeT).then(function (p) trace ('Parsing surge property')),
	].ors();

	static var reflectorDefP = reflectorT._and(nameDeclP).and(qualityPropP).and(systemPropP.many()).then(function (p) trace ('Parsing a reflector definition'));

	static var qualityPropP = numberP.and_(qualityT).and_(valueT).then(function (p) trace ('Parsing a quality property'));

	static var sensorDefP = sizeClassP.and(sensorT._and(nameDeclP)).and(sensorPropP.many()).then(function (p) trace ('Parsing a sensor definition'));

	static var sensorPropP = [
		systemPropP,
		sensorRangePropP,
		commRangePropP,
	].ors();

	static var sensorRangePropP = numberP.and_(kmT).and_(sensorT).and_(rangeT).then(function (p) trace ('Parsing a sensor range property'));

	static var commRangePropP = numberP.and_(kmT).and_(commT).and_(rangeT).then(function (p) trace ('Parsing a comm range property'));

	static var elecWarDefP = ecmTypeP.and(nameDeclP).and(valuePropP).and(ecmPropP.many()).then(function (p) trace ('Parsing an ECM definition'));

	static var ecmTypeP = [
		sensorT._and(ecmT),
		missileT._and(ecmT),
		radarT._and(ecmT),
		eccmT,
	].ors();

	static var valuePropP = numberP.and_(valueT).then(function (p) trace ('Parsing a value property'));

	static var ecmPropP = [
		systemPropP,
		radiusPropP,
		beamingPropP,
	].ors();

	static var radiusPropP = numberP.and_(radiusT).then(function (p) trace ('Parsing radius property'));

	static var beamingPropP = numberP.and_(beamingT).then(function (p) trace ('Parsing beaming property'));

	static var remoteControlDefP = sizeClassP.and(remoteT._and(controlT)._and(nameDeclP)).and(remoteControlPropP.many()).then(function (p) trace ('Parsing a remote control definition'));

	static var remoteControlPropP = [
		systemPropP,
		controlRangePropP,
		operationRangePropP,
		wireControlledPropP,
	].ors();

	static var controlRangePropP = numberP.and_(controlT).and_(rangeT).then(function (p) trace ('Parsing control range property'));

	static var operationRangePropP = numberP.and_(operationT).and_(rangeT).then(function (p) trace ('Parsing operation range property'));

	static var wireControlledPropP = wireControlledT.then(function (p) trace ('Parsing wire-controlled property'));
}