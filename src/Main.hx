import snow.api.Debug.*;
using snow.types.Types;

class Main extends snow.App {
    override function config(config: AppConfig) {
        config.window.title = 'MekTool - Mekton Zeta';
        return config;
    } //config

    override function ready() {
    	var test = new haxe.unit.TestRunner();
    	test.add(new PropertyTest());
    	test.run();
    	MekParser.test("Mekton : 'RX-78-2 Gundam'
	Striker Torso = (6,6,6)
		Striker Alpha Armor = (3,3):1
		Cockpit
		Mount
			'Beam Saber'
		Mount
			'Beam Saber'

	Striker Head = (3,3,3)
		Striker Alpha Armor = (3,3):1
		'60mm Gatling Cannons'

	Striker Arm = Right = (4,4,4)
		Striker Alpha Armor = (3,3):1
		Hand
			'BAUVA XBR-M-79-07G'

	Striker Arm = Left = (4,4,4)
		Striker Alpha Armor = (3,3):1
		Hand
			'RX M-Sh-008/S-01025'

	Striker Leg = Right = (4,4,4)
		Striker Alpha Armor = (3,3):1

	Striker Leg = Left = (4,4,4)
		Striker Alpha Armor = (3,3):1

	Striker Pod = ()
		Striker Alpha Armor = (3,3):1
		'Hyper Hammer'
		'BLASH XHB-L-03/N-STD'


Projectile : '60mm Gatling Cannons'
	5 Damage
	4 Burst Value
	5 Cost
	All-Purpose = x2.6
= 7 Range

Energy Melee : 'Beam Saber'
	8 Damage
	0 Accuracy
	Thrown
Energy Melee : 'Beam Javelin'
	8 Damage
	0 Accuracy = x0.9
	Thrown     = x1.2
	2 Kills
	8 Cost     = 8 -> 8.64

Melee : 'Hyper Hammer'
	12 Damage
	-2 Accuracy    = x0.6
	12 Kills
	6 Cost         = 6 -> = 10.8
	Armor-Piercing = x2.0
	Returning      = x1.5

Beam : 'BAUVA XBR-M-79-07G'
	12 Damage
	0 Accuracy = x0.9
	Clip-Fed   = x0.9
	1 Kills    = 12 -> 1
	18 Cost    = 18 -> 14.58
	18 Space   = 18 -> 14.58 -> 1
	15 Shots
	Fragile
=	14 Range

Projectile : 'BLASH XHB-L-03/N-STD'
	12 Damage
	Long Range = x1.33
	12 Kills
	12 Cost    = 12 -> 16
	12 Space
=	10 Range (-2/-2)
	Ammo
		'High Explosive'

Medium Striker Shield : 'RX M-Sh-008/S-01025'
	0 Defense Ability = x1.5
	8 Stopping Power
	8 Cost            = 8 -> 12

Ammo : 'High Explosive'
	Blast 1
	1.6 Cost = 1.6 -> 9.6");
    } //ready

    override function onkeydown(
  		keycode: Int,
  		scancode: Int,
  		repeat: Bool,
  		mod: snow.types.ModState,
  		timestamp: Float,
  		window_id: Int
    ): Void {
    	if (keycode == Key.escape)
    		Sys.exit(0);
    }
} //Main