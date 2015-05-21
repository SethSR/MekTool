import haxe.Timer;

import com.mindrocks.text.Parser;
using com.mindrocks.text.Parser;

using com.mindrocks.macros.LazyMacro;

import com.mindrocks.functional.Functional;

import MekTokens.*;

class MekSys {}

enum Crew {
	Cockpit;
	Passenger;
	ExtraCrew;
}

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
	static var fileP = definitionP.many().commit().lazyF();

	static var definitionP = [
		mektonDefP,
		systemDefP,
	].ors().lazyF();

	static var nameDeclP = colonT._and(identifierP);

	static var mektonDefP = mektonT._and(nameDeclP).and(servoP.many()).commit().lazyF();

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

	static var servoP = sizeClassP.and(servoTypeP).and(armorP).and(systemDeclP.many()).lazyF();

	static var sizeClassP = [
		superlightT.then          (function (p) return Superlight   ),
		lightweightT.then         (function (p) return Lightweight  ),
		strikerT.then             (function (p) return Striker      ),
		mediumT.and(strikerT).then(function (p) return MediumStriker),
		heavyT.and(strikerT).then (function (p) return HeavyStriker ),
		mediumweightT.then        (function (p) return Mediumweight ),
		lightT.and(heavyT).then   (function (p) return LightHeavy   ),
		mediumT.and(heavyT).then  (function (p) return MediumHeavy  ),
		armoredT.and(heavyT).then (function (p) return ArmoredHeavy ),
		superT.and(heavyT).then   (function (p) return SuperHeavy   ),
		megaT.and(heavyT).then    (function (p) return MegaHeavy    ),
	].ors().lazyF();

	static var servoTypeP = [
		torsoT.then(function (p) return Torso),
		headT.then (function (p) return Head ),
		armT.then  (function (p) return Arm  ),
		legT.then  (function (p) return Leg  ),
		tailT.then (function (p) return Tail ),
		wingT.then (function (p) return Wing ),
		podT.then  (function (p) return Pod  ),
	].ors().lazyF();

	static var armorP = [
		sizeClassP.and(armorClassP.option()).and_(armorT).then(function (p) return StandardArmor(p.a, p.b)),
		sizeClassP.and(armorClassP.option()).and(ramT._and(slashT._and(numberP))).then(function (p) return RAMArmor(p.a.a, p.a.b, Std.parseInt(p.b))),
	].ors().lazyF();

	static var armorClassP = [
		ablativeT.then(function (p) return Ablative),
		standardT.then(function (p) return Standard),
		alphaT.then   (function (p) return Alpha   ),
		betaT.then    (function (p) return Beta    ),
		gammaT.then   (function (p) return Gamma   ),
	].ors().lazyF();

	static var systemDeclP = [
		declarationP ,
		mountDeclP   ,
		handDeclP    ,
		crewDeclP    ,
		reconSysDeclP,
		optionDeclP  ,
	].ors().lazyF();

	static var declarationP = identifierP.lazyF();

	static var mountDeclP = [
		mountT._and(mountSystemP).and(systemPropP.many()),
		mountT.and(emptyT).and_( systemPropP.many()),
	].ors().lazyF();

	static var mountSystemP = [
		declarationP,
		crewDeclP   ,
		optionDeclP ,
	].ors().lazyF();

	static var crewDeclP = [
		cockpitT.then         (function (p) return Cockpit  ),
		passengerT.then       (function (p) return Passenger),
		extraT.and(crewT).then(function (p) return ExtraCrew),
	].ors().lazyF();

	static var optionDeclP = optionTypeP.and(systemPropP.many());

	static var optionTypeP = [
		stereoT.then                            (function (p) return Stereo              ),
		liftwireT.then                          (function (p) return Liftwire            ),
		antiTheftT.and(codeT).and(lockT).then   (function (p) return AntiTheftCodeLock   ),
		spotlightsT.then                        (function (p) return Spotlights          ),
		nightlightsT.then                       (function (p) return Nightlights         ),
		storageT.and(moduleT).then              (function (p) return StorageModule       ),
		micromanipulatorsT.then                 (function (p) return Micromanipulators   ),
		slickSprayT.then                        (function (p) return SlickSpray          ),
		boggSprayT.then                         (function (p) return BoggSpray           ),
		damageT.and(controlT).and(packageT).then(function (p) return DamageControlPackage),
		quickT.and(changeT).and(mountT).then    (function (p) return QuickChangeMount    ),
		silentT.and(runningT).then              (function (p) return SilentRunning       ),
		parachuteT.then                         (function (p) return Parachute           ),
		reEntryT.and(packageT).then             (function (p) return ReEntryPackage      ),
		ejectionT.and(seatT).then               (function (p) return EjectionSeat        ),
		escapeT.and(podT).then                  (function (p) return EscapePod           ),
		maneuverT.and(podT).then                (function (p) return ManeuverPod         ),
		vehicleT.and(podT).then                 (function (p) return VehiclePod          ),
	].ors().lazyF();

	static var systemPropP = [
		costPropP ,
		spacePropP,
		killsPropP,
	].ors().lazyF();

	static var costPropP = numberP.and_(costT).then(function (p) return Property.Cost(Std.parseFloat(p)));

	static var spacePropP = numberP.and_(spaceT).then(function (p) return Property.Space(Std.parseInt(p)));

	static var killsPropP = numberP.and_(killsT).then(function (p) return Property.Kills(Std.parseInt(p)));
}