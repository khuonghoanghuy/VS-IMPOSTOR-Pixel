package flixel.input;

import flixel.math.FlxPoint;
import flixel.util.FlxDestroyUtil;

class FlxFlick
{
	public var flickThreshold:FlxPoint;

	public var maxVelocity:FlxPoint;

	/**
	 * Can be a mouse input or a touch ID.
	 */
	public var ID(default, null):Int;

	public var initialized:Bool = false;

	public var velocity(default, null):FlxPoint;

	public var drag(default, null):FlxPoint;

	public var flickLeft(get, never):Bool;

	public var flickRight(get, never):Bool;

	public var flickUp(get, never):Bool;

	public var flickDown(get, never):Bool;

	var _flickLeft:Bool;
	var _flickRight:Bool;
	var _flickUp:Bool;
	var _flickDown:Bool;
	var _curDistance:FlxPoint;

	public function new()
	{
		flickThreshold = FlxPoint.get(10, 10);
		maxVelocity = FlxPoint.get(100, 100);
	}

	public function initFlick(startingVel:FlxPoint, ?ID:Int, ?drag:FlxPoint)
	{
		if (initialized)
			return;

		this.ID = ID ?? -1;
		velocity = startingVel.clone();
		this.drag = drag != null ? drag.clone() : FlxPoint.get(700, 700);
		_curDistance = FlxPoint.get();

		initialized = true;
	}

	public function update(elapsed:Float)
	{
		if (!initialized)
			return;

		if (Math.abs(velocity.x) <= 1 && Math.abs(velocity.y) <= 1)
		{
			destroy();
			return;
		}

		updateMotion(elapsed);

		var modifiedDistance = _curDistance.x;

		if (Math.abs(velocity.x) >= flickThreshold.x)
		{
			if (modifiedDistance < 0)
				_flickLeft = true;
			else
				_flickRight = true;

			_curDistance.x = 0;
		}

		modifiedDistance = _curDistance.y;

		if (Math.abs(velocity.y) >= flickThreshold.y)
		{
			if (modifiedDistance < 0)
				_flickDown = true;
			else
				_flickUp = true;

			_curDistance.y = 0;
		}
	}

	function updateMotion(elapsed:Float)
	{
		var dpiScale = FlxG.stage.window.display.dpi / 160;
		dpiScale *= 3.5;

		var framerateAmp:Float = 60 / (FlxG.updateFramerate > 60 ? FlxG.updateFramerate : 60) - 0.05;
		if (framerateAmp > 0.45)
			framerateAmp = 0.45;

		var newVelocityX:Float = Math.min(velocity.x * 0.95, maxVelocity.x);
		var averageVelX:Float = 0.5 * (velocity.x + newVelocityX);
		velocity.x = newVelocityX;
		_curDistance.x += (averageVelX * elapsed) / framerateAmp / dpiScale;

		var newVelocityY:Float = Math.min(velocity.y * 0.95, maxVelocity.y);
		var averageVelY:Float = 0.5 * (velocity.y + newVelocityY);
		velocity.y = newVelocityY;
		_curDistance.y += (averageVelY * elapsed) / framerateAmp / dpiScale;
	}

	public function destroy()
	{
		velocity = FlxDestroyUtil.put(velocity);
		drag = FlxDestroyUtil.put(drag);
		_curDistance = FlxDestroyUtil.put(_curDistance);
		initialized = false;
	}

	function get_flickLeft():Bool
	{
		if (_flickLeft)
		{
			_flickLeft = false;
			return true;
		}
		return false;
	}

	function get_flickRight():Bool
	{
		if (_flickRight)
		{
			_flickRight = false;
			return true;
		}
		return false;
	}

	function get_flickUp():Bool
	{
		if (_flickUp)
		{
			_flickUp = false;
			return true;
		}
		return false;
	}

	function get_flickDown():Bool
	{
		if (_flickDown)
		{
			_flickDown = false;
			return true;
		}
		return false;
	}
}
