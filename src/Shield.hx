enum ShieldType {
	StandardShield; // extends ShieldType { override val toString = "Standard" }
	ActiveShield;   // extends ShieldType { override val toString = "Active" }
	ReactiveShield; // extends ShieldType { override val toString = "Reactive" }
}

class Shield {
	var shieldType: ShieldType;
	var name: String;
	var armorClass: ArmorClass;
	var sizeClass: SizeClass;
	var properties: List[Property] = Nil;

	var base = 5.0 + size_class.value
	var cost = base * (if (!property_list.isEmpty) property_list.map {
	case DefenseAbilityProperty(n)  => n match {
		case -4 => 0.60
		case -3 => 0.80
		case -2 => 1.00
		case -1 => 1.25
		case  0 => 1.50
	}
	case BinderSpaceProperty(n,d) => (n,d) match {
		case (_,4) => 1.1
		case (_,3) => 1.2
		case (_,2) => 1.3
	}
	case ResetProperty(n) => n match {
		case -1 => 0.50
		case  3 => 0.75
		case  2 => 1.00
		case  1 => 1.50
		case  0 => 2.00
	}
	case TurnsInUseProperty(n) => n match {
		case  1 => 0.3
		case  2 => 0.4
		case  3 => 0.5
		case  4 => 0.6
		case  5 => 0.7
		case  7 => 0.8
		case 10 => 0.9
		case  _ => 1.0
	}
	case Interference  => 0.75
	case Screen        => 1.00
	case Kinetic       => 0.75
	case Swashbuckling => 0.75
	case Mirror        => 0.50
	case Surge         => 2.50
	case _ => 1
	}.reduce(_ * _) else 1)
	lazy val stopping_power = shield_type match {
		case StandardShield =>  5.0 + size_class.value
		case ActiveShield   =>  7.5 + size_class.value * 1.5
		case ReactiveShield => 15.0 + size_class.value * 3.0
	}
	lazy val internal_space = 0.0 //TODO implement binder space stuff
	override lazy val toString =
		details(s"$shield_type $armor_class $size_class Shield : $name") +
		property_list.map("\n  " + _).mkString
}