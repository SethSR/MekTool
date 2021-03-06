using com.mindrocks.text.Parser;
using com.mindrocks.macros.LazyMacro;

class MekTokens {
	static var spaceP = ' '.identifier().lazyF();
	static var tabP   = '\t'.identifier().lazyF();
	static var retP   = '\r'.identifier().lazyF();
	static var nlnP   = '\n'.identifier().lazyF();

	static var identifierR = ~/'(.+)'/;
	static var numberR     = ~/[-+]?[0-9]*\.?[0-9]+/;
	static var commentR    = ~/=.*/;

	static public var spacingP = [
		spaceP,
		tabP,
		retP,
		nlnP,
		commentR.regexParser(),
	].ors().many().lazyF();

	static function withSpacing<T>(p: Void -> Parser<String, T>): Void -> Parser<String, T> {
		return p.and_(spacingP);
	}

	static public var identifierP = withSpacing(identifierR.regexParser()).tag('identifier').lazyF();
	static public var numberP     = withSpacing(numberR.regexParser()).tag('number').lazyF();

	static public var percentT           = withSpacing('%'.identifier());
	static public var dashT              = withSpacing('-'.identifier());
	static public var slashT             = withSpacing('/'.identifier());
	static public var colonT             = withSpacing(':'.identifier());
	static public var quoteT             = withSpacing('\''.identifier());
	static public var abilityT           = withSpacing('Ability'.identifier());
	static public var ablativeT          = withSpacing('Ablative'.identifier());
	static public var accuracyT          = withSpacing('Accuracy'.identifier());
	static public var activeT            = withSpacing('Active'.identifier());
	static public var addedT             = withSpacing('Added'.identifier());
	static public var advancedT          = withSpacing('Advanced'.identifier());
	static public var allPurposeT        = withSpacing('All-Purpose'.identifier());
	static public var alphaT             = withSpacing('Alpha'.identifier());
	static public var ammoT              = withSpacing('Ammo'.identifier());
	static public var analyzerT          = withSpacing('Analyzer'.identifier());
	static public var angleT             = withSpacing('Angle'.identifier());
	static public var antiMissileT       = withSpacing('Anti-Missile'.identifier());
	static public var antiPersonnelT     = withSpacing('Anti-Personnel'.identifier());
	static public var antiTheftT         = withSpacing('Anti-Theft'.identifier());
	static public var armT               = withSpacing('Arm'.identifier());
	static public var armorT             = withSpacing('Armor'.identifier());
	static public var armorPiercingT     = withSpacing('Armor-Piercing'.identifier());
	static public var armoredT           = withSpacing('Armored'.identifier());
	static public var attackT            = withSpacing('Attack'.identifier());
	static public var batteryT           = withSpacing('Battery'.identifier());
	static public var beamT              = withSpacing('Beam'.identifier());
	static public var beamingT           = withSpacing('Beaming'.identifier());
	static public var betaT              = withSpacing('Beta'.identifier());
	static public var binderT            = withSpacing('Binder'.identifier());
	static public var blastT             = withSpacing('Blast'.identifier());
	static public var boggSprayT         = withSpacing('Bogg-Spray'.identifier());
	static public var burstT             = withSpacing('Burst'.identifier());
	static public var changeT            = withSpacing('Change'.identifier());
	static public var clipFedT           = withSpacing('Clip-Fed'.identifier());
	static public var clumsyT            = withSpacing('Clumsy'.identifier());
	static public var cockpitT           = withSpacing('Cockpit'.identifier());
	static public var codeT              = withSpacing('Code'.identifier());
	static public var commT              = withSpacing('Comm'.identifier());
	static public var controlT           = withSpacing('Control'.identifier());
	static public var costT              = withSpacing('Cost'.identifier());
	static public var countermissileT    = withSpacing('Countermissile'.identifier());
	static public var crewT              = withSpacing('Crew'.identifier());
	static public var damageT            = withSpacing('Damage'.identifier());
	static public var defenseT           = withSpacing('Defense'.identifier());
	static public var disruptorT         = withSpacing('Disruptor'.identifier());
	static public var eccmT              = withSpacing('ECCM'.identifier());
	static public var ecmT               = withSpacing('ECM'.identifier());
	static public var ejectionT          = withSpacing('Ejection'.identifier());
	static public var emptyT             = withSpacing('Empty'.identifier());
	static public var enclosingT         = withSpacing('Enclosing'.identifier());
	static public var energyT            = withSpacing('Energy'.identifier());
	static public var entangleT          = withSpacing('Entangle'.identifier());
	static public var escapeT            = withSpacing('Escape'.identifier());
	static public var extraT             = withSpacing('Extra'.identifier());
	static public var factorT            = withSpacing('Factor'.identifier());
	static public var flareT             = withSpacing('Flare'.identifier());
	static public var foamT              = withSpacing('Foam'.identifier());
	static public var fragileT           = withSpacing('Fragile'.identifier());
	static public var fuseT              = withSpacing('Fuse'.identifier());
	static public var gammaT             = withSpacing('Gamma'.identifier());
	static public var gravityT           = withSpacing('Gravity'.identifier());
	static public var handT              = withSpacing('Hand'.identifier());
	static public var handyT             = withSpacing('Handy'.identifier());
	static public var headT              = withSpacing('Head'.identifier());
	static public var heavyT             = withSpacing('Heavy'.identifier());
	static public var hexT               = withSpacing('Hex'.identifier());
	static public var highExplosiveT     = withSpacing('High-Explosive'.identifier());
	static public var hydroT             = withSpacing('Hydro'.identifier());
	static public var hyperT             = withSpacing('Hyper'.identifier());
	static public var hypervelocityT     = withSpacing('Hypervelocity'.identifier());
	static public var inT                = withSpacing('In'.identifier());
	static public var incendiaryT        = withSpacing('Incendiary'.identifier());
	static public var infinityT          = withSpacing('Infinity'.identifier());
	static public var intensifiersT      = withSpacing('Intensifiers'.identifier());
	static public var interferenceT      = withSpacing('Interference'.identifier());
	static public var killsT             = withSpacing('Kills'.identifier());
	static public var kineticT           = withSpacing('Kinetic'.identifier());
	static public var kmT                = withSpacing(~/[Kk]m/.regexParser());
	static public var legT               = withSpacing('Leg'.identifier());
	static public var lensT              = withSpacing('Lens'.identifier());
	static public var liftwireT          = withSpacing('Liftwire'.identifier());
	static public var lightT             = withSpacing('Light'.identifier());
	static public var lightweightT       = withSpacing('Lightweight'.identifier());
	static public var lockT              = withSpacing('Lock'.identifier());
	static public var longT              = withSpacing('Long'.identifier());
	static public var magneticT          = withSpacing('Magnetic'.identifier());
	static public var maneuverT          = withSpacing('Maneuver'.identifier());
	static public var marineT            = withSpacing('Marine'.identifier());
	static public var matedT             = withSpacing('Mated'.identifier());
	static public var matterT            = withSpacing('Matter'.identifier());
	static public var mediumT            = withSpacing('Medium'.identifier());
	static public var mediumweightT      = withSpacing('Mediumweight'.identifier());
	static public var megaT              = withSpacing('Mega'.identifier());
	static public var megaBeamT          = withSpacing('Mega-Beam'.identifier());
	static public var mektonT            = withSpacing('Mekton'.identifier());
	static public var meleeT             = withSpacing('Melee'.identifier());
	static public var micromanipulatorsT = withSpacing('Micromanipulators'.identifier());
	static public var mirrorT            = withSpacing('Mirror'.identifier());
	static public var missileT           = withSpacing('Missile'.identifier());
	static public var moduleT            = withSpacing('Module'.identifier());
	static public var morphableT         = withSpacing('Morphable'.identifier());
	static public var mountT             = withSpacing('Mount'.identifier());
	static public var multiFeedT         = withSpacing('Multi-Feed'.identifier());
	static public var nightlightsT       = withSpacing('Nightlights'.identifier());
	static public var nuclearT           = withSpacing('Nuclear'.identifier());
	static public var offensiveT         = withSpacing('Offensive'.identifier());
	static public var onlyT              = withSpacing('Only'.identifier());
	static public var operationT         = withSpacing('Operation'.identifier());
	static public var packageT           = withSpacing('Package'.identifier());
	static public var paintballT         = withSpacing('Paintball'.identifier());
	static public var parachuteT         = withSpacing('Parachute'.identifier());
	static public var passengerT         = withSpacing('Passenger'.identifier());
	static public var phalanxT           = withSpacing('Phalanx'.identifier());
	static public var podT               = withSpacing('Pod'.identifier());
	static public var poolT              = withSpacing('Pool'.identifier());
	static public var powerT             = withSpacing('Power'.identifier());
	static public var projectileT        = withSpacing('Projectile'.identifier());
	static public var qualityT           = withSpacing('Quality'.identifier());
	static public var quickT             = withSpacing('Quick'.identifier());
	static public var radarT             = withSpacing('Radar'.identifier());
	static public var radioT             = withSpacing('Radio'.identifier());
	static public var radiusT            = withSpacing('Radius'.identifier());
	static public var ramT               = withSpacing('RAM'.identifier());
	static public var rangeT             = withSpacing('Range'.identifier());
	static public var rangedT            = withSpacing('Ranged'.identifier());
	static public var reEntryT           = withSpacing('Re-Entry'.identifier());
	static public var reactiveT          = withSpacing('Reactive'.identifier());
	static public var rechargeableT      = withSpacing('Rechargeable'.identifier());
	static public var reflectorT         = withSpacing('Reflector'.identifier());
	static public var remoteT            = withSpacing('Remote'.identifier());
	static public var resetT             = withSpacing('Reset'.identifier());
	static public var resolutionT        = withSpacing('Resolution'.identifier());
	static public var resonanceT         = withSpacing('Resonance'.identifier());
	static public var returningT         = withSpacing('Returning'.identifier());
	static public var runningT           = withSpacing('Running'.identifier());
	static public var scatterT           = withSpacing('Scatter'.identifier());
	static public var scattershotT       = withSpacing('Scattershot'.identifier());
	static public var screenT            = withSpacing('Screen'.identifier());
	static public var seatT              = withSpacing('Seat'.identifier());
	static public var sensorT            = withSpacing('Sensor'.identifier());
	static public var shieldT            = withSpacing('Shield'.identifier());
	static public var shockT             = withSpacing('Shock'.identifier());
	static public var shotsT             = withSpacing('Shots'.identifier());
	static public var silentT            = withSpacing('Silent'.identifier());
	static public var skillT             = withSpacing('Skill'.identifier());
	static public var slickSprayT        = withSpacing('Slick-Spray'.identifier());
	static public var smartT             = withSpacing('Smart'.identifier());
	static public var smokeT             = withSpacing('Smoke'.identifier());
	static public var spaceT             = withSpacing('Space'.identifier());
	static public var spotlightsT        = withSpacing('Spotlights'.identifier());
	static public var spottingT          = withSpacing('Spotting'.identifier());
	static public var standardT          = withSpacing('Standard'.identifier());
	static public var stereoT            = withSpacing('Stereo'.identifier());
	static public var stoppingT          = withSpacing('Stopping'.identifier());
	static public var storageT           = withSpacing('Storage'.identifier());
	static public var strikerT           = withSpacing('Striker'.identifier());
	static public var suiteT             = withSpacing('Suite'.identifier());
	static public var superT             = withSpacing('Super'.identifier());
	static public var superlightT        = withSpacing('Superlight'.identifier());
	static public var surgeT             = withSpacing('Surge'.identifier());
	static public var swashbucklingT     = withSpacing('Swashbuckling'.identifier());
	static public var tailT              = withSpacing('Tail'.identifier());
	static public var tanglerT           = withSpacing('Tangler'.identifier());
	static public var targetT            = withSpacing('Target'.identifier());
	static public var thrownT            = withSpacing('Thrown'.identifier());
	static public var torsoT             = withSpacing('Torso'.identifier());
	static public var tracerT            = withSpacing('Tracer'.identifier());
	static public var turnsT             = withSpacing('Turns'.identifier());
	static public var useT               = withSpacing('Use'.identifier());
	static public var valueT             = withSpacing('Value'.identifier());
	static public var variableT          = withSpacing('Variable'.identifier());
	static public var vehicleT           = withSpacing('Vehicle'.identifier());
	static public var warmUpT            = withSpacing('Warm-Up'.identifier());
	static public var wideT              = withSpacing('Wide'.identifier());
	static public var wingT              = withSpacing('Wing'.identifier());
	static public var wireControlledT    = withSpacing('Wire-Controlled'.identifier());
	static public var xT                 = withSpacing('X'.identifier());
}