package funkin;

import flixel.graphics.frames.FlxAtlasFrames;
import haxe.io.Path;
import lime.system.System;
#if sys
import sys.FileSystem;
#end

class Paths
{
	public static function getPath(path:String, ?library:String):String
    {
		return library != null ? '$library:assets/$library/$path' : 'assets/$path';
    }

	public inline static function file(path:String, ?library:String):String
	{
		return getPath('$path', library);
	}

	public inline static function json(path:String, ?library:String):String
	{
		return getPath('data/$path.json', library);
	}

	public static function image(path:String, ?library:String):String
    {
		var path:String = getPath('images/$path.png', library);
		var pathNoExt:String = Path.withoutExtension(path);
		var extension:String = Path.extension(path);
		//trace('$pathNoExt-${Translations.curLanguageID}.$extension');
		if (Assets.exists('$pathNoExt-${Translations.curLanguageID}'))
		{
			return '$pathNoExt-${Translations.curLanguageID}.$extension';
		}
		else
		{
			return path;
		}
    }

	public inline static function sound(path:String, ?library:String):String
    {
        return getPath('sounds/$path.ogg', library);
    }

	public inline static function music(path:String, ?library:String):String
    {
        return getPath('music/$path.ogg', library);
    }

	public inline static function font(path:String, ?library:String):String
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

	public static function getFrames(path:String, ?library:String):FlxAtlasFrames
	{
		var imagePath:String = image(path, library);

		if (Assets.exists(file('images/$path.xml')))
		{
			return FlxAtlasFrames.fromSparrow(imagePath, file('images/$path.xml', library));
		}
		else if (Assets.exists(file('images/$path.json')))
		{
			return FlxAtlasFrames.fromAseprite(imagePath, file('images/$path.json', library));
		}
		else if (Assets.exists(file('images/$path.txt')))
		{
			return FlxAtlasFrames.fromSpriteSheetPacker(imagePath, file('images/$path.txt', library));
		}

		return null;
	}

	static function _getFiles(path:String, ?library:String):Array<String>
	{
		var fullPath:String = file(path, library);

		var result:Array<String> = [];
		#if sys
		for (file in FileSystem.readDirectory(fullPath))
		{
			if (!FileSystem.isDirectory('$fullPath$file'))
			{
				result.push(file);
			}
		}
		#end
		return result;
	}
}