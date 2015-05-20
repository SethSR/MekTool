package parser;

enum ParseResult<In, Out> {
	Success(result: Out, rest: ParserInput<In>);
	Failure();
}