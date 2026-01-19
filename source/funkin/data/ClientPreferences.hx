package funkin.data;

import lime.system.System;
import openfl.display.StageQuality;

class ClientPreferences
{
    /**
     * Whether the user has seen the warning screen that shows when starting the mod for the first time.
     */
    public static var seenWarning:Bool = false;

    public static var gameQuality(default, null):StageQuality = HIGH;

    public static var framerate(get, set):Int;

    public static var sentitiveContent:Bool = true;

    public static var flashingLights:Bool = true;

    public static var storySequence:Int = 0;

    public static var downScroll:Bool = false;

    public static var middleScroll:Bool = false;

    public static var hapticsIntensity:Float = 0.5;

    /**
     * Whether to show a time bar when playing, showing the progress of the song.
     */
    public static var timeBar:Bool = true;

    /**
     * If transitions between menus should play faster.
     */
    public static var fastTransitions:Bool = false;

    /**
     * Whether to allow the system to go to sleep (aka. shut itself down) on mobile devices.
     */
    public static var screenTimeout(get, set):Bool;

    static function get_framerate():Int
    {
        #if web
        return 60;
        #elseif mobile
        var refreshRate:Int = FlxG.stage.window.displayMode.refreshRate;
        if (refreshRate < 60) refreshRate = 60;
        return refreshRate;
        #else
        return 60;
        #end
    }

    static function set_framerate(value:Int):Int
    {
        FlxG.updateFramerate = FlxG.drawFramerate = value;
        return value;
    }

    static function get_screenTimeout():Bool
    {
        #if !mobile
        return false;
        #else
        return System.allowScreenTimeout;
        #end
    }

    static function set_screenTimeout(value:Bool):Bool
    {
        #if !mobile
        return false;
        #else
        return System.allowScreenTimeout = value;
        #end
    }
}