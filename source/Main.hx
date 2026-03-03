package;

import flixel.FlxGame;
import funkin.InitState;
import funkin.system.logs.CrashHandler;
import funkin.ui.debug.DebugOverlay;
import haxe.io.Path;
import lime.system.System;
import openfl.Lib;
import openfl.display.Sprite;
#if android
import extension.androidtools.content.Context;
#end
#if hxvlc
import hxvlc.util.Handle;
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
		#if hxvlc
		Handle.init();
		#end

		#if (windows && cpp)
		funkin.utils.native.Windows.setWindowDarkMode(true);
		#end

		var game:FlxGame = new FlxGame(0, 0, InitState, 60, 60, true);
		addChild(game);

		debugOverlay = new DebugOverlay(0x484848);
		addChild(debugOverlay);
	}
}
