package dreamengine.cli.commands;

import comma.CliApp;
import comma.ParsedOptions;
import comma.OptionDefinition;

class DefaultCommand extends comma.Command{
    public function new(){
        super();
    }

    override function getName():String {
        return "help";
    }

    override function getDescription():String {
        return "Prints help message";
    }


    override function onExecuted(app:CliApp, values:Array<String>, options:ParsedOptions) {
        app.printHelp();
    }
}
