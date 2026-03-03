package funkin.sound;

import flixel.sound.FlxSound;
import flixel.system.FlxAssets.FlxSoundAsset;

import openfl.media.Sound;

class FunkinSound extends FlxSound
{
	public static function playMenuMusic(menuMusic:MenuMusic = MAIN_MENU, fade:Bool = true):FunkinSound
	{
		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
			{
				if (fade)
				{
					FlxG.sound.music.fadeIn(4, 0, 0.8);
				}
				FlxG.sound.music.resume();
			}

			return cast FlxG.sound.music;
		}
		else
		{
			var music:FunkinSound = playMusic(Paths.music(menuMusic), 0.8, {bpm: 102});

			if (fade)
			{
				music.fadeIn(4, 0, 0.8);
			}

			return music;
		}
	}

	public static function playMusic(musicAsset:FlxSoundAsset, ?volume:Float, ?params:MusicParams):FunkinSound
	{
		if (musicAsset == null)
			return null;

		var music:FunkinSound = new FunkinSound().loadStreamed(musicAsset, true);
		music.persist = true;
		music.volume = volume ?? 1;

		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.destroy();
		}

		FlxG.sound.music = music;
		music.play();

		if (params != null)
		{
			Conductor.start(params.bpm);
		}

		return music;
	}

	/**
	 * Pauses the currently playing background music.
	 */
	public static function pauseMusic()
	{
		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.pause();
			Conductor.pause();
		}
	}

	/**
	 * Resumes the paused background music.
	 */
	public static function resumeMusic()
	{
		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.resume();
			Conductor.resume();
		}
	}

	/**
	 * Stops the currently playing background music.
	 */
	public static function stopMusic()
	{
		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
			FlxG.sound.music.destroy();
			FlxG.sound.music = null;
			Conductor.reset();
		}
	}

	public function new()
	{
		super();
	}

	/*
		public function loadSound(soundAsset:FlxSoundAsset, looped:Bool = false, autoDestroy:Bool = true, ?onComplete:Void->Void):FunkinSound
		{
			if (soundAsset == null) return this;

			cleanup(true);

			if (Std.isOfType(soundAsset, Sound))
			{
				_sound = soundAsset;
			}
			else if (Std.isOfType(soundAsset, String))
			{
				if (Assets.exists(soundAsset, SOUND))
				{
					_sound = Assets.getMusic(soundAsset);
				}
			}

			return cast init(looped, autoDestroy, onComplete);
		}
	 */
	public function loadStreamed(musicAsset:FlxSoundAsset, looped:Bool = true, autoDestroy:Bool = false, ?onComplete:Void -> Void):FunkinSound
	{
		if (musicAsset == null)
			return this;

		cleanup(true);

		if (Std.isOfType(musicAsset, Sound))
		{
			_sound = musicAsset;
		}
		else if (Std.isOfType(musicAsset, String))
		{
			if (Assets.exists(musicAsset, MUSIC))
			{
				_sound = Assets.getMusic(musicAsset);
			}
		}

		return cast init(looped, autoDestroy, onComplete);
	}
}

enum abstract MenuMusic(String) from String to String
{
	var MAIN_MENU:String = "mainMenu";

	var OMINOUS:String = "ominousMenu";
}

typedef MusicParams =
{
	var bpm:Float;
	var ?stepsPerBeat:Int;
	var ?beatsPerMeasure:Int;
}
