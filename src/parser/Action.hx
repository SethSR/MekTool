package parser;

interface Action<Orig, Transformed> {
	function run(val: Orig): Transformed;
}