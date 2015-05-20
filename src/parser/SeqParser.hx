package parser;

class SeqParser<In, Out> extends Parser<In, List<Out>> {
	var _parsers: List<Parser<In, Out>>;

	function new(parsers: List<Parser<In, Out>>) {
		_parsers = parsers;
	}

	function andThen(next: Parser<In, Out>): SeqParser<In, Out> {
		var parsers = new List<Parser<In, Out>>();
		for (p in _parsers) {
			parsers.add(p);
		}
		parsers.add(next);
		return new SeqParser<In, Out>(parsers);
	}

	function parse(pin: ParserInput<In>): ParseResult<In, List<Out>> {
		var result_vals = new List<Out>();
		for (p in _parsers) {
			var out = p.parse(pin);
			switch (out) {
				case Success(result,rest):
					result_vals.add(result);
					pin = rest;
				case Failure:
					return Failure;
			}
		}
		return Success(result_vals, pin);
	}
}