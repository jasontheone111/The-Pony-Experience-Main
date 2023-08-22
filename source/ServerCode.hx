import lime.app.Future;
import haxe.Http;
import haxe.http.HttpJs;

using StringTools;

class ServerCode
{
    
    static public function updatePos(name:String, x:Float, y:Float)
    {
        var ipAddress:String = "10.0.0.1";
        var port:String = "11111";
        var future = new Future(function () {
            var charName:String = name.toLowerCase(); //
            charName = charName.replace(' ', "-"); // what are you doing? removing spaces that's what this line does

            trace(charName); // compile and see

            var isCool = new Http('http://$ipAddress:$port/ponycharpositions' + '/#' + charName); // you didn't save

            isCool.setParameter('x', '$x'); 
            isCool.setParameter('y', '$y'); 
            isCool.request(true);

            var serverResponse = isCool.responseData;
            var r = ~/[|]+/g;
        
            var responseArray = r.split(serverResponse); 

            trace('x = ' + Std.parseInt(responseArray[0]) + ', y = ' + Std.parseInt(responseArray[1]));
        }, true);
    }

}