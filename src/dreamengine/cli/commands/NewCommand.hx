package dreamengine.cli.commands;

import haxe.io.Path;
import haxe.Json;
import sys.io.File;
import sys.FileSystem;
import comma.CliApp;
import comma.ParsedOptions;
import comma.ValueDefinition;
import comma.OptionDefinition;

class NewCommand extends comma.Command {
	public function new() {
		super();
		addValueDefinition(new ValueDefinition("path"));
	}

	override function getName():String {
		return "new";
	}

	override function getDescription():String {
		return "Creates new dream project inside given path";
	}

	override function onExecuted(app:CliApp, values:Array<String>, options:ParsedOptions) {
		var dirPath = Path.normalize(Path.join([Sys.getCwd(), values[0]]));
        var gameName = "";
        
        {
            var spl = dirPath.split("/");
            gameName = spl[spl.length - 1];
        }

        if (FileSystem.exists(dirPath)) {
			app.println('Path ${dirPath} already exists');
			return;
		}
        ProjectGenerator.generateProject(app, gameName,dirPath);
        app.println('Created project ${gameName}');
	}
}
