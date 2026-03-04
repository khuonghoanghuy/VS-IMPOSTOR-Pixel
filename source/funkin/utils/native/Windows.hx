package funkin.utils.native;

#if (windows && cpp)
/**
 * Code that can only be run on systems running Windows.
 */
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
	 * Toggles the window's dark mode.
	 * @param enable Whether to enable it or not.
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
	 * @return The game's Task Memory usage.
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
	 * @return The total amount of RAM the system has installed.
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
	 * @return The system's current language in the Language Code format (i.e. `en-US`).
	 */
	@:functionCode('
		LANGID lang_code = GetUserDefaultUILanguage();
		WCHAR lang_name[LOCALE_NAME_MAX_LENGTH];
		GetLocaleInfoEx(LOCALE_NAME_USER_DEFAULT, LOCALE_SNAME, lang_name, LOCALE_NAME_MAX_LENGTH);
		return lang_name;
	')
	public static function getSystemLanguage():String
	{
		return '';
	}

	/**
	 * Makes a pop-up appear with a custom warning or information.
	 *
	 * Documentation: https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-messagebox
	 *
	 * @param message		The message to display.
	 * @param title			The title of the pop-up.
	 * @param buttons		The types of buttons to show.
	 * @param icon			The icon to show in the pop-up, aka the severity of the pop-up.
	 */
	@:functionCode('
		MessageBox(GetActiveWindow(), message, title, buttons | icon);
	')
	public static function showMessageBoxPopUp(message:String, title:String, buttons:WindowsMessageBoxButtons = OK, icon:WindowsMessageBoxIcon = NOTICE) {}
}

/**
 * The types of buttons the message box pop-up can be interacted with.
 */
enum abstract WindowsMessageBoxButtons(Int)
{
	/**
	 * The pop-up will only have the button `OK`.
	 */
	var OK = 0x00000000;

	/**
	 * The pop-up will have the buttons `OK` and `Cancel`.
	 */
	var OK_CANCEL = 0x00000001;

	/**
	 * The pop-up will have the buttons `Retry` and `Cancel`.
	 */
	var RETRY_CANCEL = 0x00000005;

	/**
	 * The pop-up will have the buttons `Yes` and `No`.
	 */
	var YES_NO = 0x00000004;

	/**
	 * The pop-up will have the buttons `Yes`, `No` and `Cancel`.
	 */
	var YES_NO_CANCEL = 0x00000003;

	/**
	 * The pop-up will have the buttons `Abort`, `Retry` and `Ignore`.
	 */
	var ABORT_RETRY_IGNORE = 0x00000002;

	/**
	 * The pop-up will have the buttons `Cancel`, `Try Again` and `Continue`.
	 */
	var CANCEL_TRY_CONTINUE = 0x00000006;
}

/**
 * The types of icon the message box pop-up can display.
 */
enum abstract WindowsMessageBoxIcon(Int)
{
	/**
	 * https://learn.microsoft.com/en-us/windows/win32/api/winuser/images/mb_iconasterisk.png
	 */
	var NOTICE = 0x00000040;

	/**
	 * https://learn.microsoft.com/en-us/windows/win32/api/winuser/images/mb_iconexclamation.png
	 */
	var WARNING = 0x00000030;

	/**
	 * https://learn.microsoft.com/en-us/windows/win32/api/winuser/images/mb_iconquestion.png
	 */
	var QUESTION = 0x00000020;

	/**
	 * https://learn.microsoft.com/en-us/windows/win32/api/winuser/images/mb_iconhand.png
	 */
	var ERROR = 0x00000010;
}
#end
