package dreamengine.cli;

import haxe.io.Eof;
import sys.io.Process;

class Utils{
    public static function createDreamProject(gameName:String){
        return {
            "gameName":gameName
        };
    }

}