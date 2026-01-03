package impostor;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import impostor.menus.TitleState;

class InitState extends FlxState
{
    override public function create() {
        FlxSprite.defaultAntialiasing = false;
        Conductor.init();
        DiscordClient.init();

        #if FLX_MOUSE
        FlxG.mouse.useSystemCursor = true;
        #end

        startGame();
    }

    function startGame() {
        FlxTransitionableState.skipNextTransIn = true;
        FlxTransitionableState.skipNextTransOut = true;

		FlxG.switchState(() -> new TitleState());
    }
}