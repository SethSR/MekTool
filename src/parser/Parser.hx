package parser;

interface IParser<In, Out> {
	function parse(pin: ParserInput<In>): ParseResult<In, Out>;
}

class Parser<In, Out> implements IParser<In, Out> {
	function parse(pin: ParserInput<In>): ParseResult<In, Out> {
		return Failure;
	}

	function andPair<Out2>(other: Parser<In, Out2>): Parser<In, Pair<Out, Out2>> {
		return new Parser<In, Pair<Out, Out2>>() {
			function parse(pin: ParserInput<In>): ParseResult<In, Pair<Out, Out2>> {
				var firstStep = this.parse(pin);
				switch (firstStep) {
					case Success(firstResult, firstRest):
						var secondStep = other.parse(firstRest);
						switch (secondStep) {
							case Success(secondResult, secondRest):
								return Success(
									new Pair<Out, Out2>(
										firstResult,
										secondResult),
									secondRest);
							case Failure:
								return Failure;
						}
					case Failure:
						return Failure;
				}
			}
		};
	}
	// ParserInput<Parser.In> -> ParseResult<Parser.In, Pair<Parser.Out, andPair.Out2>>
	//                           Parser     <Parser.In, Pair<Parser.Out, andPair.Out2>>

	function andFirst<Out2>(other: Parser<In, Out2>): Parser<In, Out> {
		var firstParser: Parser<In, Out> = {
			function parse(pin: ParserInput<In>) {
				var firstStep = this.parse(pin);
				if (firstStep == Failure) {
					return firstStep;
				}
				var firstResult = cast (firstStep, Success<In, Out>).getResult();
				var secondStep = other.parse(firstStep.getRest());
				if (secondStep == Failure) {
					return new Failure<In, Out>();
				}
				return new Success<In, Out>(firstResult, secondStep.getRest());
			}
		};
		return firstParser;
	}

	function andSecond<Out2>(other: Parser<In, Out2>): Parser<In, Out2> {
		var secondParser: Parser<In, Out2> = {
			function parse(pin: ParserInput<In>) {
				var firstStep = this.parse(pin);
				if (firstStep == Failure) {
					return new Failure<In, Out2>();
				}
				var secondStep = other.parse(firstStep.getRest());
				if (secondStep == Failure) {
					return secondStep;
				}
				return secondStep;
			}
		};
		return secondParser;
	}

	function or(other: Parser<In, Out>): Parser<In, Out> {
		return new ChoiceParser<In, Out>(this, other);
	}

	function seq<In, Out>(first: Parser<In, Out>): SeqParser<In, Out> {
		return new SeqParser<In, Out>(first);
	}

	function many(atleast: Int): Parser<In, List<Out>> {
		return new ManyParser<In, Out>(this, atleast);
	}

	function opt(nullVal: Out): Parser<In, Out> {
		return new OptParser<In, Out>(this, nullVal);
	}

	function ref<In, Out>(): RefParser<In, Out> {
		return new RefParser<In, Out>();
	}

	function action<X>(trans: Action<Out, X>): Parser<In, X> {
		return new Transform<In, Out, X>(this, trans);
	}

	function match<In>(i: In): Parser<In, In> {
		var parser: Parser<In, In> = {
			function parse(pin: ParserInput<In>): ParseResult<In, In> {
				if (pin.first() == i) {
					return new Success<In, In>(i, pin.rest());
				} else {
					return new Failure<In, In>();
				}
			}
		};
		return parser;
	}

	var space: Parser<String, String> = new CharSetParser(" \t\n").many(0).action(new Action<List<String>, String>() = {
		function run(ain: List<String>): String {
			return ' ';
		}
	});

	function charSet(chars: String): Parser<String, String> {
		return space.andSecond(new CharSetParser(chars));
	}

	function end<In, X>(v: X): Parser<In, X> {
		return new Parser<In, X>() = {
			function parse(pin: ParserInput<In>): ParseResult<In, X> {
				if (pin.atEnd()) {
					return new Success<In, X>(v, pin);
				} else {
					return new Failure<In, X>();
				}
			}
		};
	}
}

// class Parser<In,Out> implements IParser<In,Out> {
// 	public function parse(pin: ParserInput<In>): ParseResult<In,Out>;
// }