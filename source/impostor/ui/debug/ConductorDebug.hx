package impostor.ui.debug;

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

	override public function update(?deltaTime:Int)
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