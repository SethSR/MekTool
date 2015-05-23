@:enum
abstract SizeClass(Int) from Int to Int {
	var Superlight    =  0;
	var Lightweight   =  1;
	var Striker       =  2;
	var MediumStriker =  3;
	var HeavyStriker  =  4;
	var Mediumweight  =  5;
	var LightHeavy    =  6;
	var MediumHeavy   =  7;
	var ArmoredHeavy  =  8;
	var SuperHeavy    =  9;
	var MegaHeavy     = 10;

	@:op(A + B)
	public function add(i: Int) {
		return this + i;
	}

	@:op(A + B)
	static public function add2(i: Int, s: SizeClass) {
		return s.add(i);
	}
}