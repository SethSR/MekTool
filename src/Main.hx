import snow.api.Debug.*;
import snow.types.Types;

class Main extends snow.App {
    override function config(config: AppConfig) {
        config.window.title = 'MekTool - Mekton Zeta';
        return config;
    } //config

    override function ready() {
    	MekParser.test();
    } //ready
} //Main