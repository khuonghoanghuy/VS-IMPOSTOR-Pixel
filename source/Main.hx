package;

import impostor.InitState;
import impostor.system.FunkinGame;
import impostor.ui.debug.DebugOverlay;
import impostor.utils.TranslationUtil;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var debugOverlay:DebugOverlay;

	public function new()
	{
		super();
		startGameApp();
	}

	function startGameApp()
	{
		#if windows
		impostor.utils.native.Windows.setWindowDarkMode(true);
		#end

		var game:FunkinGame = new FunkinGame(0, 0, InitState, 60, 60, false);
		addChild(game);

		debugOverlay = new DebugOverlay(0x484848);
		addChild(debugOverlay);
		TranslationUtil.init();
	}
}