package impostor.ui.debug;

import openfl.text.TextField;
import openfl.text.TextFormat;

class Framerate extends DebugCategory
{
    public var currentFPS(get, never):Int;

    var mainFPSText:TextField;
    var othersFPSText:TextField;

    var fps(default, set):Int;
    var avgFps:Int = 0;
    var lowFps:Int = 0;

    var times:Array<Int> = [];
    var currentTime:Int = 0;

    public function new(backgroundColor:Int)
    {
        super(null, 220, 84, backgroundColor);

        othersFPSText = new TextField();
        othersFPSText.x = getPositionFromCategoryAlignment();
        othersFPSText.y = 38;
        othersFPSText.width = overlayWidth;
        othersFPSText.height = overlayHeight;
        othersFPSText.selectable = false;
		othersFPSText.mouseEnabled = false;
        othersFPSText.defaultTextFormat = new TextFormat(Defaults.DEFAULT_FONT, 15, 0xFFFFFF, null, null, null, null, null, getTextAlignFromCategoryAlignment());
        addChild(othersFPSText);

        mainFPSText = new TextField();
        mainFPSText.x = getPositionFromCategoryAlignment();
        mainFPSText.y = 2;
        mainFPSText.width = overlayWidth;
        mainFPSText.height = overlayHeight;
        mainFPSText.selectable = false;
		mainFPSText.mouseEnabled = false;
        mainFPSText.defaultTextFormat = new TextFormat(Defaults.DEFAULT_FONT, 28, 0xFFFFFF, null, null, null, null, null, getTextAlignFromCategoryAlignment());
        addChild(mainFPSText);

        fps = 0;
    }

    public function update(deltaTime:Int)
    {
        currentTime += deltaTime;
        times.push(currentTime);

        while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

        fps = times.length;

        final otherCounters:Array<String> = [];
        otherCounters.push('Average FPS: $avgFps');
        otherCounters.push('Lowest FPS: $lowFps');

        othersFPSText.text = otherCounters.join('\n');
    }

    function get_currentFPS():Int
    {
        return fps;
    }

    function set_fps(value:Int):Int
    {
        fps = value;
        mainFPSText.text = 'FPS: $fps';

        if (fps < 10)
        {
            mainFPSText.textColor = 0xFF0000;
        }
        if (fps < 30)
        {
            mainFPSText.textColor = 0xFF8800;
        }
        else if (fps < 60)
        {
            mainFPSText.textColor = 0xFFFF00;
        }
        else
        {
            mainFPSText.textColor = 0xFFFFFF;
        }

        return fps;
    }
}