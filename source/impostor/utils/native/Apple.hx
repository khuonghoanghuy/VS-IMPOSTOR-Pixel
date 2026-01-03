package impostor.utils.native;

#if (macos || ios)
@:cppFileCode('
#include <mach/mach.h>
#include <sys/sysctl.h>
#include <sys/types.h>
')
class Apple
{
    @:functionCode('
        struct task_basic_info info;

        mach_msg_type_number_t count = TASK_BASIC_INFO_COUNT;

        if (task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &count) != KERN_SUCCESS)
            return 0;
        
        return info.resident_size;
    ')
    public static function getTaskProcessMemory():Float
    {
        return 0;
    }

    @:functionCode('
        int mib[2];
        int64_t physical_memory;
        size_t length;

        mib[0] = CTL_HW;
        mib[1] = HW_MEMSIZE;

        if (sysctl(mib, 2, &physical_memory, &length, NULL, 0) == 0)
            return static_cast<double>(physical_memory);

        return 0;
    ')
    public static function getTotalSystemMemory():Float
    {
        return 0;
    }
}
#end