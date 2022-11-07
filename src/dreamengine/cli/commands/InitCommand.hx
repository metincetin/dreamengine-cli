package dreamengine.cli.commands;

import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import comma.CliApp;
import comma.ParsedOptions;

class InitCommand extends comma.Command{
    override function getName():String {
        return "init";
    }
    override function getDescription():String {
        return "Initializes dream project inside current directory";
    }

    override function onExecuted(app:CliApp, values:Array<String>, options:ParsedOptions) {
        if (FileSystem.exists(Sys.getCwd()+"/dreamgame.json")){
            app.println("There is already a project in this folder (dreamgame.json already exists)");
            return;
        }

        var gameName = app.prompt("Game Name");

        var content = Utils.createDreamProject(gameName);

        File.saveContent(Sys.getCwd()+"/dreamgame.json",Json.stringify(content));
        app.println('Initialized project ${gameName}');
    }
}