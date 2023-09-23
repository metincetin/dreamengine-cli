package dreamengine.cli.commands;

import haxegen.Function.FunctionParameter;
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

		var packageName = gameName.toLowerCase();

		FileSystem.createDirectory(Path.join([path, "src"]));
		FileSystem.createDirectory(Path.join([path, "src", packageName]));
		FileSystem.createDirectory(Path.join([path, "Libraries"]));
		FileSystem.createDirectory(Path.join([path, "Assets"]));
		FileSystem.createDirectory(Path.join([path, "Shaders"]));

		createProjectConfig(gameName, path);

		createKhaFile(gameName, path);

		createMainClass(packageName, Path.join([path, "src"]));
		createGameClass(packageName, Path.join([path, "src", packageName]));

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

	static function createGameClass(packageName:String, path:String) {
		var file = new haxegen.SourceFile({
			name: "GamePlugin",
			imports: ["dreamengine.core.*","dreamengine.core.Plugin.IPlugin"],
			packageName: packageName,
			classes: [
				new haxegen.Class({
					name: "GamePlugin",
					inheritedClass: new haxegen.Class({name: "Game"}),
					functions: [
						new haxegen.Function({
							name: "beginGame",
							functionBody: '
// Called when game starts and all plugins loaded. You can access the engine via "engine" variable

// register tick (update) event
engine.registerLoopEvent(onTick);
							',

							accessModifier: Private,
							isOverride: true
						}),
						new haxegen.Function({
							name: "onTick",
							functionBody: '// Called every frame',
							accessModifier: Private
						}),
						new haxegen.Function({
							name: "endGame",
							functionBody: '
// Called when game is finalized

// unregister loop event
engine.unregisterLoopEvent(onTick);
							',

							accessModifier: Private,
							isOverride: true
						}),
						new haxegen.Function({
							name: "getDependentPlugins",
							functionBody: '
// You can specify what plugins this game plugin needs in order to work.
// e.g. to use Renderer3D, DreamUI and input. use: return [Renderer3D, DreamUIPlugin, InputPlugin];
return [];
							',
							accessModifier: Private,
							isOverride: true,
							returnType: "Array<Class<IPlugin>>"
						}),

						new haxegen.Function({
							name: "handleDependency",
							functionParameters: [new FunctionParameter("ofType", "Class<IPlugin>")],
							functionBody: '
// This is where you "create" the dependencies. Each plugin you passed on getDependentPlugins, should be instantiated in here
// for example:
/*
switch(ofType){
	case Renderer3D:
		return new Renderer3D();
	case InputPlugin:
		return new InputPlugin();
}
*/
return null;
							',
							accessModifier: Private,
							isOverride: true,
							returnType: "IPlugin"
						}),
					]
				})
			]
		});

		var filePath = Path.join([path, file.getFileName()]);

		File.saveContent(filePath, file.generate());
	}

	static function createMainClass(packageName: String, path:String) {
		var mainFile = new haxegen.SourceFile({
			name: "Main",
			imports: ['${packageName}.GamePlugin', "dreamengine.core.Engine", "kha.System"],
			classes: [
				new haxegen.Class({
					name: "Main",
					functions: [
						new haxegen.Function({
							name: "main",
							accessModifier: Public,
							isStatic: true,
							functionBody: '
Engine.start(function(engine){
	kha.Assets.loadEverything(function(){
		var game = new GamePlugin();
		engine.pluginContainer.addPlugin(game);
	});
});
							'
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
