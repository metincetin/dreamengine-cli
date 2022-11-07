package dreamengine.cli.commands;

import comma.*;
import haxe.io.Eof;
import sys.io.Process;
import sys.FileSystem;
import haxe.Json;
import sys.io.File;
import haxe.io.Path;
import haxegen.*

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

		installEngineDependencies(app);

		Sys.setCwd(c);
	}

	static function createKhaFile(gameName:String, path:String) {
		var khafilePath = Path.join([path, "khafile.js"]);
		var content = "";

		content += 'let project = new Project("${gameName}");\n';
		content += 'project.addAssets("Assets/**");\n';
		content += 'project.addAssets("Libraries/dreamengine/assets/**");\n';
		content += 'project.addShaders("Shaders/**");\n';
		content += 'project.addSources("src");\n';
		content += 'resolve(project);';

		File.saveContent(khafilePath, content);
	}

	static function createMainClass(path:String){
		var class = new Class();
	}

	public static function installEngineDependencies(app:CliApp) {
		app.println(Style.color("Installing dependencies", Green));

		var c = Sys.getCwd();

		Sys.setCwd(Path.join([c, "Libraries"]));

		app.println("Installing dreamengine");
		Sys.command("git clone https://github.com/metincetin/dreamengine");

		Sys.setCwd(c);

		app.println("Installing Kha");
		Sys.command("git clone https://github.com/Kode/Kha");

		app.println("Setting up Kha");
        Sys.command(Path.join([Sys.getCwd(),"kha/get_dlc"]));



		app.println(Style.color("Done", Green));
	}

	static function setupKha(app:CliApp) {
		app.println("Setting up Kha");
	}

	static function createProjectConfig(gameName:String, path:String) {
		var content = Json.stringify(Utils.createDreamProject(gameName));
		var configPath = Path.join([path, "dreamgame.json"]);
		File.saveContent(configPath, content);
	}
}
