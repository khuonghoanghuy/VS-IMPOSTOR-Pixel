package funkin.ui.debug.advanced;

import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

enum abstract CategoryAlignment(String) from String to String
{
    var TOP_LEFT = "topLeft";
    var TOP_RIGHT = "topRight";
    var BOTTOM_LEFT = "bottomLeft";
    var BOTTOM_RIGHT = "bottomRight";
}

class DebugCategory extends Sprite
{
    public final overlayWidth:Float;
    public final overlayHeight:Float;

    public var verticalOffset:Float = 0;

    var alignment:CategoryAlignment = TOP_LEFT;

	public var title(default, null):TextField;
	public var background(default, null):Shape;

    public function new(?title:String, width:Float, height:Float, backgroundColor:Int, alignment:CategoryAlignment = TOP_LEFT) {
        super();

        overlayWidth = width;
        overlayHeight = height;
        this.alignment = alignment;

		background = new Shape();
        background.graphics.beginFill(backgroundColor, 0.6);
        background.graphics.drawRect(0, 0, overlayWidth, overlayHeight);
        background.graphics.endFill();
        addChild(background);

        if (title != null)
        {
            this.title = new TextField();
            this.title.text = title;
			this.title.x = 8;
            this.title.y = 2;
			this.title.width = background.width - 16;
            this.title.height = background.height;
            this.title.selectable = false;
            this.title.mouseEnabled = false;
            this.title.defaultTextFormat = new TextFormat(Defaults.DEFAULT_FONT, 12, 0xAAAAAA, null, null, null, null, null, getTextAlignFromCategoryAlignment());
            addChild(this.title);
        }
    }

	public function createTextField():TextField
	{
		var textField:TextField = new TextField();
		textField.x = 8;
		textField.y = 18;
		textField.width = overlayWidth - 16;
		textField.height = overlayHeight;
		textField.selectable = false;
		textField.mouseEnabled = false;
		textField.defaultTextFormat = new TextFormat(Defaults.DEFAULT_FONT, 15, 0xFFFFFF, null, null, null, null, null, getTextAlignFromCategoryAlignment());
		return textField;
	}

    public function updatePosition()
    {
        switch (alignment)
        {
            case TOP_LEFT:
                x = 0;
                y = verticalOffset;
            case TOP_RIGHT:
                x = FlxG.stage.stageWidth - overlayWidth;
                y = verticalOffset;
            case BOTTOM_LEFT:
                x = 0;
                y = FlxG.stage.stageHeight - overlayHeight - verticalOffset;
            case BOTTOM_RIGHT:
                x = FlxG.stage.stageWidth - overlayWidth;
                y = FlxG.stage.stageHeight - overlayHeight - verticalOffset;
        }
    }

	public function update(deltaTime:Float) {}

	public function postUpdate() {}

    public function getTextAlignFromCategoryAlignment():TextFormatAlign
    {
        return switch (alignment)
        {
            case TOP_LEFT, BOTTOM_LEFT: TextFormatAlign.LEFT;
            case TOP_RIGHT, BOTTOM_RIGHT: TextFormatAlign.RIGHT;
        }
    }
}