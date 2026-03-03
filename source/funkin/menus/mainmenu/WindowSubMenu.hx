package funkin.menus.mainmenu;

import flixel.math.FlxPoint;

class WindowSubMenu extends FlxTypedGroup<WindowButton>
{
    public var nameTranslationID(default, null):String;

    public var customUpdate:Float->Void = null;

    var _parent:WindowSubMenuHandler;

    var _pointerPosition:FlxPoint;
    var _hovering:Bool = false;

    public function new(translationID:String)
    {
        super();

        nameTranslationID = translationID;

        _pointerPosition = FlxPoint.get(-1, -1);
    }

    override function destroy()
    {
        super.destroy();
        customUpdate = null;
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (customUpdate != null) customUpdate(elapsed);

        var _lastPosition:FlxPoint = _pointerPosition.clone();
        _hovering = false;

        for (button in members)
        {
			/*
            if (Pointer.overlapsComplex(button, @:privateAccess _parent.windowCamera) && button.available)
            {
                _hovering = true;
                _pointerPosition.copyFrom(button.index);
                if (_pointerPosition.x != _lastPosition.x || _pointerPosition.y != _lastPosition.y)
                {
                    button.hover();
                }
            }
            else
            {
                button.idle();
            }

            if (_hovering && Pointer.justReleased)
            {
                //button.checkPosition();
            }
			 */
        }

        if (!_hovering)
        {
            _pointerPosition.set(-1, -1);
        }
    }

    public function init(parent:WindowSubMenuHandler):Void
    {
        _parent = parent;

        forEach((spr) -> {
            spr.camera = @:privateAccess _parent.windowCamera;
        });
    }
}