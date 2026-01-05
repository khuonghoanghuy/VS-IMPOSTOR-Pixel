package impostor.utils.native;

#if linux
@:cppFileCode('
#include <iostream>
#include <cstdlib>
#include <string>
')
class Linux
{
	/**
	 * Gets the total amount of RAM the system has.
	 */
    @:functionCode('
        std::string token:
        std::ifstream file("/proc/meminfo"):
        while (file >> token) {
            unsigned long mem;
            if (file >> mem)
                return mem;
        }
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
        return std::getenv("LANG").c_str();
    ')
	public static function getSystemLanguage():String
	{
		return "";
	}
}
#end