package parser;

class ChoiceParser<In,Out> implements Parser<In,Out> {
	var _choices: List<Parser<In,Out>>;

	function new() {
		_choices = new List<Parser<In,Out>>();
	}

	public function new(first: Parser<In,Out>, second: Parser<In,Out>) {
		this();
		_choices.add(first);
		_choices.add(second);
	}

	public function new(choices: List<Parser<In,Out>>) {
		_choices = choices;
	}

	public function parse(pin: ParserInput<In>): ParseResult<In,Out> {
		for (parser in _choices) {
			var result = parser;
		}
	}
}