package impostor;

import flixel.graphics.frames.FlxAtlasFrames;
import haxe.io.Path;
import lime.system.System;
import sys.FileSystem;

class Paths
{
	public static function getPath(path:String, ?library:String):String
    {
        return library != null ? '$library:assets/$library/$path' : 'assets/$path';
    }

	public static function file(path:String, ?library:String):String
	{
		return getPath('$path', library);
	}

	public static function json(path:String, ?library:String):String
	{
		return getPath('data/$path.json', library);
	}

	public static function image(path:String, ?library:String):String
    {
        return getPath('images/$path.png', library);
    }

	public static function sound(path:String, ?library:String):String
    {
        return getPath('sounds/$path.ogg', library);
    }

	public static function music(path:String, ?library:String):String
    {
        return getPath('music/$path.ogg', library);
    }

	public static function font(path:String, ?library:String):String
	{
		return getPath('fonts/$path', library);
	}

	public static function getFolderContents(path:String, ?library:String, extension:Bool = true):Array<String>
	{
		if (!path.endsWith("/"))
			path += "/";

		var contents:Array<String> = _getFiles(path, library);
		for (i => file in contents)
		{
			if (!extension)
			{
				file = Path.withoutExtension(file);
			}
			contents[i] = file;
		}
		return contents;
	}

	public static function parseSprite(path:String, ?library:String):FlxAtlasFrames
	{
		var imagePath:String = image(path);
		var noExtension:String = Path.withoutExtension(path);

		if (Assets.exists(file('images/$noExtension.xml')))
		{
			return FlxAtlasFrames.fromSparrow(imagePath, file('images/$noExtension.xml'));
		}
		else if (Assets.exists(file('images/$noExtension.json')))
		{
			return FlxAtlasFrames.fromAseprite(imagePath, file('images/$noExtension.json'));
		}
		else if (Assets.exists(file('images/$noExtension.txt')))
		{
			return FlxAtlasFrames.fromSpriteSheetPacker(imagePath, file('images/$noExtension.txt'));
		}

		return null;
	}
	static function _getFiles(path:String, ?library:String):Array<String>
	{
		var fullPath:String = file(path, library);

		var result:Array<String> = [];
		for (file in FileSystem.readDirectory(fullPath))
		{
			if (!FileSystem.isDirectory('$fullPath$file'))
			{
				result.push(file);
			}
		}
		return result;
	}
}