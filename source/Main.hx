package;

import funkin.InitState;
import funkin.system.FunkinGame;
import funkin.system.logs.CrashHandler;
import funkin.ui.debug.DebugOverlay;
import haxe.io.Path;
import lime.system.System;
import openfl.Lib;
import openfl.display.Sprite;

#if android
import extension.androidtools.content.Context;
#end

class Main extends Sprite
{
	public static var debugOverlay:DebugOverlay;

	public function new()
	{
		super();

		#if android
		Sys.setCwd(Path.addTrailingSlash(Context.getExternalFilesDir()));
		#elseif ios
		Sys.setCwd(Path.addTrailingSlash(System.documentsDirectory));
		#end

		CrashHandler.init();

		#if windows
		funkin.utils.native.Windows.setWindowDarkMode(true);
		#end

		var game:FunkinGame = new FunkinGame(0, 0, InitState, 60, 60, false);
		addChild(game);

		debugOverlay = new DebugOverlay(0x484848);
		addChild(debugOverlay);
	}
}