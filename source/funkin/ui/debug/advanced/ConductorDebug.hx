package funkin.ui.debug.advanced;

import openfl.text.TextField;

class ConductorDebug extends DebugCategory
{
    var conductorInfo:TextField;

    public function new(backgroundColor:Int)
    {
        super("Conductor", 280, 138, backgroundColor);

        conductorInfo = createTextField();
        addChild(conductorInfo);
    }

	override public function update(deltaTime:Float)
    {
        final musicInfo:Array<String> = [];
        musicInfo.push('Song Position: ${Conductor.songPosition}');
        musicInfo.push('BPM: ${Conductor.curBPM}');
        musicInfo.push('Measure: ${Conductor.curMeasure}');
        musicInfo.push('Beat: ${Conductor.curBeat}');
        musicInfo.push('Step: ${Conductor.curStep}');
        musicInfo.push('Standalone: ${Conductor.standalone}');

        conductorInfo.text = musicInfo.join('\n');
    }
}