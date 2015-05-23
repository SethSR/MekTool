import AST;

enum Property {
	/** System properties **/
	Cost(v: Float); //  extends SystemProperty { override val toString = value + " Cost" }
	Space(v: Float); // extends SystemProperty { override val toString = value.toInt + " Space" }
	Kills(v: Float); // extends SystemProperty { override val toString = value.toInt + " Kills" }

	/** Beam properties **/
	ClipFed; //              extends BeamProperty { override val toString = "Clip-Fed" }
	Fragile; //              extends BeamProperty { override val toString = "Fragile" }
	Hydro; //                extends BeamProperty { override val toString = "Hydro" }
	MegaBeam; //             extends BeamProperty { override val toString = "Mega-Beam" }
	Shots(n: Int); //        extends BeamProperty { override val toString = s"$n Shots" }
	WarmUp(n: Int); //       extends BeamProperty { override val toString = s"$n Warm-Up" }
	WideAngle(n: Int); //    extends BeamProperty { override val toString = s"$n Wide Angle" }
	AntiMissile(b: Bool); // extends BeamProperty { override val toString = if (b) "Variable " else "" + "Anti-Missile" }

	/** Energy Melee properties **/
	Hyper; //                  extends EnergyMeleeProperty { override val toString = "Hyper" }
	Rechargeable; //           extends EnergyMeleeProperty { override val toString = "Rechargeable" }
	AttackFactor(n: Int); //   extends EnergyMeleeProperty { override val toString = s"$n Attack Factor" }
	BeamShield(b: Bool); // extends EnergyMeleeProperty { override val toString = if (b) "Variable " else "" + "Beam Shield" }

	/** Melee properties **/
	Clumsy; //    extends MeleeProperty { override val toString = "Clumsy" }
	Entangle; //  extends MeleeProperty { override val toString = "Entangle" }
	Handy; //     extends MeleeProperty { override val toString = "Handy" }
	Returning; // extends MeleeProperty { override val toString = "Returning" }

	/** Missile properties **/
	Flare; //                      extends MissileProperty { override val toString = "Flare" }
	Fuse; //                       extends MissileProperty { override val toString = "Fuse" }
	Scatter; //                    extends MissileProperty { override val toString = "Scatter" }
	Smoke; //                      extends MissileProperty { override val toString = "Smoke" }
	Countermissile(b: Bool); // extends MissileProperty { override val toString = if (b) "Variable " else "" + "Countermissile" }
	Skill(n: Int); //              extends MissileProperty { override val toString = s"$n Skill" }
	Smart(n: Int); //              extends MissileProperty { override val toString = s"$n Smart" }

	/** Projectile properties **/
	MultiFeed(n: Int); //               extends ProjectileProperty { override lazy val toString = s"$n Multi-Feed" }
	Phalanx(value: Bool); //         extends ProjectileProperty { override lazy val toString = if (value) "Variable " else "" + "Phalanx" }
	Ammo(system_list: List<MekSys>); // extends ProjectileProperty { override lazy val toString = "Ammo" + system_list.map("\n    " + _.toInternal).mkString }

	/** Energy Pool properties **/
	Morphable; //     extends EnergyPoolProperty { override val toString = "Morphable" }

	/** Shield properties **/
	BinderSpace(n: Int,d: Int); // extends ShieldProperty { override val toString = s"-$n/$d Binder Space" }
	Reset(n: Int); //              extends ShieldProperty { override val toString = s"$n Reset" }
	DefenseAbility(n: Int); //     extends ShieldProperty { override val toString = s"$n Defense Ability" }

	/** Shield Weakness properties **/
	Interference; //  extends WeaknessProperty { override val toString = "Interference" }
	Kinetic; //       extends WeaknessProperty { override val toString = "Kinetic" }
	Mirror; //        extends WeaknessProperty { override val toString = "Mirror" }
	Screen; //        extends WeaknessProperty { override val toString = "Screen" }
	Surge; //         extends WeaknessProperty { override val toString = "Surge" }
	Swashbuckling; // extends WeaknessProperty { override val toString = "Swashbuckling" }

	/** Ammo Type properties **/
	HighEx; //      extends AmmoTypeProperty { override val toString = "High-Explosive" }
	Incendiary; //  extends AmmoTypeProperty { override val toString = "Incendiary" }
	Paintball; //   extends AmmoTypeProperty { override val toString = "Paintball" }
	Scattershot; // extends AmmoTypeProperty { override val toString = "Scattershot" }
	Tangler; //     extends AmmoTypeProperty { override val toString = "Tangler" }
	Tracer; //      extends AmmoTypeProperty { override val toString = "Tracer" }

	/** Multi-System properties **/
	Accuracy(n: Int); //          extends BeamProperty with EnergyMeleeProperty with MeleeProperty with MissileProperty with ProjectileProperty { override val toString = n + " Accuracy" }
	Disruptor; //                 extends BeamProperty with MeleeProperty with AmmoTypeProperty { override val toString = "Disruptor" }
	LongRange; //                 extends BeamProperty with MissileProperty with ProjectileProperty { override val toString = "Long Range" }
	Range(n: Int); //             extends BeamProperty with MissileProperty with ProjectileProperty { override val toString = n + " Range" }
	AllPurpose; //                extends BeamProperty with ProjectileProperty { override val toString = "All-Purpose" }
	AntiPersonnel(b: Bool); // extends BeamProperty with ProjectileProperty { override val toString = if (b) "Variable " else "" + "Anti-Personnel" }
	BurstValue(n: Int); //        extends BeamProperty with ProjectileProperty { override val toString = s"$n Burst Value" }
	Quick; //                     extends EnergyMeleeProperty with MeleeProperty { override val toString = "Quick" }
	Thrown; //                    extends EnergyMeleeProperty with MeleeProperty { override val toString = "Thrown" }
	TurnsInUse(n: Int); //        extends EnergyMeleeProperty with ShieldProperty { override val toString = n + " Turns in Use" }
	ArmorPiercing; //             extends MeleeProperty with MissileProperty with AmmoTypeProperty { override val toString = "Armor-Piercing" }
	Shock(b: Bool); //         extends MeleeProperty with AmmoTypeProperty { override val toString = "Shock" + (if (b) " Only" else " Added") }
	Hypervelocity; //             extends MissileProperty with ProjectileProperty { override val toString = "Hypervelocity" }
	Foam; //                      extends AmmoTypeProperty with MissileProperty { override val toString = "Foam" }
	Nuclear; //                   extends AmmoTypeProperty with MissileProperty { override val toString = "Nuclear" }
	Blast(n: Int); //             extends AmmoTypeProperty with MissileProperty { override val toString = "Blast " + n }

	/** Misc. System properties **/
	WireControlled; //         extends Property { override val toString = "Wire-Controlled" }
	Beaming(n: Int); //        extends Property { override val toString = n + " Beaming" }
	CommRange(n: Int); //      extends Property { override val toString = n + " km Comm Range" }
	ControlRange(n: Int); //   extends Property { override val toString = n + " Control Range" }
	OperationRange(n: Int); // extends Property { override val toString = n + " Operation Range" }
	Quality(n: Int); //        extends Property { override val toString = n + " Quality" }
	Radius(n: Int); //         extends Property { override val toString = n + " Radius" }
	SensorRange(n: Int); //    extends Property { override val toString = n + "km Sensor Range" }
	StoppingPower(n: Int); //  extends Property { override val toString = n + " Stopping Power" }
	Value(n: Int); //          extends Property { override val toString = n + " Value" }
}