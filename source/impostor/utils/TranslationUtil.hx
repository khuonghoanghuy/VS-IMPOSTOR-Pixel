package impostor.utils;

import haxe.Json;
import haxe.io.Path;
import impostor.system.FunkinGame;
import json2object.JsonParser;

#if windows
import impostor.utils.native.Windows;
#elseif linux
import impostor.utils.native.Linux;
#elseif android
import impostor.utils.native.Android;
#elseif web
import js.Browser;
#end

class TranslationUtil
{
    /**
     * All loaded languages.
     */
    public static var languages(default, null):Map<String, Language>;

    /**
     * The current loaded language.
     */
    public static var curLanguageID(default, set):String;

    /**
     * The current loaded language's data.
     */
    public static var curLanguage(get, never):Language;

    /**
     * The current loaded language's name.
     */
    public static var curLanguageName(get, never):String;

    /**
     * The default language's data.
     */
    static var defaultLanguage(get, never):Language;

    /**
     * Starts the Translation backend.
     */
    @:allow(Main)
    static function init()
    {
        languages = new Map<String, Language>();
        curLanguageID = Defaults.DEFAULT_LANGUAGE;

        for (file in Paths.getFolderContents('data/languages'))
        {
            if (Path.extension(file) == "json")
            {
                var fileNoExt:String = Path.withoutExtension(file);
                var langData:Language = Json.parse(Assets.getText(Paths.json('languages/$fileNoExt')));
                languages.set(fileNoExt, langData);
            }
        }
    }

    public static function translate(id:String, ?parameters:Array<Dynamic>):String
    {
        if (exists(curLanguage, id))
        {
            return getText(curLanguage, id, parameters);
        }
        else if (exists(defaultLanguage, id))
        {
            return getText(defaultLanguage, id, parameters);
        }

        return id;
    }

    public static function getText(language:Language, id:String, ?parameters:Array<Dynamic>):String
    {
        var text:String = get(language, id);
        var regex:EReg = ~/{[0-9]}/g;

        var result:String = regex.map(text, function(reg:EReg) {
            var match:String = regex.matched(0);
            match = match.substr(match.length - 1, match.length).substr(0, 1);
            return parameters[Std.parseInt(match)];
        });

        return result;
    }

    public static function exists(language:Language, id:String):Bool
    {
        return get(language, id) != null;
    }

    /**
     * Gets the system's current language.
     */
    public static function getSystemLanguage():String
    {
        #if windows
        return Windows.getSystemLanguage();
        #elseif linux
        return Linux.getSystemLanguage();
        #elseif (macos || ios)
        return Apple.getSystemLanguage();
        #elseif android
        return Android.getSystemLanguage();
        #elseif web
        return Browser.navigator.language;
        #else
        return "Unknown";
        #end
    }

    public static function getLanguageShort(language:String):String
    {
        if (language.contains("-"))
            return language.split("-")[0];
        else
            return language;
    }

    static function get(language:Language, id:String):Null<String>
    {
        var parts:Array<String> = [];

        if (id.contains("."))
            parts = id.split(".");
        else
            parts = [id];

        var lastIndex:Int = parts.length - 1;

        var result:Null<String> = null;
        var curLevel:Dynamic = language.data;
        for (i => part in parts)
        {
            if (Reflect.hasField(curLevel, part))
            {
                if (i == lastIndex)
                    result = Reflect.getProperty(curLevel, part);
                else
                    curLevel = Reflect.getProperty(curLevel, part);
            }
        }

        return result;
    }

    static function set_curLanguageID(language:String):String
    {
        if (languages.exists(language))
        {
            curLanguageID = language;
            cast(FlxG.game, FunkinGame).updateLanguage();
        }
        else
        {
            curLanguageID = Defaults.DEFAULT_LANGUAGE;
            cast(FlxG.game, FunkinGame).updateLanguage();
        }

        return language;
    }

    static function get_curLanguage():Language
    {
        return languages.get(curLanguageID) ?? defaultLanguage;
    }

    static function get_curLanguageName():String
    {
        return curLanguage.name;
    }

    static function get_defaultLanguage():Language
    {
        return languages.get(Defaults.DEFAULT_LANGUAGE);
    }
}

typedef TranslationData = {
    var id:String;

    var ?parameters:Array<Dynamic>;
}

typedef Language =
{
    var name:String;

    var data:Dynamic;
}

/*
typedef LanguageData =
{
    var common:CommonTranslationData;

    var time:TimeTranslationData;

    var generic:GenericTranslationData;

    var titleScreen:TitleScreenTranslationData;
}

typedef CommonTranslationData =
{
    @:default("Version {0}")
    var version:String;

    @:default("No")
    var no:String;

    @:default("Yes")
    var yes:String;
}

typedef TimeTranslationData =
{
    @:default("January")
    var january:String;

    @:default("February")
    var february:String;

    @:default("March")
    var march:String;

    @:default("April")
    var april:String;

    @:default("May")
    var may:String;

    @:default("June")
    var june:String;

    @:default("July")
    var july:String;

    @:default("August")
    var august:String;

    @:default("September")
    var september:String;

    @:default("October")
    var october:String;

    @:default("November")
    var november:String;

    @:default("December")
    var december:String;
}

typedef GenericTranslationData =
{
    @:default("Play")
    var play:String;

    @:default("Start")
    var start:String;

    @:default("Freeplay")
    var freeplay:String;

    @:default("Achievements")
    var achievements:String;

    @:default("Shop")
    var shop:String;

    @:default("Options")
    var options:String;

    @:default("Extras")
    var extras:String;

    @:default("Credits")
    var credits:String;

    @:default("Exit")
    var exit:String;
}

typedef TitleScreenTranslationData =
{
    var pressStart:PressStartTranslationData;
}

typedef PressStartTranslationData =
{
    @:default("Press {0} to Play")
    var press:String;

    @:default("Click the Mouse to Play")
    var mouse:String;

    @:default("Touch the Screen to Play")
    var touch:String;
}
*/