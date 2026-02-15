package funkin;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import funkin.menus.TitleState;

class InitState extends FlxState
{
    override public function create()
    {
        FlxSprite.defaultAntialiasing = false;
        Conductor.init();
		Translations.init();
        Achievements.init();
		#if DISCORD_API
        DiscordClient.init();
		#end

        #if FLX_MOUSE
        FlxG.mouse.useSystemCursor = true;
        #end

        FlxG.stage.window.minWidth = 1280;
        FlxG.stage.window.minHeight = 720;

        FlxG.cameras.bgColor = FlxColor.TRANSPARENT;

        startGame();
    }

    function startGame()
    {
		FlxG.switchState(() -> new TitleState());
    }
}