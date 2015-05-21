import com.mindrocks.functional.Functional;

using MekParser;

enum ArmorClass {
	Ablative(cost_mod: Float, dmg_coeff: Int);
	Standard(cost_mod: Float, dmg_coeff: Int);
	Alpha   (cost_mod: Float, dmg_coeff: Int);
	Beta    (cost_mod: Float, dmg_coeff: Int);
	Gamma   (cost_mod: Float, dmg_coeff: Int);
}

enum ArmorType {
	StandardArmor;
	RAMArmor;
}

class Armor implements AST {
	var armor_type: ArmorType;
	var size_class: SizeClass;
	var armor_class: ArmorClass;
	var ram_value_1: Int = 0;
	var ram_value_2: Int = 0;
	public function new(at: ArmorType, sc: SizeClass, ac: ArmorClass, r1: Int = 0, r2: Int = 0) {
		armor_type = at;
		size_class = sc;
		armor_class = ac;
		ram_value_1 = r1;
		ram_value_2 = r2;
	}

  var cost = (1 + size_class.value) * armor_class.cost_mod * switch (ram_value_2) {
    case 5: 1.5;
    case 4: 1.8;
    case 3: 2.2;
    case 2: 2.5;
    case _: 1.0;
  }
  var stopping_power = (1 + size_class.value) * switch (ram_value_2) {
    case 5: 1.00;
    case 4: 0.80;
    case 3: 0.75;
    case 2: 0.67;
    case _: 1.00;
  }

  var damage_coefficient = armor_class.dmg_coeff;

  var toString =
    details('$size_class $armor_class $armor_type' +
    (if (armor_type == RAMArmor) ' $ram_value_1/$ram_value_2' else ''), 4);
    
  function details(s: String, n: Int = 0) return '${comment_offset-n}s = (cost : %6.2f | SP    : %6.2f | DC    : %3d)'.format(s,cost,stopping_power,damage_coefficient);
}