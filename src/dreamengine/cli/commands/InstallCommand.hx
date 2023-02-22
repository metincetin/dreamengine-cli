package dreamengine.cli.commands;

import comma.CliApp;
import comma.ParsedOptions;
import comma.Command;
import comma.Style;
import sys.FileSystem;

class InstallCommand extends Command{
    override function getName():String {
        return "install";
    }
    
    override function getDescription():String {
        return "Installs engine dependencies (Kha and dreamengine) in current dream project folder";
    }

    override function onExecuted(app:CliApp, value:Array<String>, options:ParsedOptions) {
        var dreamConfigPath = haxe.io.Path.join([Sys.getCwd(), "dreamgame.json"]);
        if (!FileSystem.exists(dreamConfigPath)){
            app.println('dreamgame.json does not exists. Use ${Style.textStyle("dreamengine new", Bold)} or ${Style.textStyle("dreamengine init", Bold)}');
            return;
        }
        ProjectGenerator.installEngineDependencies(app);       
    }
}