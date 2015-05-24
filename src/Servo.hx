enum Servo {
	Torso(sizeClass: SizeClass, armor: Armor, systemList: List<MekSys>);
	Head (sizeClass: SizeClass, armor: Armor, systemList: List<MekSys>);
	Arm  (sizeClass: SizeClass, armor: Armor, systemList: List<MekSys>);
	Leg  (sizeClass: SizeClass, armor: Armor, systemList: List<MekSys>);
	Wing (sizeClass: SizeClass, armor: Armor, systemList: List<MekSys>);
	Tail (sizeClass: SizeClass, armor: Armor, systemList: List<MekSys>);
	Pod  (sizeClass: SizeClass, armor: Armor, systemList: List<MekSys>);
}

enum ServoType {
	Torso;
	Head;
	Arm;
	Leg;
	Tail;
	Wing;
	Pod;
}