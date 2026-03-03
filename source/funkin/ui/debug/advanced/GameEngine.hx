package funkin.ui.debug.advanced;

import flixel.FlxSprite;

import openfl.text.TextField;

/**
 * Shows information about the game engine.
 */
class GameEngine extends DebugCategory
{
	var engineInfo:TextField;

	public function new(backgroundColor:Int)
	{
		super('Game Engine', 400, 176, backgroundColor);

		engineInfo = createTextField();
		addChild(engineInfo);
	}

	override public function postUpdate()
	{
		final engineStuff:Array<String> = [];
		engineStuff.push('State: ${Type.getClassName(Type.getClass(FlxG.state))}');
		engineStuff.push('Object Count: ${getCurrentStateObjectCount()}');
		engineStuff.push('Camera Count: ${FlxG.cameras.list.length}');
		engineStuff.push('Bitmap Count: ${Lambda.count(@:privateAccess FlxG.bitmap._cache)}');
		engineStuff.push('Sounds Count: ${FlxG.sound.list.length}');
		engineStuff.push('Font Count: ${Assets.list(FONT).length}');
		engineStuff.push('Children Count: ${FlxG.game.numChildren}');
		engineStuff.push('Shader Count: ${getShaderCount()}');

		engineInfo.text = engineStuff.join('\n');
	}

	@:access(flixel.group.FlxTypedGroup)
	function getCurrentStateObjectCount():Int
	{
		function getMemberLengthFromGroup(group:FlxGroup):Int
		{
			var length:Int = 0;

			for (member in group.members)
			{
				length++;

				var group = FlxTypedGroup.resolveGroup(member);
				if (group != null)
				{
					length += getMemberLengthFromGroup(group);
				}
			}

			return length;
		}

		return getMemberLengthFromGroup(FlxG.state);
	}

	function getShaderCount():Int
	{
		var length:Int = 0;

		length += getFieldUsage(FlxSprite, 'shader');

		for (i in 0...FlxG.cameras.list.length)
		{
			var camera:FlxCamera = FlxG.cameras.list[i];
			if (camera.filters != null)
			{
				length += camera.filters.length;
			}
		}

		length += FlxG.game.filters.length;

		return length;
	}

	@:access(flixel.group.FlxTypedGroup)
	function getFieldUsage(fromClass:Dynamic, field:String):Int
	{
		function getMemberLengthFromFieldFromGroup(group:FlxGroup, fromClass:Dynamic, field:String):Int
		{
			var length:Int = 0;

			for (member in group.members)
			{
				if (Std.isOfType(member, fromClass) && Reflect.getProperty(member, field) != null)
				{
					length++;
				}

				var group = FlxTypedGroup.resolveGroup(member);
				if (group != null)
				{
					length += getMemberLengthFromFieldFromGroup(group, fromClass, field);
				}
			}

			return length;
		}

		return getMemberLengthFromFieldFromGroup(FlxG.state, fromClass, field);
	}
}
