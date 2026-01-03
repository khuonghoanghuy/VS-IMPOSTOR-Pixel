package impostor.utils.native;

#if windows
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

#include <windows.h>
#include <psapi.h>
#include <dwmapi.h>
#include <stdint.h>
#include <stdio.h>
')
class Windows
{
    @:functionCode('
        HWND window = GetActiveWindow();

        int darkMode = enable ? 1 : 0;

        if (DwmSetWindowAttribute(window, 20, &darkMode, sizeof(darkMode)) != S_OK)
            DwmSetWindowAttribute(window, 19, &darkMode, sizeof(darkMode));

        UpdateWindow(window);
    ')
    public static function setWindowDarkMode(enable:Bool) {}

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
}
#end