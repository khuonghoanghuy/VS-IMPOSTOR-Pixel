package funkin.utils.native;

#if (macos || ios)
/**
 * Code that can only be run on systems running operating systems from Apple (like OS X or iOS).
 */
@:cppFileCode('
#include <iostream>
#include <string>
#include <mach/mach.h>
#include <sys/sysctl.h>
#include <sys/types.h>
#include <CoreFoundation/CoreFoundation.h>
')
class Apple
{
	/**
	 * @return The game's Task Memory usage.
	 */
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

	/**
	 * @return The total amount of RAM the system has installed.
	 */
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

	/**
	 * @return The system's current language in the Language Code format (i.e. `en-US`).
	 */
	@:functionCode('
        std::string language_code;

        CFLocaleRef currentLocale = CFLocaleCopyCurrent();
        CFStringRef languageCodeRef = (CFStringRef)CFLocaleGetValue(currentLocale, kCFLocaleLanguageCode);

        if (languageCodeRef)
        {
            const char* cStringPtr = CFStringGetCStringPtr(languageCodeRef, kCFStringEncodingUTF8);
            if (cStringPtr)
                language_code = cStringPtr;
            else {
                CFIndex length = CFStringGetLength(languageCodeRef);
                CFIndex maxSize = CFStringGetMaximumSizeForEncoding(length, kCFStringEncodingUTF8);
                char* buffer = (char*)malloc(maxSize);
                if (buffer && CFStringGetCString(languageCodeRef, buffer, maxSize, kCFStringEncodingUTF8))
                    language_code = buffer;

                free(buffer);
            }
        }

        if (currentLocale)
            CFRelease(currentLocale);

        return language_code.c_str();
    ')
	public static function getSystemLanguage():String
	{
		return '';
	}
}
#end
