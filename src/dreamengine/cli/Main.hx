package dreamengine.cli;
import dreamengine.cli.commands.*;
import comma.*;

class Main{
    static function main(){
        var app = new CliApp("dreamengine-cli", "0.1.0");
        app.addCommand(new DefaultCommand());
        app.addCommand(new NewCommand());
        app.addCommand(new InitCommand());
        app.addCommand(new SetupCommand());
        app.start();
    }
}