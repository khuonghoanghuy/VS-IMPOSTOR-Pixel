package funkin.ui;

import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;

class MusicBeatState extends FlxTransitionableState
{
	public static var skipTransIn(get, set):Bool;

	public static var skipTransOut(get, set):Bool;

	static function set_skipTransIn(value:Bool):Bool
	{
		return FlxTransitionableState.skipNextTransIn = value;
	}

	static function get_skipTransIn():Bool
	{
		return FlxTransitionableState.skipNextTransIn;
	}

	static function set_skipTransOut(value:Bool):Bool
	{
		return FlxTransitionableState.skipNextTransOut = value;
	}

	static function get_skipTransOut():Bool
	{
		return FlxTransitionableState.skipNextTransOut;
	}

	public var curMeasure(get, never):Int;

	public var curBeat(get, never):Int;

	public var curStep(get, never):Int;

	/**
	 * Creates a new state with the ability to do transitions and do stuff on beats.
	 * 
	 * @param transInData 	Plays when the state beings.
	 * @param transOutData 	Plays when the state ends.
	 */
	public function new(?transInData:TransitionData, ?transOutData:TransitionData)
	{
		super(transInData, transOutData);

		Conductor.onMeasureHit.add(measureHit);
		Conductor.onBeatHit.add(beatHit);
		Conductor.onStepHit.add(stepHit);
	}

	override public function destroy()
	{
		super.destroy();

		Conductor.onMeasureHit.remove(measureHit);
		Conductor.onBeatHit.remove(beatHit);
		Conductor.onStepHit.remove(stepHit);
	}

	/**
	 * Gets triggered when the Conductor reaches a new measure.
	 * @param measure The reached measure.
	 */
	public function measureHit(measure:Int) {}

	/**
	 * Gets triggered when the Conductor reaches a new beat.
	 * @param beat The reached beat.
	 */
	public function beatHit(beat:Int) {}

	/**
	 * Gets triggered when the Conductor reaches a new step.
	 * @param step The reached step.
	 */
	public function stepHit(step:Int) {}

	/**
	 * This function is called whenever the game's language gets updated.
	 * @param language The new language.
	 */
	public function onLanguageUpdate(language:String) {}

	function get_curMeasure():Int
	{
		return Conductor.curMeasure;
	}

	function get_curBeat():Int
	{
		return Conductor.curBeat;
	}

	function get_curStep():Int
	{
		return Conductor.curStep;
	}
}
