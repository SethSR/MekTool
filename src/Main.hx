import snow.api.Debug.*;
import snow.types.Types;

class Main extends snow.App {
    override function config(config: AppConfig) {
        config.window.title = 'my_app - a guide example';
        return config;
    } //config

    override function ready() {
        var char_set_parser = new parser.CharSetParser('c');
    } //ready
} //Main