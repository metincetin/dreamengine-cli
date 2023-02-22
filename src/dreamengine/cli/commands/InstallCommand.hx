package dreamengine.cli.commands;

import comma.CliApp;
import comma.ParsedOptions;
import comma.Command;

class InstallCommand extends Command{
    override function getName():String {
        return "install";
    }
    
    override function getDescription():String {
        return "Installs engine dependencies (Kha and dreamengine) in current dream project folder";
    }

    override function onExecuted(app:CliApp, value:Array<String>, options:ParsedOptions) {
        ProjectGenerator.installEngineDependencies(app);       
    }
}