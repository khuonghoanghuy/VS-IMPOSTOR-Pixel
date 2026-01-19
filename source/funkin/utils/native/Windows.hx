package funkin.utils.native;

#if (windows && cpp)
import cpp.ConstCharStar;

@:buildXml('
<target id="haxe">
    <lib name="dwmapi.lib"/>
</target>
')
@:cppFileCode('
// to prevent windows doing random shit and slowing things down
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#define NOCRYPT
#define NOKANJI
#define NOHELP

#include <iostream>
#include <string>
#include <windows.h>
#include <psapi.h>
#include <dwmapi.h>
#include <iomanip>
#include <stdint.h>
#include <stdio.h>
')
class Windows
{
	/**
	 * Sets the window to Dark Mode.
	 */
    @:functionCode('
        HWND window = GetActiveWindow();

        int darkMode = enable ? 1 : 0;

        if (DwmSetWindowAttribute(window, 20, &darkMode, sizeof(darkMode)) != S_OK)
            DwmSetWindowAttribute(window, 19, &darkMode, sizeof(darkMode));

        UpdateWindow(window);
    ')
    public static function setWindowDarkMode(enable:Bool) {}

	/**
	 * Gets the game's Task Memory usage.
	 * 
	 * Apparently the result isn't that accurate, but whatever.
	 */
    @:functionCode('
        PROCESS_MEMORY_COUNTERS_EX pmc;

        if (GetProcessMemoryInfo(GetCurrentProcess(), (PROCESS_MEMORY_COUNTERS*)&pmc, sizeof(pmc)))
            return pmc.WorkingSetSize;

        return 0;
    ')
    public static function getTaskProcessMemory():Float
    {
        return 0;
    }

	/**
	 * Gets the total amount of RAM the system has.
	 */
    @:functionCode('
        MEMORYSTATUSEX statusEx;
        statusEx.dwLength = sizeof(statusEx);

        if (GlobalMemoryStatusEx(&statusEx))
            return statusEx.ullTotalPhys;

        return 0;
    ')
    public static function getTotalSystemMemory():Float
    {
        return 0;
    }
	/**
	 * Returns the system's current language.
	 */
	@:functionCode('
        LANGID lang_code = GetUserDefaultUILanguage();
        WCHAR lang_name[LOCALE_NAME_MAX_LENGTH];
        GetLocaleInfoEx(LOCALE_NAME_USER_DEFAULT, LOCALE_SNAME, lang_name, LOCALE_NAME_MAX_LENGTH);
        return lang_name;
    ')
	public static function getSystemLanguage():String
	{
		return "";
	}

    /**
     * Makes a window appear with a custom message.
     */
    @:functionCode('
        MessageBox(GetActiveWindow(), message, title, buttons | icon);
    ')
    public static function showMessageBoxPopUp(message:String, title:String, buttons:WindowsMessageBoxButtons = OK, icon:WindowsMessageBoxIcon = NOTICE):Void {}
}

enum abstract WindowsMessageBoxButtons(Int)
{
    var OK = 0x00000000;
    var OK_CANCEL = 0x00000001;
    var RETRY_CANCEL = 0x00000005;
    var YES_NO = 0x00000004;
    var YES_NO_CANCEL = 0x00000003;
    var ABORT_RETRY_IGNORE = 0x00000002;
    var CANCEL_TRY_CONTINUE = 0x00000006;
}

enum abstract WindowsMessageBoxIcon(Int)
{
    var NOTICE = 0x00000040;
    var WARNING = 0x00000030;
    var QUESTION = 0x00000020;
    var ERROR = 0x00000010;
}
#end