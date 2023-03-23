package dreamengine.cli;
import dreamengine.cli.commands.*;
import comma.*;

class Main{
    static function main(){
        var app = new CliApp("dreamengine-cli", "0.1.4");
        app.addCommand(new DefaultCommand());
        app.addCommand(new NewCommand());
        app.addCommand(new InitCommand());
        app.addCommand(new SetupCommand());
        app.addCommand(new InstallCommand());
        app.start();
    }
}