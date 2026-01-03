package impostor.utils;

import flixel.math.FlxPoint;
import flixel.util.typeLimit.OneOfTwo;
import openfl.geom.Point;

class MathUtil
{
    /**
     * Gets the distance between 2 integers.
     * 
     * @param intA The main integer.
     * @param intB The other integer.
     */
    public static function distanceBetweenIntegers(intA:Int, intB:Int):Int
    {
        return intB - intA;
    }

    /**
     * Gets the distance between 2 floats.
     * 
     * @param floatA The main float.
     * @param floatB The other float.
     */
    public static function distanceBetweenFloats(floatA:Float, floatB:Float):Float
    {
        return floatB - floatA;
    }

    /**
     * Gets the distance between 2 points (from the class `openfl.geom.Point`).
     * 
     * @param pointA The main point.
     * @param pointB The other point.
     */
    public static function distanceBetweenPoints(pointA:Point, pointB:Point):Float
    {
        var dx:Float = pointB.x - pointA.x;
        var dy:Float = pointB.y - pointA.y;
        return FlxMath.vectorLength(dx, dy);
    }

    /**
     * Bounds a value.
     * 
     * @param value The value to bound.
     * @param min The minimum allowed value.
     * @param max The maximum allowed value.
     */
    public static function clamp(value:Float, min:Float, max:Float):Float
    {
        return Math.max(min, Math.min(max, value));
    }
}