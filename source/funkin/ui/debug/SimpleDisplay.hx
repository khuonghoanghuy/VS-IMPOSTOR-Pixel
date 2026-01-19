package funkin.ui.debug;

import funkin.utils.MemoryUtil;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

class SimpleDisplay extends Sprite
{
    public var currentFPS(get, never):Int;

    var fpsText:TextField;
    var memoryText:TextField;

    var fps(default, set):Int;

    var times:Array<Float> = [];
    var currentTime:Float = 0;

    var memoryUpdateTimer:Float = 0;

    public function new()
    {
        super();

        fpsText = new TextField();
		fpsText.x = 10;
        fpsText.y = 3;
		fpsText.width = 300;
        fpsText.height = 40;
        fpsText.selectable = false;
		fpsText.mouseEnabled = false;
        fpsText.defaultTextFormat = new TextFormat(Defaults.DEFAULT_FONT, 30, 0xFFFFFF);
        addChild(fpsText);

        memoryText = new TextField();
		memoryText.x = 10;
		memoryText.y = 36;
		memoryText.width = 400;
		memoryText.height = 20;
		memoryText.selectable = false;
		memoryText.mouseEnabled = false;
		memoryText.defaultTextFormat = new TextFormat(Defaults.DEFAULT_FONT, 15, 0xFFFFFF);
		addChild(memoryText);

        memoryText.text = 'Memory: ${StringUtil.getByteSizeString(0)}';
    }

    public function update(deltaTime:Float)
    {
        currentTime += deltaTime;
        times.push(currentTime);

        while (times[0] < currentTime - 1)
		{
			times.shift();
		}

        fps = times.length;

        memoryUpdateTimer += deltaTime;
        if (memoryUpdateTimer >= DebugOverlay.UPDATE_FREQUENCY)
        {
            memoryUpdateTimer = 0;
            memoryText.text = 'Memory: ${StringUtil.getByteSizeString(MemoryUtil.getGCMemory())}';
        }
    }

    function get_currentFPS():Int
    {
        return fps;
    }

    function set_fps(value:Int):Int
    {
        fps = value;
        fpsText.text = 'FPS: $fps';

        if (fps < 10)
        {
            fpsText.textColor = 0xFF0000;
        }
        if (fps < 30)
        {
            fpsText.textColor = 0xFF8800;
        }
        else if (fps < 60)
        {
            fpsText.textColor = 0xFFFF00;
        }
        else
        {
            fpsText.textColor = 0xFFFFFF;
        }

        return fps;
    }
}