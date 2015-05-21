interface AST {
	function base(): Float;
	function cost(): Float;
	function space(): Float;
	function kills(): Int;
	function details(s: String, n: Int): String;
}

class MekSys implements AST {
	function details(s: String, n: Int = 0)
		return '%-${comment_offset-n}s = (cost : %6.2f | space : %6.2f | kills : %3d)'.format(s,cost,space,kills);
}