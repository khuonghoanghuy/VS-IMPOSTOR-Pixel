package impostor;

#if !macro
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import impostor.Defaults;
import impostor.Paths;
import impostor.api.DiscordClient;
import impostor.graphics.FunkinSprite;
import impostor.graphics.FunkinText;
import impostor.sound.FunkinSound;
import impostor.system.Conductor;
import impostor.ui.MusicBeatState;
import impostor.utils.MathUtil;
import impostor.utils.StringUtil;
import openfl.utils.Assets;

using StringTools;
#end