package funkin.system;

import flixel.FlxBasic;
import funkin.graphics.FunkinBitmapText;
import haxe.Json;
import haxe.io.Path;

#if windows
import funkin.utils.native.Windows;
#elseif linux
import funkin.utils.native.Linux;
#elseif android
import funkin.utils.native.Android;
#elseif web
import js.Browser;
#end

class Translations extends FlxBasic
{
	static var instance:Translations;

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
	@:allow(funkin.InitState)
    static function init()
    {
        languages = new Map<String, Language>();
        curLanguageID = Defaults.DEFAULT_LANGUAGE;

		for (language in Defaults.LANGUAGES)
        {
			if (Assets.exists(Paths.json('languages/$language')))
			{
				var langData:Language = Json.parse(Assets.getText(Paths.json('languages/$language')));
				languages.set(language, langData);
			}
        }
		FlxG.signals.focusGained.add(checkSystemLanguage);
		FlxG.signals.postStateSwitch.add(checkSystemLanguage);
    }

    /**
     * Gets the translation of a text with a translation ID.
     * 
     * @param id            The translation ID.
     * @param parameters    If the text has parameters that can be replaced with values.
     * @return The translated text.
     */
    public static function translate(id:String, ?parameters:Array<Dynamic>):String
    {
		if (languageExists(curLanguage, id))
        {
            return getText(curLanguage, id, parameters);
        }
		else if (languageExists(defaultLanguage, id))
        {
            return getText(defaultLanguage, id, parameters);
        }

        return id;
    }

    /**
     * Gets the translation of a text with a translation ID.
     * 
     * @param language      The language to use, must be the language's data.
     * @param id            The translation ID.
     * @param parameters    If the text has parameters that can be replaced with values.
     * @return The translated text.
     */
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

    /**
     * Checks if the specified translation ID exists in a language.
     * 
     * @param language  The language to check.
     * @param id        The translation ID to find.
     */
	public static function languageExists(language:Language, id:String):Bool
    {
        return get(language, id) != null;
    }

    /**
     * Gets the system's current language.
     */
    public static function getSystemLanguage():String
    {
		#if (windows && cpp)
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

    /**
     * Returns the language's codename without it's global location.
     * 
     * @param language  The language.
     */
    public static function getLanguageShort(language:String):String
    {
        if (language.contains("-"))
            return language.split("-")[0];
		else if (language.contains("_"))
			return language.split("_")[0];
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

	public function new()
	{
		super();
		instance = this;
	}

	static function checkSystemLanguage()
	{
		var systemLanguage:String = Translations.getLanguageShort(Translations.getSystemLanguage());
		if (systemLanguage != Translations.curLanguageID)
		{
			curLanguageID = systemLanguage;
		}
	}

	/**
	 * Updates all text objects whenever the language changes.
	 */
	@:access(flixel.group.FlxTypedGroup)
	static function updateLanguage()
	{
		function updateTextObjects(group:FlxGroup)
		{
			for (member in group.members)
			{
				if (Std.isOfType(member, FunkinText))
				{
					var text:FunkinText = cast(member, FunkinText);
					if (text.translationData != null)
						text.text = "";
				}
				if (Std.isOfType(member, FunkinBitmapText))
				{
					var bitmapText:FunkinBitmapText = cast(member, FunkinBitmapText);
					if (bitmapText.translationData != null)
						bitmapText.text = "";
				}

				var group = FlxTypedGroup.resolveGroup(member);
				if (group != null)
				{
					updateTextObjects(group);
				}
			}
		}

		updateTextObjects(FlxG.state);

		if (Std.isOfType(FlxG.state, MusicBeatState))
			cast(FlxG.state, MusicBeatState).onLanguageUpdate(Translations.curLanguageID);
	}

    static function set_curLanguageID(language:String):String
    {
        if (languages.exists(language))
        {
            curLanguageID = language;
			updateLanguage();
        }
        else
        {
            curLanguageID = Defaults.DEFAULT_LANGUAGE;
			updateLanguage();
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
		return languages.get(Defaults.DEFAULT_LANGUAGE) ?? {name: "Unknown", data: {}};
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