package impostor.ui.debug;

import openfl.text.TextField;
import openfl.text.TextFormat;

class Conductor extends DebugCategory
{
    var conductorInfo:TextField;

    public function new(backgroundColor:Int)
    {
        super("Conductor", 280, 140, backgroundColor);

        conductorInfo = new TextField();
        conductorInfo.x = getPositionFromCategoryAlignment();
        conductorInfo.y = 18;
        conductorInfo.width = overlayWidth;
        conductorInfo.height = overlayHeight;
        conductorInfo.selectable = false;
		conductorInfo.mouseEnabled = false;
        conductorInfo.defaultTextFormat = new TextFormat(Defaults.DEFAULT_FONT, 15, 0xFFFFFF, null, null, null, null, null, getTextAlignFromCategoryAlignment());
        addChild(conductorInfo);
    }

    public function update()
    {
        final musicInfo:Array<String> = [];
        musicInfo.push('Song Position: ${impostor.system.Conductor.songPosition}');
        musicInfo.push('BPM: ${impostor.system.Conductor.curBPM}');
        musicInfo.push('Measure: ${impostor.system.Conductor.curMeasure}');
        musicInfo.push('Beat: ${impostor.system.Conductor.curBeat}');
        musicInfo.push('Step: ${impostor.system.Conductor.curStep}');
        musicInfo.push('Standalone: ${impostor.system.Conductor.standalone}');

        conductorInfo.text = musicInfo.join('\n');
    }
}