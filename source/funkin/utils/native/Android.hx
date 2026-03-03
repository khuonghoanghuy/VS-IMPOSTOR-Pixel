package funkin.utils.native;

#if android
import extension.androidtools.jni.JNICache;

/**
 * Code that can only be run on systems running Android.
 */
class Android
{
	/**
	 * Gets the system's current language.
	 * @return The system's current language in the Language Code format (i.e. `en-US`).
	 */
	public static function getSystemLanguage():String
	{
		try
		{
			var getDefaultLocale:Null<Dynamic> = JNICache.createStaticMethod('java/util/Locale', 'getDefault', '()Ljava/util/Locale;');

			if (getDefaultLocale != null)
			{
				var locale = getDefaultLocale();

				var getLanguage:Null<Dynamic> = JNICache.createMemberMethod('java/util/Locale', 'getLanguage', '()Ljava/lang/String;');

				if (getLanguage != null)
				{
					return getLanguage(locale);
				}
			}
		}
		catch (e:Dynamic) {}

		return '';
	}
}
#end
