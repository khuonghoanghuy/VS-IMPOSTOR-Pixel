package impostor.ui.debug;

import impostor.utils.MemoryUtil;
import openfl.text.TextField;
import openfl.text.TextFormat;

class Memory extends DebugCategory
{
    var memoryInfo:TextField;

    public function new(backgroundColor:Int)
    {
        super("Memory Info", 440, 84, backgroundColor, TOP_RIGHT);

        memoryInfo = new TextField();
        memoryInfo.x = getPositionFromCategoryAlignment();
        memoryInfo.y = 18;
        memoryInfo.width = overlayWidth;
        memoryInfo.height = overlayHeight;
        memoryInfo.selectable = false;
		memoryInfo.mouseEnabled = false;
        memoryInfo.defaultTextFormat = new TextFormat(Defaults.DEFAULT_FONT, 15, 0xFFFFFF, null, null, null, null, null, getTextAlignFromCategoryAlignment());
        addChild(memoryInfo);
    }

    public function update()
    {
        #if web
        memoryInfo.text = "Not available for Web targets.";
        #else
        final memShit:Array<String> = [];
        //memShit.push('CPU Usage: 0');
        memShit.push('RAM Usage: ${FlxMath.roundDecimal(MemoryUtil.getRAMUsage() * 100, 1)}% (${StringUtil.getByteSizeString(MemoryUtil.getTaskMemory())} / ${StringUtil.getByteSizeString(MemoryUtil.getSystemMemory())})');
        memShit.push('VRAM Usage: ${FlxMath.roundDecimal(MemoryUtil.getVRAMUsage() * 100, 1)}% (${StringUtil.getByteSizeString(MemoryUtil.getGraphicsMemoryUsage())} / ${StringUtil.getByteSizeString(MemoryUtil.getGraphicsMemoryTotal())})');
        memShit.push('Garbage Collector Memory: ${StringUtil.getByteSizeString(MemoryUtil.getGCMemory())}');

        memoryInfo.text = memShit.join('\n');
        #end
    }
}