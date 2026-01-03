package impostor;

final class Defaults
{
	public static final TITLE:String = "VS IMPOSTOR Pixel";

	public static var VERSION(get, never):String;

	static function get_VERSION():String
	{
		return FlxG.stage.application.meta.get("version");
	}

	/**
	 * Whether the build is compiled as debug or release.
	 */
	public static final DEBUG_BUILD:Bool = #if debug true #else false #end;

	public static final DEFAULT_FONT:String = "Pixeloid Sans Bold";

	/**
	 * The default animation name to add or play for all sprites.
	 */
	public static final DEFAULT_ANIMATION_NAME:String = 'anim';

	/**
	 * The chance for shooting stars to spawn each frame.
	 */
	public static final SHOOTING_STAR_SPAWN_CHANCE:Float = 0.01;

	/**
	 * The default shooting star launch speed.
	 */
	public static final DEFAULT_SHOOTING_STAR_SPEED:Float = 2000;

	/**
	 * The default shooting star minimum launch angle.
	 * 
	 * Right    = 0 Degrees.
	 * 
	 * Down     = 90 Degrees.
	 * 
	 * Left     = 180 Degrees.
	 * 
	 * Up       = 270 Degrees.
	 */
	public static final DEFAULT_SHOOTING_STAR_LAUNCH_ANGLE_MIN:Float = 10;

	/**
	 * The default shooting star maximum launch angle.
	 * 
	 * Right    = 0 Degrees.
	 * 
	 * Down     = 90 Degrees.
	 * 
	 * Left     = 180 Degrees.
	 * 
	 * Up       = 270 Degrees.
	 */
	public static final DEFAULT_SHOOTING_STAR_LAUNCH_ANGLE_MAX:Float = 45;

	/**
	 * The default animation name to play for `Character`s.
	 */
	public static final DEFAULT_CHARACTER_ANIMATION:String = 'idle';

	/**
	 * The default beats per minute.
	 */
    public static final DEFAULT_BPM:Float = 100;
}