package funkin.system;

import flixel.FlxGame;
import flixel.util.typeLimit.NextState.InitialState;
import funkin.graphics.FunkinBitmapText;

class FunkinGame extends FlxGame
{
    /**
     * Instantiate a new game object.
     * 
     * Yes this means you can have multiple HaxeFlixel games running at the same time (not recommended though).
     * @param gameWidth The width of your game in pixels. If `0`, the engine will use the `project.hxp` window width value.
     * @param gameHeight The height of your game in pixels. If `0`, the engine will use the `project.hxp` window height value.
     * @param initialState The `FlxState` the game will start in.
     * @param updateFramerate How frequently the game should update by default.
     * @param drawFramerate How frequently the game should be drawn by default.
     * @param startFullscreen Whether the game should start in fullscreen or not.
     */
	public function new(gameWidth:Int = 0, gameHeight:Int = 0, ?initialState:InitialState, updateFramerate:Int = 60, drawFramerate:Int = 60,
			startFullscreen:Bool = false)
	{
        super(gameWidth, gameHeight, initialState, updateFramerate, drawFramerate, true, startFullscreen);
	}

	/**
	 * This function is called by `step()` and updates the actual game state.
	 * May be called multiple times per "frame" or draw call.
	 * 
	 * The Funkin version adds handlers for:
	 * - Resetting the state by the user through a key input.
	 * - Syncing the game's language with the user's system language.
	 */
	override function update():Void
	{
		super.update();

		var systemLanguage:String = Translations.getLanguageShort(Translations.getSystemLanguage());
		if (systemLanguage != Translations.curLanguageID)
		{
			Translations.curLanguageID = systemLanguage;
		}

		if (FlxG.keys.justPressed.F5)
		{
			FlxG.resetState();
		}
	}

	/**
	 * If there is a state change requested during the update loop,
	 * this function handles actual destroying the old state and related processes,
	 * and calls creates on the new state and plugs it into the game object.
	 * 
	 * The Funkin version adds some extra functions like:
	 * - Checking for achievements that are waiting to be unlocked.
	 */
	override function switchState():Void
	{
		super.switchState();

		Achievements.checkAchievements();
	}

	/**
	 * Updates all text objects whenever the language changes.
	 */
	@:allow(funkin.system.Translations)
	@:access(flixel.group.FlxTypedGroup)
	function updateLanguage():Void
	{
		function updateTextObjects(group:FlxGroup)
		{
			for (member in group.members)
			{
				if (Std.isOfType(member, FunkinText))
				{
					var text:FunkinText = cast(member, FunkinText);
					if (text.translationData != null)
						text.text = "";
				}
				if (Std.isOfType(member, FunkinBitmapText))
				{
					var bitmapText:FunkinBitmapText = cast(member, FunkinBitmapText);
					if (bitmapText.translationData != null)
						bitmapText.text = "";
				}

				var group = FlxTypedGroup.resolveGroup(member);
				if (group != null)
				{
					updateTextObjects(group);
				}
			}
		}

		updateTextObjects(FlxG.state);

		if (Std.isOfType(FlxG.state, MusicBeatState))
			cast(FlxG.state, MusicBeatState).onLanguageUpdate(Translations.curLanguageID);
	}
}