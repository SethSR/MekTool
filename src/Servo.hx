enum Servo {
	Torso(sizeClass: SizeClass, armor: Armor, systemList: Array<MekSys>);
	Head (sizeClass: SizeClass, armor: Armor, systemList: Array<MekSys>);
	Arm  (sizeClass: SizeClass, armor: Armor, systemList: Array<MekSys>);
	Leg  (sizeClass: SizeClass, armor: Armor, systemList: Array<MekSys>);
	Wing (sizeClass: SizeClass, armor: Armor, systemList: Array<MekSys>);
	Tail (sizeClass: SizeClass, armor: Armor, systemList: Array<MekSys>);
	Pod  (sizeClass: SizeClass, armor: Armor, systemList: Array<MekSys>);
}