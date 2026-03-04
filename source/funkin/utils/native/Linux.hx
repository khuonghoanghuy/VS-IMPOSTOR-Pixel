package funkin.utils.native;

#if linux
/**
 * Code that can only be run on systems running Linux distros.
 */
@:cppFileCode('
#include <iostream>
#include <cstdlib>
#include <string>
')
class Linux
{
	/**
	 * @return The total amount of RAM the system has installed.
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
	 * @return The system's current language in the Language Code format (i.e. `en-US`).
	 */
	@:functionCode('
		return std::getenv("LANG").c_str();
	')
	public static function getSystemLanguage():String
	{
		return '';
	}
}
#end
