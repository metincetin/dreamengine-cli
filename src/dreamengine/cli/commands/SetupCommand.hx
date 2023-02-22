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
		switch(Sys.systemName()){
			case "Linux":
				var pr = new sys.io.Process(Path.join([Sys.getCwd(), 'scripts/setup.sh']));
				var code = pr.exitCode();
				if (code != 0){
					app.println('Error: ${code} - ${pr.stdout.readAll().toString()}');
				}else{
					app.println("Set up dreamengine in path");
				}
				pr.close();
			case "Mac":
			case "Windows":
		}
	}
}
