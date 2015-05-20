package parser;

class Pair<X, Y> {
	var _x: X;
	var _y: Y;

	public function new(x: X, y: Y) {
		_x = x;
		_y = y;
	}

	public function getFirst() { return _x; }
	public function getSecond() { return _y; }
}