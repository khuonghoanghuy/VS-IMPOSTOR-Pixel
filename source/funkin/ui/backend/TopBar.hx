package funkin.ui.backend;

import flixel.FlxSprite;
import flixel.group.FlxContainer.FlxTypedContainer;
import flixel.util.FlxDestroyUtil;

class TopBar extends FlxTypedContainer<FlxSprite>
{
    public var buttonsLength(default, null):Int = 0;

    public var bar(default, null):FunkinSprite;

    var buttons:Array<UIButtonList>;

    public function new()
    {
        super();

        bar = new FunkinSprite().makeSolid(FlxG.width + 1, 40, 0xFF303030);
        add(bar);

        buttons = new Array<UIButtonList>();
    }

    override public function destroy()
    {
        super.destroy();

        buttons = FlxDestroyUtil.destroyArray(buttons);
    }

    public function addButton(button:UIButtonList):UIButtonList
    {
        if (button == null)
            return button;

        if (buttons.indexOf(button) >= 0)
            return button;

        button.y = (bar.height - button.height) / 2;

        if (buttonsLength < 1)
            button.x = 8;
        else
            button.x = buttons[buttonsLength - 1].x + buttons[buttonsLength - 1].box.width;

        button.cameras = this.cameras;

        add(button);
        buttons.push(button);
        buttonsLength++;

        return button;
    }

    public function isAnyOpen():Bool
    {
        for (button in buttons)
        {
            if (button.isOpen)
                return true;
        }

        return false;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        final openAt:Int = getFirstOpenIndex();

        if (openAt >= 0)
        {
            for (i => button in buttons)
            {
                if (openAt == i) continue;

                if (button.checkOverlap())
                {
                    button.press();
                    buttons[openAt].release();
                }
            }
        }
    }

    function getFirstOpenIndex():Int
    {
        for (i in 0...buttons.length)
        {
            if (buttons[i].isOpen)
                return i;
        }

        return -1;
    }
}