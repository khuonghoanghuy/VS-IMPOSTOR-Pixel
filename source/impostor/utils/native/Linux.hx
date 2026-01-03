package impostor.utils.native;

#if linux
@:cppFileCode('
#include <string>
')
class Linux
{
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
}
#end