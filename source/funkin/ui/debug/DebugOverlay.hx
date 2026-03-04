package funkin.ui.debug;

import funkin.ui.debug.advanced.*;

import openfl.display.Sprite;

class DebugOverlay extends Sprite
{
	public static var UPDATE_FREQUENCY:Float = 0.5;

	public var displayMode(default, null):DebugDisplayMode = NONE;

	var displayModeInt:Int = DebugDisplayMode.NONE;

	public var simple(default, null):SimpleDisplay;

	public var framerate(default, null):Framerate;

	public var memory(default, null):Memory;

	public var conductor(default, null):ConductorDebug;

	public var system(default, null):SystemStats;

	public var engine(default, null):GameEngine;

	var project:ProjectDebug;

	var updateTimer:Float = 0;

	public function new(backgroundColor:Int = 0x7F7F7F)
	{
		super();

		simple = new SimpleDisplay();
		addChild(simple);

		framerate = new Framerate(backgroundColor);
		addChild(framerate);

		conductor = new ConductorDebug(backgroundColor);
		conductor.verticalOffset = framerate.overlayHeight + 5;
		addChild(conductor);

		engine = new GameEngine(backgroundColor);
		engine.verticalOffset = conductor.verticalOffset + conductor.overlayHeight + 5;
		addChild(engine);

		project = new ProjectDebug(backgroundColor);
		addChild(project);

		system = new SystemStats(backgroundColor);
		system.verticalOffset = project.overlayHeight + 5;
		addChild(system);

		memory = new Memory(backgroundColor);
		memory.verticalOffset = system.verticalOffset + system.overlayHeight + 5;
		addChild(memory);

		simple.update(0);
		framerate.update(0);
		conductor.update(0);
		engine.update(0);
		system.update(0);
		memory.update(0);

		updateDisplayMode();
	}

	/**
	 * Cycles through the display modes of the overlay.
	 */
	public function cycleDisplayMode()
	{
		displayModeInt++;

		if (displayModeInt > DebugDisplayMode.ADVANCED)
		{
			displayModeInt = DebugDisplayMode.NONE;
		}

		displayMode = displayMode.fromInt(displayModeInt);

		updateDisplayMode();
	}

	/**
	 * Updates the overlay's visibility based on the current display mode.
	 */
	public function updateDisplayMode()
	{
		visible = displayMode != NONE;
		simple.visible = displayMode == SIMPLE;
		framerate.visible = displayMode == ADVANCED;
		conductor.visible = displayMode == ADVANCED;
		memory.visible = displayMode == ADVANCED;
		system.visible = displayMode == ADVANCED;
		engine.visible = displayMode == ADVANCED;
		project.visible = displayMode == ADVANCED;
	}

	override function __enterFrame(deltaTime:Int)
	{
		if (#if html5 FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.THREE #else FlxG.keys.justPressed.F3 #end)
		{
			cycleDisplayMode();
		}

		var dt:Float = deltaTime / 1000;

		if (displayMode == SIMPLE)
		{
			simple.update(dt);
			return;
		}

		for (i in 0...numChildren)
		{
			var child:DebugCategory = cast getChildAt(i);
			child.updatePosition();
			child.update(dt);
		}

		if (updateTimer < UPDATE_FREQUENCY)
		{
			updateTimer += dt;
			return;
		}

		for (i in 0...numChildren)
		{
			var child:DebugCategory = cast getChildAt(i);
			child.postUpdate();
		}

		updateTimer = 0;
	}
}

/**
 * The modes the overlay can be displayed.
 */
enum abstract DebugDisplayMode(Int) from Int to Int
{
	/**
	 * The overlay will show nothing.
	 */
	var NONE:Int = 0;

	/**
	 * The overlay will only show the FPS counter and the Garbage Collector memory.
	 */
	var SIMPLE:Int = 1;

	/**
	 * The overlay will show everything.
	 */
	var ADVANCED:Int = 2;

	public function fromInt(int:Int):DebugDisplayMode
	{
		return switch (int)
		{
			case 0: NONE;
			case 1: SIMPLE;
			case 2: ADVANCED;
			case _: NONE;
		};
	}

	public function toInt(mode:DebugDisplayMode):Int
	{
		return switch (mode)
		{
			case NONE: 0;
			case SIMPLE: 1;
			case ADVANCED: 2;
		};
	}
}
