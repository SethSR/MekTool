enum Property {
	/** System properties **/
	Cost(v: Float); //  = value + " Cost"
	Space(v: Float); // = value.toInt + " Space"
	Kills(v: Float); // = value.toInt + " Kills"

	/** Weapon properties **/
	Damage(v: Float);

	/** Beam properties **/
	ClipFed; //              = "Clip-Fed"
	Fragile; //              = "Fragile"
	Hydro; //                = "Hydro"
	MegaBeam; //             = "Mega-Beam"
	Shots(n: Int); //        = s"$n Shots"
	WarmUp(n: Int); //       = s"$n Warm-Up"
	WideAngle(n: Int); //    = s"$n Wide Angle"
	AntiMissile(b: Bool); // = if (b) "Variable " else "" + "Anti-Missile"

	/** Energy Melee properties **/
	Hyper; //                  = "Hyper"
	Rechargeable; //           = "Rechargeable"
	AttackFactor(n: Int); //   = s"$n Attack Factor"
	BeamShield(b: Bool); // = if (b) "Variable " else "" + "Beam Shield"

	/** Melee properties **/
	Clumsy; //    = "Clumsy"
	Entangle; //  = "Entangle"
	Handy; //     = "Handy"
	Returning; // = "Returning"

	/** Missile properties **/
	Flare; //                      = "Flare"
	Fuse; //                       = "Fuse"
	Scatter; //                    = "Scatter"
	Smoke; //                      = "Smoke"
	Countermissile(b: Bool); // = if (b) "Variable " else "" + "Countermissile"
	Skill(n: Int); //              = s"$n Skill"
	Smart(n: Int); //              = s"$n Smart"

	/** Projectile properties **/
	MultiFeed(n: Int); //               = s"$n Multi-Feed"
	Phalanx(value: Bool); //            = if (value) "Variable " else "" + "Phalanx"
	Ammo(system_list: Array<Int>); // = "Ammo" + system_list.map("\n    " + _.toInternal).mkString

	/** Energy Pool properties **/
	Power(n: Int);
	Morphable; //     = "Morphable"

	/** Shield properties **/
	BinderSpace(n: Int,d: Int); // = s"-$n/$d Binder Space"
	Reset(n: Int); //              = s"$n Reset"
	DefenseAbility(n: Int); //     = s"$n Defense Ability"

	/** Shield Weakness properties **/
	Interference; //  = "Interference"
	Kinetic; //       = "Kinetic"
	Mirror; //        = "Mirror"
	Screen; //        = "Screen"
	Surge; //         = "Surge"
	Swashbuckling; // = "Swashbuckling"

	/** Ammo Type properties **/
	HighEx; //      = "High-Explosive"
	Incendiary; //  = "Incendiary"
	Paintball; //   = "Paintball"
	Scattershot; // = "Scattershot"
	Tangler; //     = "Tangler"
	Tracer; //      = "Tracer"

	/** Multi-System properties **/
	Accuracy(n: Int); //       = n + " Accuracy"
	Disruptor; //              = "Disruptor"
	LongRange; //              = "Long Range"
	Range(n: Int); //          = n + " Range"
	AllPurpose; //             = "All-Purpose"
	AntiPersonnel(b: Bool); // = if (b) "Variable " else "" + "Anti-Personnel"
	BurstValue(n: Int); //     = s"$n Burst Value"
	Quick; //                  = "Quick"
	Thrown; //                 = "Thrown"
	TurnsInUse(n: Int); //     = n + " Turns in Use"
	ArmorPiercing; //          = "Armor-Piercing"
	Shock(b: Bool); //         = "Shock" + (if (b) " Only" else " Added")
	Hypervelocity; //          = "Hypervelocity"
	Foam; //                   = "Foam"
	Nuclear; //                = "Nuclear"
	Blast(n: Int); //          = "Blast " + n

	/** Misc. System properties **/
	WireControlled; //         = "Wire-Controlled"
	Beaming(n: Int); //        = n + " Beaming"
	CommRange(n: Int); //      = n + " km Comm Range"
	ControlRange(n: Int); //   = n + " Control Range"
	OperationRange(n: Int); // = n + " Operation Range"
	QualityValue(n: Int); //   = n + " Quality Value"
	Radius(n: Int); //         = n + " Radius"
	SensorRange(n: Int); //    = n + "km Sensor Range"
	StoppingPower(n: Int); //  = n + " Stopping Power"
	Value(n: Int); //          = n + " Value"
}