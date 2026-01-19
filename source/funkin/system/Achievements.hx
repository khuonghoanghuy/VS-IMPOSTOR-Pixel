package funkin.system;

import openfl.display.Sprite;

class Achievements
{
    /**
     * All loaded achievements.
     */
    public static var achievements(default, null):Map<String, Achievement>;

    /**
     * The list of unlocked achievements.
     */
    public static var achievementsUnlocked(default, null):Array<String> = [];

    static var _initialized:Bool = false;

    /**
     * Starts the Achievement backend.
     */
    @:allow(funkin.InitState)
    static function init()
    {
        achievements = new Map<String, Achievement>();

        _initialized = true;
        checkAchievements();
    }

    /**
     * Checks for achievements that are waiting to be unlocked.
     */
    @:allow(funkin.system.FunkinGame)
    static function checkAchievements()
    {
        if (!_initialized) return;

        for (id => achievement in achievements)
        {
            if (achievement.unlockCriteria != null && achievement.unlockCriteria())
            {}
        }
    }

    public static function exists(id:String):Bool
    {
        if (!_initialized) return false;
        return achievements.exists(id);
    }

    public static function isUnlocked(id:String):Bool
    {
        if (!_initialized) return false;
        return achievementsUnlocked.contains(id);
    }

    public static function addPoints(id:String, points:Int):Void
    {
        if (!_initialized) return;

        if (exists(id) && !isUnlocked(id))
        {
            var achievement:Achievement = achievements.get(id);
            if (achievement.points != null)
            {
                achievement.progress += points;
            }

            checkAchievements();
        }
    }

    public static function unlockAchievement(id:String):Void
    {
        if (!_initialized) return;
    }
}

private class Achievement
{
    public var ID(default, null):String;

    public var level(default, null):AchievementLevel;

    public var translationID(get, never):String;

    public var name(get, never):String;

    public var description(get, never):String;

    public var points(default, null):Null<Int> = null;

    public var progress:Int = 0;

    public var unlockCriteria:Void->Bool = null;

    public function new(id:String, level:AchievementLevel, unlockCriteria:Bool->Void, ?points:Int)
    {
        this.ID = id;
        this.level = level;
        this.points = points;
    }

    function get_translationID():String
    {
        return 'achievements.$ID';
    }

    function get_name():String
    {
        return '$translationID.name';
    }

    function get_description():String
    {
        return '$translationID.desc';
    }
}

enum abstract AchievementLevel(String) from String to String
{
    var BROZE:String = "bronze";
    var SILVER:String = "silver";
    var GOLD:String = "gold";
    var PLATINUM:String = "platinum";
}

private class AchievementPopUp extends Sprite
{
    public function new(achievement:Achievement)
    {
        super();
    }
}