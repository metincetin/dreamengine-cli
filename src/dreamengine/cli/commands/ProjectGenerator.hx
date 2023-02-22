package dreamengine.cli.commands;

import comma.*;
import haxe.io.Eof;
import sys.io.Process;
import sys.FileSystem;
import haxe.Json;
import sys.io.File;
import haxe.io.Path;

class ProjectGenerator {
	public static function generateProject(app:CliApp, gameName:String, path:String) {
		if (!FileSystem.exists(path)) {
			FileSystem.createDirectory(path);
		}
		var c = Sys.getCwd();

		Sys.setCwd(path);

		FileSystem.createDirectory(Path.join([path, "src"]));
		FileSystem.createDirectory(Path.join([path, "Libraries"]));
		FileSystem.createDirectory(Path.join([path, "Assets"]));
		FileSystem.createDirectory(Path.join([path, "Shaders"]));

		createProjectConfig(gameName, path);
		
		createKhaFile(gameName, path);
		
		createMainClass(Path.join([path, "src"]));
		
		Sys.setCwd(c);
	}


	static function createKhaFile(gameName:String, path:String) {
		var khafilePath = Path.join([path, "khafile.js"]);
		var content = "";

		content += 'let project = new Project("${gameName}");\n';
		content += 'project.addAssets("Assets/**");\n';
		content += 'project.addShaders("Shaders/**");\n';
		content += 'project.addSources("src");\n';
		content += 'await project.addProject("Libraries/dreamengine")\n';
		content += 'resolve(project);';

		File.saveContent(khafilePath, content);
	}

	static function createMainClass(path:String) {
		var mainFile = new haxegen.SourceFile({
			name: "Main",
			imports: ["dreamengine.core.Engine", "kha.System"],
			classes: [
				new haxegen.Class({
					name: "Main",
					functions: [
						new haxegen.Function({
							name: "main",
							accessModifier: Public,
							isStatic: true
						})
					]
				})
			]
		});

		var filePath = Path.join([path, mainFile.getFileName()]);
		
		File.saveContent(filePath, mainFile.generate());
	}

	public static function installEngineDependencies(app:CliApp) {
		
		app.println(Style.color("Installing dependencies", Green));
		
		var c = Sys.getCwd();
		var librariesPath = Path.join([c, "Libraries"]);
		if (!FileSystem.exists(librariesPath))
			FileSystem.createDirectory(librariesPath);

		Sys.setCwd(Path.join([c, "Libraries"]));

		app.println("Installing dreamengine");
		Sys.command("git clone https://github.com/metincetin/dreamengine");

		Sys.setCwd(c);

		app.println("Installing Kha");
		Sys.command("git clone https://github.com/Kode/Kha");

		app.println("Setting up Kha");
		Sys.command(Path.join([Sys.getCwd(), "Kha/get_dlc"]));

		app.println(Style.color("Done", Green));
	}

	static function createProjectConfig(gameName:String, path:String) {
		var content = Json.stringify(Utils.createDreamProject(gameName));
		var configPath = Path.join([path, "dreamgame.json"]);
		File.saveContent(configPath, content);
	}
}
