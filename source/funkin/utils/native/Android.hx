package funkin.utils.native;

#if android
import lime.system.JNI;

class Android
{
    /**
	 * Returns the system's current language.
	 */
    public static function getSystemLanguage():String
    {
        var getLanguageJNI:Null<Dynamic> = JNI.createStaticMethod('java/util/Locale', 'getLanguage', 'V(C)');

        if (getLanguageJNI != null)
            return getLanguageJNI();

        return "";
    }
}
#end