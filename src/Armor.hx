enum ArmorClass {
	Ablative;
	Standard;
	Alpha;
	Beta;
	Gamma;
}

enum ArmorType {
	StandardArmor;
	RAMArmor;
}

class Armor {
	var armorType: ArmorType;
	var sizeClass: SizeClass;
	var armorClass: ArmorClass;
	var ramValue1: Int = 0;
	var ramValue2: Int = 0;
	var cost: Float;
	var stoppingPower: Float;
	var damageCoefficient: Float;
	public function new(at: ArmorType, sc: SizeClass, ac: ArmorClass, r1: Int = 0, r2: Int = 0) {
		armorType = at;
		sizeClass = sc;
		armorClass = ac;
		ramValue1 = r1;
		ramValue2 = r2;

		var armor_cost_mod = switch (ac) {
			case Ablative: 0.50;
			case Standard: 1.00;
			case Alpha   : 1.25;
			case Beta    : 1.50;
			case Gamma   : 2.00;
		}

		cost = (1 + sizeClass) * armor_cost_mod * switch (r2) {
			case 5: 1.5;
			case 4: 1.8;
			case 3: 2.2;
			case 2: 2.5;
			case _: 1.0;
		}

		stoppingPower = (1 + sizeClass) * switch (r2) {
			case 5: 1.00;
			case 4: 0.80;
			case 3: 0.75;
			case 2: 0.67;
			case _: 1.00;
		}

		damageCoefficient = switch (ac) {
			case Ablative: 0;
			case Standard: 1;
			case Alpha   : 2;
			case Beta    : 4;
			case Gamma   : 8;
		}
	}

  // var toString =
  //   details('$sizeClass $armorClass $armorType' +
  //   (if (armor_type == RAMArmor) ' $ramValue1/$ramValue2' else ''), 4);

  // function details(s: String, n: Int = 0) return '%-${39-n}s = (cost : %6.2f | SP    : %6.2f | DC    : %3d)'.format(s,cost,stoppingPower,damageCoefficient);
}