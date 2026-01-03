package impostor.ui.debug;

import flixel.FlxBasic;
import openfl.text.TextField;
import openfl.text.TextFormat;

class GameEngine extends DebugCategory
{
    var engineInfo:TextField;

    public function new(backgroundColor:Int)
    {
        super("Game Engine", 400, 158, backgroundColor);

        engineInfo = new TextField();
        engineInfo.x = getPositionFromCategoryAlignment();
        engineInfo.y = 18;
        engineInfo.width = overlayWidth;
        engineInfo.height = overlayHeight;
        engineInfo.selectable = false;
		engineInfo.mouseEnabled = false;
        engineInfo.defaultTextFormat = new TextFormat(Defaults.DEFAULT_FONT, 15, 0xFFFFFF, null, null, null, null, null, getTextAlignFromCategoryAlignment());
        addChild(engineInfo);
    }

    public function update()
    {
        final engineStuff:Array<String> = [];
        engineStuff.push('State: ${Type.getClassName(Type.getClass(FlxG.state))}');
        engineStuff.push('Object Count: ${getCurrentStateObjectCount()}');
        engineStuff.push('Camera Count: ${FlxG.cameras.list.length}');
        engineStuff.push('Bitmap Count: ${Lambda.count(@:privateAccess FlxG.bitmap._cache)}');
        engineStuff.push('Sounds Count: ${FlxG.sound.list.length}');
        engineStuff.push('Font Count: ${Assets.list(FONT).length}');
        engineStuff.push('Children Count: ${FlxG.game.numChildren}');

        engineInfo.text = engineStuff.join('\n');
    }

    @:access(flixel.group.FlxTypedGroup)
    function getCurrentStateObjectCount():Int
    {
        function getMemberLengthOfGroup(group:FlxGroup):Int
        {
            var length:Int = 0;

            for (member in group.members)
            {
                length++;

                var group = FlxTypedGroup.resolveGroup(member);
                if (group != null)
                {
                    length += getMemberLengthOfGroup(group);
                }
            }

            return length;
        }

        return getMemberLengthOfGroup(FlxG.state);
    }
}