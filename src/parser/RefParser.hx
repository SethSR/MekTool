package parser;

class RefParser<In, Out> extends Parser<In, Out> {
	var _ref: Parser<In, Out>;

	function new() {
		_ref = null;
	}

	function parse(pin: ParserInput<In>): ParseResult<In, Out> {
		if (_ref == null) {
			return Failure;
		} else {
			return _ref.parse(pin);
		}
	}

	function setRef(p: Parser<In, Out>) {
		_ref = p;
	}
}