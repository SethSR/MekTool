typedef Variable = {
	name: String,
	resolved: Bool,
}

typedef Mekton = {
	name: String,
	servos: Array<Servo>,
}

typedef Servo = {
	sizeClass: SizeClass,
	armor: Armor,
	systems: Array<Variable>,
}