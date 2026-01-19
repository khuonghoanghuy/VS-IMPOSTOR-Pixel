package funkin;

#if !macro
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import funkin.Defaults;
import funkin.Paths;
import funkin.api.DiscordClient;
import funkin.graphics.FunkinSprite;
import funkin.graphics.FunkinText;
import funkin.input.Pointer;
import funkin.sound.FunkinSound;
import funkin.system.Achievements;
import funkin.system.Conductor;
import funkin.system.Translations;
import funkin.ui.MusicBeatState;
import funkin.utils.MathUtil;
import funkin.utils.StringUtil;
import openfl.utils.Assets;

using StringTools;
#end