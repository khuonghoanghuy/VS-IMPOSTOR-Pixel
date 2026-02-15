package funkin.ui;

import flixel.FlxObject;
import flixel.input.FlxInput;
import flixel.input.IFlxInput;
import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSignal;

class FunkinButton extends FunkinSprite implements IFlxInput
{
    public var onPress:FlxSignal = new FlxSignal();

    public var onRelease:FlxSignal = new FlxSignal();

    public var onHover:FlxSignal = new FlxSignal();

    public var onUnhover:FlxSignal = new FlxSignal();

    public var justPressed(get, never):Bool;

    public var pressed(get, never):Bool;

    public var justReleased(get, never):Bool;

    public var released(get, never):Bool;

    public var enabled:Bool = true;

    public var deadzones:Array<FlxObject> = [];

    public var radius:Float = 0;

    public var fade:Bool;

    public var instant:Bool;

    var restOpacity:Float = 0.3;

    var input:FlxInput<Int>;

	var touchID:Int = -1;

    var _isPressed:Bool = false;

    public function new(x:Float = 0, y:Float = 0, fade:Bool = false, instant:Bool = false)
    {
        super(x, y);
        loadGraphic(Paths.image("ui/x"));

        solid = false;
        immovable = true;
        scrollFactor.set();

        this.fade = fade;
        this.instant = instant;

        input = new FlxInput(0);
    }

    override function destroy()
    {
        super.destroy();

        deadzones = FlxDestroyUtil.destroyArray(deadzones);
        input = null;
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (visible && enabled)
        {
			final overlapping:Bool = FlxG.onMobile ? checkTouchOverlap() : checkMouseOverlap();

			function getPressed():Bool
			{
				if (FlxG.onMobile)
				{
					if (touchID >= 0)
					{
						return FlxG.touches.list[touchID].pressed;
					}
				}
				else
					return FlxG.mouse.pressed;

				return false;
			}

            if (overlapping)
            {
				if (getPressed())
                {
                    if (!_isPressed) pressHandler();
                }
                else
                {
                    if (_isPressed) releaseHandler();
                }
            }
            else
            {
                if (_isPressed) unhoverHandler();
            }
        }

        input.update();
    }

	function checkMouseOverlap():Bool
    {
        for (camera in cameras)
        {
			final worldPoint:FlxPoint = FlxG.mouse.getWorldPosition(camera, _point);

            for (deadzone in deadzones)
            {
                if (deadzone != null && deadzone.overlapsPoint(worldPoint, true, camera)) return false;
            }

            if (radius > 0)
            {
                if (circleOverlapsPoint(worldPoint, camera))
                {
					updateStatus(FlxG.mouse);
					return true;
				}
			}
			else
			{
				if (overlapsPoint(worldPoint, true, camera))
				{
					updateStatus(FlxG.mouse);
					return true;
				}
			}
		}

		return false;
	}

	function checkTouchOverlap():Bool
	{
		for (camera in cameras)
		{
			for (touch in FlxG.touches.list)
			{
				final worldPoint:FlxPoint = touch.getWorldPosition(camera, _point);

				for (deadzone in deadzones)
				{
					if (deadzone != null && deadzone.overlapsPoint(worldPoint, true, camera))
						return false;
				}

				function updateTouch()
				{
					touchID = FlxG.touches.list.indexOf(touch);
					updateStatus(touch);
				}

				if (radius > 0)
				{
					if (circleOverlapsPoint(worldPoint, camera))
					{
						updateTouch();
						return true;
					}
				}
				else
				{
					if (overlapsPoint(worldPoint, true, camera))
					{
						updateTouch();
						return true;
					}
                }
			}
		}

		return false;
	}

    public function circleOverlapsPoint(point:FlxPoint, ?camera:FlxCamera):Bool
    {
        if (camera == null) camera = FlxG.camera;

        final xPos:Float = point.x - camera.scroll.x;
        final yPos:Float = point.y - camera.scroll.y;
        getScreenPosition(_point, camera);
        point.putWeak();

        final distanceX:Float = xPos - (_point.x + (width / 2));
        final distanceY:Float = yPos - (_point.y + (height / 2));
        final distance:Float = Math.sqrt((distanceX * distanceY) + (distanceX * distanceY));

        return distance <= radius;
    }

	function updateStatus(input:Dynamic)
    {
        if (input.justPressed)
        {
            pressHandler();
        }
        else if (!_isPressed)
        {
            if (input.pressed)
            {
                pressHandler();
            }
        }
    }

    function pressHandler():Void
    {
        _isPressed = true;

        input.press();

        onPress.dispatch();
    }

    function releaseHandler():Void
    {
        _isPressed = false;

        input.release();
		touchID = -1;

        onRelease.dispatch();
    }

    function unhoverHandler():Void
    {
        _isPressed = false;

        input.release();
		touchID = -1;

        onUnhover.dispatch();
    }

    function get_justPressed():Bool
    {
        return input.justPressed;
    }

    function get_pressed():Bool
    {
        return input.pressed;
    }

    function get_justReleased():Bool
    {
        return input.justReleased;
    }

    function get_released():Bool
    {
        return input.released;
    }
}