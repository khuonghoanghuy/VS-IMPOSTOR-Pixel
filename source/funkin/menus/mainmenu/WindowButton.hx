package funkin.menus.mainmenu;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.text.FlxText.FlxTextAlign;

typedef WindowGraphicData =
{
    var position:Array<Int>;
    var ?image:String;
    var width:Int;
    var height:Int;
    var ?idleColor:FlxColor;
    var ?hoverColor:FlxColor;
}

class WindowButton extends FlxTypedSpriteGroup<FlxSprite>
{
    public var button(default, null):FunkinSprite;

    public var label(default, null):FunkinText;

    public var icon(default, null):FunkinText;

    public var available(default, set):Bool = true;

    public var onSelect:Void->Void = null;

    public var hoverColor:FlxColor = FlxColor.WHITE;

    public var idleColor:FlxColor = FlxColor.BLACK;

    public var index:FlxPoint;

    var _idleOpacity:Float = 0.1;
	var _hoverOpacity:Float = 0.45;
    var _hasLabel:Bool = false;
    var _hasIcon:Bool = false;
    var data:WindowGraphicData;
    var _idleColor:FlxColor = FlxColor.BLACK;
    var _hoverColor:FlxColor = FlxColor.WHITE;

    public function new(x:Float = 0, y:Float = 0, data:WindowGraphicData)
    {
        super(x, y);

        this.data = data;

        if (data.idleColor != null) _idleColor = data.idleColor;
        if (data.hoverColor != null) _hoverColor = data.hoverColor;

        index = FlxPoint.get(this.data.position[0], this.data.position[1]);

        button = new FunkinSprite();

        if (this.data.image == null)
        {
            button.makeGraphic(this.data.width, this.data.height, FlxColor.WHITE);
            button.alpha = _idleOpacity;
        }
        else
        {
            button.loadGraphic(this.data.image, true, this.data.width, this.data.height);
            button.addAnimationByFrameList("idle", [0], 0);
            button.addAnimationByFrameList("hover", [1], 0);
            button.addAnimationByFrameList("locked", [2], 0);
            button.scaleSprite(MainMenuState.BASE_SCALE);
        }

        add(button);
    }

    var labelPosition:FlxPoint = FlxPoint.get();

    public function addLabel(translationID:String, ?position:FlxPoint, size:Int = 32, alignment:FlxTextAlign = LEFT, limit:Float = 0)
    {
        if (position == null) position = FlxPoint.get();

        labelPosition.copyFrom(position);

        label = new FunkinText(labelPosition.x * MainMenuState.BASE_SCALE, labelPosition.y * MainMenuState.BASE_SCALE, button.width, "", size);
        label.translationData = {id: translationID};
        label.color = available ? _idleColor : FlxColor.BLACK;
        label.alignment = alignment;
        add(label);

        _hasLabel = true;
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    public function checkPosition(position:FlxPoint):Void
    {
        if (position.x == index.x && position.y == index.y)
            hover();
        else
            idle();
    }

    public function idle():Void
    {
        button.playAnimation("idle");
        if (_hasLabel) label.color = _idleColor;
    }

    public function hover():Void
    {
        button.playAnimation("hover");
        if (_hasLabel) label.color = _hoverColor;
    }

    function set_available(value:Bool):Bool
    {
        available = value;

        if (!available)
        {
            button.playAnimation("locked");
            if (_hasLabel) label.color = FlxColor.BLACK;
            if (_hasIcon) icon.color = FlxColor.BLACK;
        }
        else
        {
            button.playAnimation("idle");
            if (_hasLabel) label.color = _idleColor;
            if (_hasIcon) icon.color = FlxColor.WHITE;
        }

        return value;
    }
}