package funkin.graphics.text;

import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxPoint;

class GameboyText extends FunkinBitmapText
{
	var glyphs:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,?!><ÁÀÉÈÍÌÓÒÚÙ ";
    public function new(x:Float = 0, y:Float = 0, text:String = "", size:Int = 12)
    {
		super(x, y, text, size, FlxBitmapFont.fromMonospace(Paths.font('gameboy.png'), glyphs, FlxPoint.get(8, 10)));
		letterSpacing = -1;
    }

	override function set_text(value:UnicodeString):UnicodeString
	{
		super.set_text(value);
		text = text.toUpperCase();
		return value;
	}
}