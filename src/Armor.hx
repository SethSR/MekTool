enum ArmorClass {
	Ablative;
	Standard;
	Alpha;
	Beta;
	Gamma;
}

enum Armor {
	StandardArmor(sizeClass: SizeClass, armorClass: ArmorClass);
	RAMArmor     (sizeClass: SizeClass, armorClass: ArmorClass, ramValue1: Int, ramValue2: Int);
}