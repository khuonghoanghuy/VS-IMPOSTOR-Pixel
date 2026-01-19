package funkin.input;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.input.FlxPointer;
import flixel.input.FlxSwipe;
import flixel.input.mouse.FlxMouse;
import flixel.input.touch.FlxTouch;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.typeLimit.OneOfTwo;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

class Pointer
{
    /**
	 * The `MouseCursor` Mode the `Mouse` is currently at.
     */
    public static var cursor(get, set):MouseCursor;

    /**
     * Check if the `pointer` just moved.
     */
	public static var justMoved(get, never):Bool;

	/**
     * Check if the `pointer` just moved.
     */
	public static var justMovedLeft(get, never):Bool;

	/**
     * Check if the `pointer` just moved.
     */
	public static var justMovedRight(get, never):Bool;

	/**
     * Check if the `pointer` just moved.
     */
	public static var justMovedUp(get, never):Bool;

	/**
     * Check if the `pointer` just moved.
     */
	public static var justMovedDown(get, never):Bool;

	/**
	 * Check if the `pointer` has just been pressed.
	 */
	public static var justPressed(get, never):Bool;

	/**
	 * Check if the `pointer` is currently being held.
	 */
	public static var pressed(get, never):Bool;

	/**
	 * Check if the `pointer` just stopped being pressed.
	 */
	public static var justReleased(get, never):Bool;

    /**
     * Check if the `pointer` is swipping to the left.
     */
	public static var justSwipedLeft(get, never):Bool;

	/**
	 * Check if the `pointer` is swipping to the right.
	 */
	public static var justSwipedRight(get, never):Bool;

	/**
	 * Check if the `pointer` is swipping to the up.
	 */
	public static var justSwipedUp(get, never):Bool;

	/**
	 * Check if the `pointer` is swipping to the down.
	 */
	public static var justSwipedDown(get, never):Bool;

	/**
	 * Check if the `pointer` is swipping to any direction.
	 */
	public static var justSwipedAny(get, never):Bool;

	/**
	 * Check if the `pointer` flicked in the left direction.
	 */
	public static var flickLeft(get, never):Bool;

	/**
	 * Check if the `pointer` flicked in the right direction.
	 */
	public static var flickRight(get, never):Bool;

	/**
	 * Check if the `pointer` flicked upwards.
	 */
	public static var flickUp(get, never):Bool;

	/**
	 * Check if the `pointer` flicked downwards.
	 */
	public static var flickDown(get, never):Bool;

	/**
	 * Check if the `pointer` flick in any direction.
	 */
	public static var flickAny(get, never):Bool;

	/**
	 * The `Pointer` this device is using.
	 * 
	 * Can be either `FlxMouse` or a `FlxTouch`, depending on what device you're playing.
	 */
	public static var pointer(get, never):Dynamic;

    static var mouse(get, never):FlxMouse;

    inline static function get_mouse():FlxMouse
        return FlxG.mouse;

    static var touch(get, never):FlxTouch;

    static function get_touch():FlxTouch
    {
        for (touch in FlxG.touches.list)
		{
            if (touch != null) return touch;
        }
        return FlxG.touches.getFirst();
    }

	public static function isDoingAnything()
    {
		return justMoved || justPressed || pressed || justReleased || justSwipedAny || flickAny;
    }

	public static function destroy()
    {
		resetSwipeVelocity();
	}

	public static function resetSwipeVelocity()
    {
		if (FlxG.onMobile)
			FlxG.touches.flickManager.destroy();
		else
			pointer.flickManager.destroy();
	}

    /**
     * Checks if the `pointer` is overlapping with the specified object or group.
	 * @param objectOrGroup The object or group to check the overlap.
     * @param camera The `FlxCamera` to check the overlap.
     * @return Whether the `pointer` is overlapping the object or not.
     */
    @:access(flixel.group.FlxTypedGroup)
	public static function overlaps(objectOrGroup:FlxBasic, ?camera:FlxCamera):Bool
    {
		if (pointer == null) return false;
		if (camera == null) camera = objectOrGroup.cameras[0];

		var group = FlxTypedGroup.resolveGroup(objectOrGroup);
		if (group != null) {
			return group.any(function(obj) {
				return pointer.overlaps(obj, camera);
			});
        }

		return pointer.overlaps(objectOrGroup, camera);
    }

	/**
	 * Checks if the `pointer` is overlapping with the specified object or group, this function is more precise than the other one.
	 * @param objectOrGroup The object or group to check the overlap.
	 * @param camera The `FlxCamera` to check the overlap.
	 * @return Whether the `pointer` is overlapping the object or not.
	 */
    @:access(flixel.group.FlxTypedGroup)
	public static function overlapsComplex(objectOrGroup:FlxBasic, ?camera:FlxCamera):Bool
    {
		if (pointer == null) return false;
		if (camera == null) camera = objectOrGroup.cameras[0];

		function checkOverlap(object:FlxObject, camera:FlxCamera):Bool {
			return @:privateAccess object.overlapsPoint(pointer.getWorldPosition(camera, object._point), true, camera);
		}

		var group = FlxTypedGroup.resolveGroup(objectOrGroup);
		if (group != null) {
			return group.any(function(obj) return checkOverlap(cast(obj, FlxObject), camera));
		}

		return checkOverlap(cast(objectOrGroup, FlxObject), camera);
	}

	public static function pressAction(objectOrGroup:FlxBasic, ?camera:FlxCamera, usePreciseOverlap:Bool = false):Bool
    {
		if (pointer == null) return false;
		if (camera == null) camera = objectOrGroup.cameras[0];

		var overlap:Bool = usePreciseOverlap ? overlapsComplex(objectOrGroup, camera) : overlaps(objectOrGroup, camera);
		return overlap && justReleased;
	}

    /**
     * Checks if the `pointer` is inside a rectangle.
     * @param rect The `FlxRect` to check.
	 * @return Whether the `pointer` is inside the rectangle or not.
     */
	public static function isWithinBounds(rect:FlxRect):Bool
    {
        if (pointer == null) return false;

        return rect.containsPoint(pointer.getPosition());
    }

	public static function getWorldPosition(?camera:FlxCamera, ?result:FlxPoint):FlxPoint
	{
		if (pointer == null) return FlxPoint.get();

		return pointer.getWorldPosition(camera, result);
	}

	/**
	 * Drags an object around until you stop holding it.
	 * @param object The `FlxObject` to drag.
	 */
	public static function dragObject(object:FlxObject):Void
    {
		if (pressed && overlaps(object)) {
			object.x = pointer.viewX - (object.width / 2);
			object.y = pointer.viewY - (object.height / 2);
		}
	}

    static function set_cursor(value:MouseCursor):MouseCursor
    {
		return Mouse.cursor = value;
	}

	static function get_cursor():MouseCursor
	{
        return Mouse.cursor;
    }

	static function get_pointer():OneOfTwo<FlxMouse, FlxTouch>
	{
		if (FlxG.onMobile)
        	return touch;
        else
        	return mouse;
    }

	inline static function get_justMoved():Bool
        return pointer.justMoved;

	inline static function get_justMovedLeft():Bool
        return pointer.justMovedLeft;

	inline static function get_justMovedRight():Bool
        return pointer.justMovedRight;

	inline static function get_justMovedUp():Bool
        return pointer.justMovedUp;

	inline static function get_justMovedDown():Bool
        return pointer.justMovedDown;

	inline static function get_justPressed():Bool
        return pointer.justPressed;

	inline static function get_pressed():Bool
        return pointer.pressed;

	inline static function get_justReleased():Bool
        return pointer.justReleased;

	static function get_justSwipedLeft():Bool
    {
		final swipe:FlxSwipe = (FlxG.swipes.length > 0) ? FlxG.swipes[0] : null;
		return (swipe?.degrees > 135) && (swipe?.degrees < -135) && (swipe?.distance > 20);
	}

	static function get_justSwipedRight():Bool
    {
		final swipe:FlxSwipe = (FlxG.swipes.length > 0) ? FlxG.swipes[0] : null;
		return (swipe?.degrees > -45) && (swipe?.degrees < 45) && (swipe?.distance > 20);
	}

	static function get_justSwipedUp():Bool
    {
		final swipe:FlxSwipe = (FlxG.swipes.length > 0) ? FlxG.swipes[0] : null;
		return (swipe?.degrees > 45) && (swipe?.degrees < 135) && (swipe?.distance > 20);
	}

	static function get_justSwipedDown():Bool
    {
		final swipe:FlxSwipe = (FlxG.swipes.length > 0) ? FlxG.swipes[0] : null;
		return (swipe?.degrees > -135) && (swipe?.degrees < -45) && (swipe?.distance > 20);
	}

	static function get_justSwipedAny():Bool
	{
        return justSwipedLeft || justSwipedRight || justSwipedUp || justSwipedDown;
    }

	static function get_flickLeft():Bool
	{
		if (FlxG.onMobile)
			return FlxG.touches.flickManager.flickLeft;
		else
        	return pointer.flickManager.flickLeft;
    }

	static function get_flickRight():Bool
	{
		if (FlxG.onMobile)
			return FlxG.touches.flickManager.flickRight;
		else
        	return pointer.flickManager.flickRight;
    }

	static function get_flickUp():Bool
	{
		if (FlxG.onMobile)
			return FlxG.touches.flickManager.flickUp;
		else
        	return pointer.flickManager.flickUp;
    }

	static function get_flickDown():Bool
	{
		if (FlxG.onMobile)
			return FlxG.touches.flickManager.flickDown;
		else
        	return pointer.flickManager.flickDown;
    }

	static function get_flickAny():Bool
	{
        return flickLeft || flickRight || flickUp || flickDown;
    }
}