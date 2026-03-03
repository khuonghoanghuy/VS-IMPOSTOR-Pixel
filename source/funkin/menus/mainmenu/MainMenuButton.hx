package funkin.menus.mainmenu;

import flixel.FlxSprite;

class MainMenuButton extends FlxTypedSpriteGroup<FlxSprite>
{
	public var button(default, null):FunkinSprite;

	public var label(default, null):FunkinText;

	public var icon(default, null):FunkinSprite;

	public var type(default, null):MainMenuButtonType;

	public var available(default, set):Bool;

	public var hovered(default, null):Bool = false;

	@:allow(funkin.menus.mainmenu.MainMenuState)
	var _position:Int = 0;
	var _idleColor:FlxColor;
	var _hoverColor:FlxColor;

	public function new(index:Int, x:Float = 0, y:Float = 0, data:MainMenuButtonsData, scale:Float = 5)
	{
		super(x, y, 3);

		_position = index;

		type = data.type;

		var colors:Array<FlxColor> = getSelectionColorsFromType(type);
		_idleColor = colors[0];
		_hoverColor = colors[1];

		var buttonDimentions:Array<Int> = getDimentionsFromType(type);
		button = new FunkinSprite().loadGraphic(getImageFromType(type), true, buttonDimentions[0], buttonDimentions[1]);
		button.addAnimationByFrameList('idle', [0], 0);
		button.addAnimationByFrameList('hover', [1], 0);
		button.addAnimationByFrameList('locked', [2], 0);
		button.scaleSprite(scale);
		add(button);

		var labelPosition:Float = 4 * scale;
		label = new FunkinText(labelPosition, button.height / 2, button.width - labelPosition * 2, '', getTextSizeFromType(type));
		label.translationData = {id: data.translationID};
		label.color = _idleColor;
		label.alignment = RIGHT;
		label.y -= label.height / 2;
		add(label);

		icon = new FunkinSprite(8 * scale);
		add(icon);

		if (data.icon != null)
		{
			icon.loadGraphic(data.icon);
			icon.scaleSprite(scale);

			if (data.iconOffsets != null)
			{
				icon.x -= data.iconOffsets[0] * scale;
				icon.y += data.iconOffsets[1] * scale;
			}
		}
		else
		{
			icon.visible = false;
		}

		available = data.available;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function checkPosition(position:Int)
	{
		if (available)
		{
			if (position == _position)
				hover();
			else
				idle();
		}
	}

	function idle()
	{
		button.playAnimation('idle');
		label.color = _idleColor;

		hovered = false;
	}

	function hover()
	{
		button.playAnimation('hover');
		label.color = _hoverColor;

		hovered = true;
	}

	function getSelectionColorsFromType(type:MainMenuButtonType):Array<FlxColor>
	{
		return switch (type)
		{
			case MAIN: [0xFF0A3C33, 0xFF105848];
			case EXTRA: [0xFFAAE2DC, 0xFFFFFFFF];
			case OTHER: [0xFFFFFFFF, 0xFFFFFFFF];
		};
	}

	function getImageFromType(type:MainMenuButtonType):String
	{
		return switch (type)
		{
			case MAIN: Paths.image('menus/mainmenu/mainButton');
			case EXTRA: Paths.image('menus/mainmenu/extraButton');
			case OTHER: Paths.image('menus/mainmenu/otherButton');
		};
	}

	function getDimentionsFromType(type:MainMenuButtonType):Array<Int>
	{
		return switch (type)
		{
			case MAIN: [90, 12];
			case EXTRA: [90, 9];
			case OTHER: [44, 6];
		};
	}

	function getTextSizeFromType(type:MainMenuButtonType):Int
	{
		return switch (type)
		{
			case MAIN: 32;
			case EXTRA: 25;
			case OTHER: 18;
		};
	}

	function set_available(value:Bool):Bool
	{
		available = value;

		if (!available)
		{
			button.playAnimation('locked');
			label.color = FlxColor.BLACK;
			icon.color = FlxColor.BLACK;
		}
		else
		{
			button.playAnimation('idle');
			label.color = _idleColor;
			icon.color = FlxColor.WHITE;
		}

		return value;
	}
}

enum MainMenuButtonType
{
	MAIN;
	EXTRA;
	OTHER;
}

typedef MainMenuButtonsData =
{
	var translationID:String;
	var available:Bool;
	var ?icon:String;
	var ?iconOffsets:Array<Float>;
	var type:MainMenuButtonType;
	var triggerType:MainMenuButtonTriggerType;
	var onSelect:MainMenuState -> Dynamic;
}

enum MainMenuButtonTriggerType
{
	OPEN_WINDOW;
	SWITCH_STATE;
	OPEN_SUBSTATE;
}
