package parser;

interface ParserInput<In> {
	function first(): In;

	function rest(): ParserInput<In>;

	function atEnd(): Bool;
}