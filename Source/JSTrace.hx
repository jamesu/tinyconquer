
class JSTrace {

    public static function setRedirection() {
        haxe.Log.trace = myTrace;
    }

    private static function myTrace( v : Dynamic, ?inf : haxe.PosInfos ) {
        // .....
        var d : Dynamic;
        d = js.Lib.window;
        d.console.log(v, inf);
    }

}