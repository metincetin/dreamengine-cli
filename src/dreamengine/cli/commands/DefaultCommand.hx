package dreamengine.cli.commands;

import comma.CliApp;
import comma.ParsedOptions;
import comma.OptionDefinition;

class DefaultCommand extends comma.Command{
    public function new(){
        super();
        addOptionDefinition(new OptionDefinition("help","h","Prints help message"));
    }

    override function onExecuted(app:CliApp, values:Array<String>, options:ParsedOptions) {
        app.printHelp();
    }
}
