package funkin.ui.debug.advanced;

import flixel.util.FlxStringUtil;
import funkin.utils.MemoryUtil;
import openfl.text.TextField;

class Memory extends DebugCategory
{
    var memoryInfo:TextField;

    public function new(backgroundColor:Int)
    {
        super("Memory Info", 440, 84, backgroundColor, TOP_RIGHT);

		memoryInfo = createTextField();
        addChild(memoryInfo);
    }

	override public function postUpdate()
    {
        #if web
        memoryInfo.text = "Not available for Web targets.";
        #else
        final memShit:Array<String> = [];
        //memShit.push('CPU Usage: 0');
		memShit.push('RAM Usage: ${FlxMath.roundDecimal(MemoryUtil.getRAMUsage() * 100, 1)}% (${FlxStringUtil.formatBytes(MemoryUtil.getTaskMemory())} / ${FlxStringUtil.formatBytes(MemoryUtil.getSystemMemory())})');
		memShit.push('VRAM Usage: ${FlxMath.roundDecimal(MemoryUtil.getVRAMUsage() * 100, 1)}% (${FlxStringUtil.formatBytes(MemoryUtil.getGraphicsMemoryUsage())} / ${FlxStringUtil.formatBytes(MemoryUtil.getGraphicsMemoryTotal())})');
		memShit.push('Garbage Collector Memory: ${FlxStringUtil.formatBytes(MemoryUtil.getGCMemory())}');

        memoryInfo.text = memShit.join('\n');
        #end
    }
}