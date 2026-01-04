package impostor.graphics;

import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;

class FunkinBitmapText extends FlxBitmapText
{
    /**
     * The size of the text in pixels.
     */
    public var size(default, set):Int;

    /**
	 * The translation ID this text object follows, so whenever you change the language the text can update accordingly.
	 * 
	 * If `null` (which is the default value), the text won't follow any translation ID, so you can put whatever text you want.
	 */
	public var translationID(default, set):Null<String>;

    /**
     * The actual size of the text.
     */
    var _sizeCalc:Float = 0;

    /**
     * Constructs a new text field component.
     * 
     * @param x     The horizontal position of the text object.
     * @param y     The vertical position of the text object.
     * @param text  The text to display.
     * @param font  The `FlxBitmapFont` to use.
     */
    public function new(x:Float = 0, y:Float = 0, text:UnicodeString = "", size:Int = 12, ?font:FlxBitmapFont)
    {
        super(x, y, text, font);

        set_size(size);
    }

    function set_size(value:Int):Int
    {
        if (size != value)
        {
            size = value;

            _sizeCalc = value / lineHeight;
            scale.set(_sizeCalc, _sizeCalc);
            updateHitbox();
        }

        return value;
    }

    function set_translationID(id:String):String
    {
        if (translationID != id)
		{
			translationID = id;
		}
		return id;
    }

    override function set_text(value:UnicodeString):UnicodeString
    {
        return super.set_text(value);
    }
}