import sys.io.File;

class Main {
    static public function main() {
    	// var test = new haxe.unit.TestRunner();
    	// test.add(new MekParser.MekTest());
    	// test.run();
    	MekParser.test([for (str in Sys.args()) File.getContent(str)].join('\n'));
    }
} //Main