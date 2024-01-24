package dreamengine.cli.commands;

import sys.FileSystem;
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
		switch (Sys.systemName()) {
			case "Linux" | "Mac":
				app.println(Style.color("CLI will request root permission to move executable script to your path.", Yellow));
				var scriptPath = Path.join([Sys.programPath(), "../../../../", 'scripts/dreamengine.sh']);
				Sys.command('sudo cp ${scriptPath} /usr/local/bin/dreamengine');
				Sys.command('sudo chmod +x /usr/local/bin/dreamengine');

				app.println("dreamengine is set in path");
			case "Windows":
				app.println(Style.color("CLI will request administrator permission to move executable script to your path.", Yellow));
				var installPath = Path.join(["C:", "/Program Files/dreamengine/"]);


				var scriptsPath = Path.join([Sys.programPath(), "../../../../scripts"]);
				var setupScriptPath = Path.join([scriptsPath, 'setup_windows.bat']);

				Sys.command('powershell -Command "Start-Process -Verb RunAs -FilePath \'${setupScriptPath}\' -WorkingDirectory \'${scriptsPath}\' -ArgumentList \'${scriptsPath}\'');
				app.println("dreamengine is set in path");
		}
	}
}
