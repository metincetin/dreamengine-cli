package dreamengine.cli;
import dreamengine.cli.commands.*;
import comma.*;

class Main{
    static function main(){
        var app = new CliApp("dreamengine-cli", "0.2.0");
        app.addCommand(new DefaultCommand());
        app.addCommand(new NewCommand());
        app.addCommand(new InitCommand());
        app.addCommand(new SetupCommand());
        app.addCommand(new InstallCommand());
        app.addCommand(new RunCommand());
        app.start();
    }
}