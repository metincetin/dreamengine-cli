package dreamengine.cli.commands;

import haxe.io.Path;
import sys.io.File;
import comma.*;

class SetupCommand extends comma.Command {
	override function getName() {
		return "setup";
	}

	override function getDescription() {
		return "Sets up dreamengine in path";
	}

	override function onExecuted(app:CliApp, values:Array<String>, options:ParsedOptions) {
       app.println("Setting up dreamengine in path"); 


	   var path = "/usr/local/bin/";
	   File.saveContent(Path.join([path, "dreamengine"]), "#!/bin/sh\nhaxelib run dreamengine \"$@\"");
    }
}
