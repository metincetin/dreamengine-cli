package dreamengine.cli.commands;

import comma.*;

class RunCommand extends Command{
    public function new(){
        super();
        addOptionDefinition(new OptionDefinition("target", "t"));
        addOptionDefinition(new OptionDefinition("debug", "d"));
        addOptionDefinition(new OptionDefinition("atelier"));
    }
    override function getName():String {
        return "run";
    }
    override function getDescription():String {
        return "Compile/Run dream game";
    }
    override function onExecuted(app:CliApp, value:Array<String>, options:ParsedOptions) {
        var args = "";
        var gfx = "vulkan";
        if (options.exists("graphics", "g")){
            var p = options.get("graphics", "g");
            if (p.length > 0){
                gfx = p[0];
            }
        }

        if (options.exists("target", "t"))
            args = options.get("target", "t")[0];
        if (options.exists("debug", "d"))
            args += " --debug";
        if (options.exists("atelier", ""))
            args += " --atelier";

        Sys.command('node Kha/make ${args} --run --graphics ${gfx}');
    }
}