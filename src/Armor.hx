enum ArmorClass {
	Ablative;
	Standard;
	Alpha;
	Beta;
	Gamma;
}

enum Armor {
	StandardArmor(size_class: SizeClass, armor_class: Option<ArmorClass>);
	RAMArmor(size_class: SizeClass, armor_class: Option<ArmorClass>, ram_value: Int);
}