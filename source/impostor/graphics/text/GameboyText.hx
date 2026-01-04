package impostor.graphics.text;

import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxPoint;

class GameboyText extends FunkinBitmapText
{
    public function new(x:Float = 0, y:Float = 0, text:String = "", size:Int = 12)
    {
        super(x, y, text, size, FlxBitmapFont.fromMonospace(Paths.font('gameboy.png'), "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,?!>< ", FlxPoint.get(8, 8)));
    }
}