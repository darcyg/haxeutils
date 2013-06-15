package utils;

import haxe.io.Path;
import haxe.Json;
import haxe.xml.Fast;
import mcli.CommandLine;
import mcli.Dispatch;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author Darcy.G
 */
class UtilsCommands
{

	public static function main()
	{
        Dispatch.addDecoder(new UtilsCommandsDecoder());
		new Dispatch(Sys.args()).dispatch(new UtilsCommandsMain());
	}
}


//this will demonstrate how to add a custom type to be decoded
class UtilsCommanding
{
	public var str:String;

	public function new(str)
	{
		this.str = str;
	}
}

class UtilsCommandsDecoder
{
	public function new()
	{

	}

	public function fromString(s:String):UtilsCommanding
	{
		return new UtilsCommanding(s + ".");
	}
} 
 
class UtilsCommandsMain extends CommandLine
{
    
    /**
		TileLayer Xml file To Json file
	**/
	public function xml2json(d:Dispatch)
	{
		//re-dispatch here
		//trace("git add called");
		d.dispatch(new Xml2Json());
		//trace("HERE");
	}
}

class HaxeUtilsCommand extends CommandLine
{
	/**
		be verbose
		@alias v
	**/
	public var verbose:Bool;

	/**
		print this message
		@command
		@alias h
	**/
	public function help()
	{
        //Sys.println(this.showUsage());
		Sys.println(this.toString());
	}
}

class Xml2Json extends HaxeUtilsCommand
{
	///**
	//	use value for given property
//
	//	@key    property
	//	@value  value
	//**/
	//public var D:Map<String,String> = new Map();
	
    /**
		input xml file
        @alias i
	**/    
    public var inputfile:String = "";

    
    private function xml2json():Void {
       		//trace("running default with " + arg1 + " " + arg2 + " " + varArgs);
        //Sys.println(this.showUsage());
        var xmlfile = inputfile;
        if (StringTools.trim(xmlfile) != "") {
            //File.
            if (FileSystem.exists(xmlfile)) {
                var data = File.getContent(xmlfile);
                var jFile = Path.withoutExtension(xmlfile) + ".json";                
                try {
                    var x:Fast = new Fast( Xml.parse(data).firstElement() );
                    var j = {"type": { "id":"tilesheet", "api":"1" }, "items":{}};
                    var items:Array<Dynamic> = [];

                    for (texture in x.nodes.SubTexture)
                    {
                        if (texture.has.frameX){
                            var item = { 
                                "name":         texture.att.name,
                                "x":            Std.parseFloat(texture.att.x),
                                "y":            Std.parseFloat(texture.att.y),
                                "width":        Std.parseFloat(texture.att.width),
                                "height":       Std.parseFloat(texture.att.height),
                                "frameX":       Std.parseInt(texture.att.frameX),
                                "frameY":       Std.parseInt(texture.att.frameY),
                                "frameWidth":   Std.parseInt(texture.att.frameWidth),
                                "frameHeight":  Std.parseInt(texture.att.frameHeight)
                            };
                            items.push(item);
                        }else {
                            var item = { 
                                "name":         texture.att.name,
                                "x":            Std.parseFloat(texture.att.x),
                                "y":            Std.parseFloat(texture.att.y),
                                "width":        Std.parseFloat(texture.att.width),
                                "height":       Std.parseFloat(texture.att.height)
                            };
                            items.push(item);
                        }
                    }
                    j.items = items;

                    //trace(j);
                    var jData = Json.stringify(j);
                    File.saveContent(jFile, jData);
                    Sys.println("write file: [ " + jFile + " ] ok!");                   
                } catch (e:Dynamic) {
                    Sys.println("input file error!");
                }
            }
        } else {
            Sys.println("xml2json useage help:\n ");
            help();
        }
        
    }
        
    
    public function runDefault()
	{
        this.xml2json();
	}
}
 
//class UtilsCommandsMain extends CommandLine
//{
//	/**
//		a xml tilelayer file convert to json tilelayer file
//        @alias j
//	**/
//    public function xml2json(?xmlfile:String="")
	//{
//
	//}
	//public function runDefault()
	//{
//
	//}
	///**
		//shows this message
		//@alias h
	//**/
	//public function help()
	//{
        //Sys.println("haxeutils useage help:\n  haxeutils [commands] [options]\n");
		//Sys.println(this.showUsage());
	//}    
//}