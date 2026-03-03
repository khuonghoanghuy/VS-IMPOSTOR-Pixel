package funkin.ui.backend;

import flixel.FlxSprite;
import flixel.group.FlxSpriteContainer.FlxTypedSpriteContainer;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;

class UIButton extends FlxTypedSpriteContainer<FlxSprite>
{
    public var idleColor:FlxColor = 0xFF303030;
    public var hoverColor:FlxColor = 0xFF484848;
    public var pressColor:FlxColor = 0xFF121212;

    public var onPress(default, null):FlxSignal = new FlxSignal();
    public var onRelease(default, null):FlxSignal = new FlxSignal();

    public var box(default, null):FunkinSprite;
    public var text(default, null):FunkinText;

    public function new(label:String = "")
    {
        super(0, 0);

        box = new FunkinSprite().makeSolid(64, 28);

        text = new FunkinText(0, 7, box.width, label, 10);
        text.font = "Nokia Cellphone FC Small"; // flixel's default font
        text.alignment = CENTER;

        add(box);
        add(text);
    }

    override public function destroy()
    {
        super.destroy();

        FlxDestroyUtil.destroy(onPress);
        FlxDestroyUtil.destroy(onRelease);
    }

    public function resize(width:Int = 64, height:Int = 28)
    {
        if (width < 64)
        {
            width = 64;
        }

        if (height < 28)
        {
            height = 28;
        }

        box.makeSolid(width, height);
        text.fieldWidth = box.width;
    }

    var _isPressed:Bool = false;

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        final overlapping:Bool = checkOverlap();

        if (overlapping)
        {
            if (FlxG.mouse.justPressed)
            {
                _isPressed = true;
                press();
            }

            if (FlxG.mouse.justReleased && _isPressed)
            {
                _isPressed = false;
                release();
            }

            if (!_isPressed)
                box.color = hoverColor;
        }
        else
        {
            if (FlxG.mouse.justReleased && _isPressed)
            {
                _isPressed = false;
                box.color = idleColor;
            }

            if (!_isPressed)
                box.color = idleColor;
        }
    }

    public function checkOverlap():Bool
    {
        for (camera in cameras)
        {
            return box.overlapsPoint(FlxG.mouse.getWorldPosition(camera, _point), true, camera);
        }

        return false;
    }

    public function press()
    {
        onPress.dispatch();
        box.color = pressColor;
    }

    public function release()
    {
        onRelease.dispatch();
        box.color = idleColor;
    }
}