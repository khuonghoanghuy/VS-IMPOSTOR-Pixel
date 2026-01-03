package;

import impostor.InitState;
import impostor.system.FunkinGame;
import impostor.ui.debug.DebugOverlay;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var debugOverlay:DebugOverlay;

	public function new()
	{
		super();
		loadSaveData();
		startGameApp();
	}

	function loadSaveData() {}

	function startGameApp()
	{
		#if windows
		impostor.utils.native.Windows.setWindowDarkMode(true);
		#end

		var game:FunkinGame = new FunkinGame(0, 0, InitState, 60, 60, false);
		addChild(game);

		debugOverlay = new DebugOverlay(0x484848);
		addChild(debugOverlay);
	}
}