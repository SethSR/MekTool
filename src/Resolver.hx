typedef AST_Storage = {
	mektons: Array<AST_Mekton>,
	systems: Array<AST_MekSys>,
}

class Resolver {
	static public function resolve(ast: AST_Storage) {}
}