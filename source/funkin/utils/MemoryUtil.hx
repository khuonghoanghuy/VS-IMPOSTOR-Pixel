package funkin.utils;

import EReg;
import openfl.display3D.Context3D;
import openfl.system.System;

#if (windows && cpp)
import funkin.utils.native.Windows;
#elseif linux
import funkin.utils.native.Linux;
#elseif (macos || ios)
import funkin.utils.native.Apple;
#end

#if cpp
import cpp.vm.Gc;
#end

class MemoryUtil
{
    /**
     * Returns the amount of RAM the system has.
     */
    public static function getSystemMemory():Float
    {
		#if (windows && cpp)
        return Windows.getTotalSystemMemory();
        #elseif linux
        return Linux.getTotalSystemMemory();
        #elseif (macos || ios)
        return Apple.getTotalSystemMemory();
        #else
        return 0;
        #end
    }

    /**
     * Returns the total amount of memory the application is using.
     */
    public static function getTaskMemory():Float
    {
        #if (windows && cpp)
        return Windows.getTaskProcessMemory();
        #elseif ((macos || ios) && cpp)
        return Apple.getTaskProcessMemory();
        #elseif (linux || android)
        try
        {
            #if cpp
            final input:sys.io.FileInput = sys.io.File.read('/proc/${cpp.NativeSys.sys_get_pid()}/status', false);
            #else
            final input:sys.io.FileInput = sys.io.File.read('/proc/self/status', false);
            #end

            final regex:EReg = ~/^VmRSS:\s+(\d+)\s+kB/m;
            var line:String;

            do
            {
                if (input.eof())
                {
                    input.close();
                    return 0;
                }
                line = input.readLine();
            }
            while (!regex.match(line));

            input.close();

            final kb:Float = Std.parseFloat(regex.matched(1));
            if (kb != Math.NaN)
            {
                return kb * 1024;
            }
        }
        catch(e:Dynamic) {}
        #end

        return 0;
    }

    /**
     * Returns the percentage of the amount of memory the application is using.
     */
    public static function getRAMUsage():Float
    {
        return getTaskMemory() / getSystemMemory();
    }

    /**
     * Returns the amount of memory Haxe is using.
     */
    public static function getGCMemory():Float
    {
        #if cpp
        return Gc.memInfo64(Gc.MEM_INFO_USAGE);
        #elseif sys
        return System.totalMemoryNumber;
        #else
        return 0;
        #end
    }

    public static function getGraphicsMemoryTotal():Int
    {
        return FlxG.stage.context3D.totalGPUMemory;
    }

    public static function getGraphicsMemoryUsage():Float
    {
        var vramBytes:Int = @:privateAccess FlxG.stage.context3D.gl.getParameter(Context3D.__glMemoryCurrentAvailable);
        return vramBytes;
    }

    public static function getVRAMUsage():Float
    {
        return getGraphicsMemoryUsage() / getGraphicsMemoryTotal();
    }
}