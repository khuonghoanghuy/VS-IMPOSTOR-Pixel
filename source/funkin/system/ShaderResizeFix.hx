package funkin.system;

import openfl.display.Sprite;

final class ShaderResizeFix
{
	@:allow(funkin.InitState)
	static function init()
	{
		FlxG.signals.gameResized.add((w:Int, h:Int) -> fixAllSprites());
	}

	static function fixAllSprites()
	{
		removeCacheFromSprite(FlxG.game);

		for (camera in FlxG.cameras.list)
		{
			if (camera != null && (camera.filters != null && camera.filters.length > 0))
			{
				removeCacheFromSprite(camera.flashSprite);
			}
		}
	}

	static function removeCacheFromSprite(sprite:Sprite)
	{
		if (sprite == null)
		{
			return;
		}

		@:privateAccess {
			sprite.__cacheBitmap = null;
			sprite.__cacheBitmapData = null;
			sprite.__cacheBitmapData2 = null;
			sprite.__cacheBitmapData3 = null;
			sprite.__cacheBitmapColorTransform = null;
		}
	}
}
