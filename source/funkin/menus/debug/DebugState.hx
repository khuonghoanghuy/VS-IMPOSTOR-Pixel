package funkin.menus.debug;

import flixel.FlxState;
import funkin.menus.debug.character.CharacterEditorState;

class DebugState extends FlxState
{
    var editorsArray:Array<String> = ["Chart Editor", "Character Editor"];

    var editors:FlxTypedGroup<FunkinText>;

    var curEntry:Int = 0;

    override public function create()
    {
        FunkinSound.stopMusic();

        super.create();

        editors = new FlxTypedGroup<FunkinText>();
        add(editors);

        for (i => editor in editorsArray)
        {
            var text:FunkinText = new FunkinText(0, 0, 0, editor, 32);
            text.screenCenter(X);
            text.y = 10 * i;//(((FlxG.height - text.height) / 2) / editorsArray.length) * i;
            editors.add(text);
        }

        changeEntry();
    }

    override public function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.UP)
            changeEntry(-1);
        else if (FlxG.keys.justPressed.DOWN)
            changeEntry(1);

        super.update(elapsed);

        if (FlxG.keys.justPressed.ENTER)
            checkEntry();
    }

    function changeEntry(change:Int = 0)
    {
        curEntry = FlxMath.wrap(curEntry + change, 0, editorsArray.length - 1);

        for (i => text in editors.members)
        {
            if (i == curEntry)
                text.scale.set(1.1, 1.1);
            else
                text.scale.set(1, 1);
        }
    }

    function checkEntry()
    {
        switch (curEntry)
        {
            case 0: // nothing yet
            case 1: FlxG.switchState(() -> new CharacterEditorState());
        }
    }
}