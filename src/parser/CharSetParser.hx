package parser;

class CharSetParser extends Parser<String,String> {
	var _chars: String;

	public function new(chars: String) {
		_chars = chars;
	}

	public function parse(pin: ParserInput<String>): ParseResult<String, String> {
		if (_chars.indexOf(pin.first()) == -1) {
			return Failure;
		} else {
			return Success(pin.first(), pin.rest());
		}
	}
}