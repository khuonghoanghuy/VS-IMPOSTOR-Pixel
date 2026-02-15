package funkin.menus;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText.FlxTextAlign;
import flixel.util.FlxSignal;
import funkin.ui.FunkinButton;
import funkin.ui.StarsBackdrop;

class MainMenuState extends MusicBeatState
{
    public static var BASE_SCALE:Float = 5;

    public var curSelectionMode:SelectionMode = MAIN;

    public var backgroundGroup:FlxTypedGroup<FunkinSprite>;
    public var topBarGroup:FlxTypedGroup<FunkinSprite>;
    public var windowBordersGroup:FlxTypedGroup<FunkinSprite>;
    public var mainButtonsGroup:FlxTypedGroup<MainMenuButton>;
    public var floatingCrewGroup:FlxTypedGroup<FunkinSprite>;

    public var backButton:FunkinButton;

    public var windowArea:FlxRect;
    public var windowMenu:WindowSubMenuHandler;

    public var mainCamera:FlxCamera;

    public var mainMenuButtons:Array<MainMenuButtonsData> = [
        {
            translationID: "generic.play",
            available: true,
            icon: getImage("icons/play"),
            type: MAIN,
            triggerType: OPEN_WINDOW,
            onSelect: function(state:MainMenuState) {
                var window:WindowSubMenu = new WindowSubMenu("generic.play");

                var worldmapButton:WindowButton = new WindowButton(state.windowArea.width / 2, 3 * BASE_SCALE, {
                    position: [0, 0],
                    image: getImage("windowButtons/worldmap"),
                    width: 56,
                    height: 55,
                    idleColor: 0xFF0A3C33,
                    hoverColor: 0xFF10584B
                });
                worldmapButton.x -= Math.round(worldmapButton.width + 0.5 * BASE_SCALE);
                worldmapButton.addLabel("mainMenu.worldMap", FlxPoint.get(0, 44), 30, CENTER);
                window.add(worldmapButton);

                var freeplayButton:WindowButton = new WindowButton(state.windowArea.width / 2, 3 * BASE_SCALE, {
                    position: [1, 0],
                    image: getImage("windowButtons/freeplay"),
                    width: 56,
                    height: 55,
                    idleColor: 0xFF0A3C33,
                    hoverColor: 0xFF10584B
                });
                freeplayButton.x += Math.round(0.5 * BASE_SCALE);
                freeplayButton.addLabel("generic.freeplay", FlxPoint.get(0, 44), 30, CENTER);
                window.add(freeplayButton);

                var tutorialButton:WindowButton = new WindowButton(state.windowArea.width / 2, worldmapButton.y + worldmapButton.height + BASE_SCALE, {
                    position: [0, 1],
                    image: getImage("windowButtons/tutorial"),
                    width: 72,
                    height: 12,
                    idleColor: 0xFFAAE2DC,
                    hoverColor: 0xFFFFFFFF
                });
                tutorialButton.x -= tutorialButton.width / 2;
                tutorialButton.addLabel("mainMenu.tutorial", FlxPoint.get(0, 2), 28, CENTER);
                window.add(tutorialButton);

                return window;
            }
        },
        {
            translationID: "generic.achievements",
            available: true,
            icon: getImage("icons/achievements"),
            iconOffsets: [4, 0],
            type: MAIN,
            triggerType: SWITCH_STATE,
            onSelect: function(state:MainMenuState) {
                return null;
            }
        },
        {
            translationID: "generic.shop",
            available: true,
            icon: getImage("icons/shop"),
            iconOffsets: [1, 1],
            type: MAIN,
            triggerType: SWITCH_STATE,
            onSelect: function(state:MainMenuState) {
                return null;
            }
        },
        {
            translationID: "generic.options",
            available: true,
            icon: getImage("icons/options"),
            type: EXTRA,
            triggerType: OPEN_SUBSTATE,
            onSelect: function(state:MainMenuState) {
                return null;
            }
        },
        {
            translationID: "generic.extras",
            available: true,
            icon: getImage("icons/extras"),
            type: EXTRA,
            triggerType: OPEN_WINDOW,
            onSelect: function(state:MainMenuState) {
                var window:WindowSubMenu = new WindowSubMenu("generic.extras");

                return window;
            }
        },
        {
            translationID: "generic.exit",
            available: true,
            type: OTHER,
            triggerType: OPEN_SUBSTATE,
            onSelect: function(state:MainMenuState) {
                return null;
            }
        }
    ];

    inline function getImage(path:String):String
    {
        return Paths.image('menus/mainmenu/$path');
    }

    override public function create()
    {
        super.create();

		#if DISCORD_API
        DiscordClient.changePresence({
			state: "Navigating Menus",
			details: "Main Menu"
		});
		#end

        FunkinSound.playMenuMusic();

        FlxG.camera.bgColor = FlxColor.TRANSPARENT;

        mainCamera = new FlxCamera();
        mainCamera.bgColor = FlxColor.TRANSPARENT;
        FlxG.cameras.add(mainCamera);

        var starField:StarsBackdrop = new StarsBackdrop(-5);
        starField.scale = 1.2;
        starField.scrollFactor = 0;
        starField.camera = FlxG.camera;
        add(starField);

        backgroundGroup = new FlxTypedGroup<FunkinSprite>();
        backgroundGroup.camera = mainCamera;
        add(backgroundGroup);

        var bgLeft:FunkinSprite = new FunkinSprite().loadGraphic(getImage('bg-left'));
        bgLeft.scaleSprite(BASE_SCALE);
        backgroundGroup.add(bgLeft);

        var bgRight:FunkinSprite = new FunkinSprite(FlxG.width).loadGraphic(getImage('bg-right'));
        bgRight.scaleSprite(BASE_SCALE);
        bgRight.x -= bgRight.width;
        backgroundGroup.add(bgRight);

        var bgBordersDistance:Float = MathUtil.distanceBetweenFloats(bgLeft.x + bgLeft.width, bgRight.x);
        var bgMiddle:FunkinSprite = new FunkinSprite(bgLeft.x + bgLeft.width).loadGraphic(getImage('bg-middle'));
        bgMiddle.setGraphicSize(bgBordersDistance, bgMiddle.frameHeight * BASE_SCALE);
        bgMiddle.updateHitbox();
        backgroundGroup.add(bgMiddle);

        topBarGroup = new FlxTypedGroup<FunkinSprite>();
        topBarGroup.camera = mainCamera;

        var topLeft:FunkinSprite = new FunkinSprite(1 * BASE_SCALE, 2 * BASE_SCALE).loadGraphic(getImage('top-left'));
        topLeft.scaleSprite(BASE_SCALE);

        var topRight:FunkinSprite = new FunkinSprite(FlxG.width - 1 * BASE_SCALE, 2 * BASE_SCALE).loadGraphic(getImage('top-right'));
        topRight.scaleSprite(BASE_SCALE);
        topRight.x -= topRight.width;

        var topBordersDistance:Float = MathUtil.distanceBetweenFloats(topLeft.x + topLeft.width, topRight.x);
        var topMiddle:FunkinSprite = cast new FunkinSprite(topLeft.x + topLeft.width, topLeft.y).makeGraphic(1, 18, 0xFF282828);
        for (position in [0, 17]) topMiddle.pixels.setPixel(0, position, 0x111111);
        topMiddle.setGraphicSize(topBordersDistance, topMiddle.frameHeight * BASE_SCALE);
        topMiddle.updateHitbox();

        var topShadowLeft:FunkinSprite = new FunkinSprite(topLeft.x, topLeft.y + topLeft.height - 2 * BASE_SCALE).loadGraphic(getImage('top-shadow'));
        topShadowLeft.scaleSprite(BASE_SCALE);
        topShadowLeft.blend = MULTIPLY;
        topBarGroup.add(topShadowLeft);

        var topShadowRight:FunkinSprite = topShadowLeft.clone();
        topShadowRight.scaleSprite(BASE_SCALE);
        topShadowRight.setPosition(FlxG.width - 1 * BASE_SCALE, topRight.y + topRight.height - 2 * BASE_SCALE);
        topShadowRight.flipX = true;
        topShadowRight.blend = MULTIPLY;
        topShadowRight.x -= topShadowRight.width;
        topBarGroup.add(topShadowRight);

        var topShadowBordersDistance:Float = MathUtil.distanceBetweenFloats(topShadowLeft.x + topShadowLeft.width, topShadowRight.x);
        var topShadowMiddle:FunkinSprite = cast new FunkinSprite(topShadowLeft.x + topShadowLeft.width, topShadowLeft.y).makeGraphic(Std.int(topShadowBordersDistance), Std.int(4 * BASE_SCALE), 0xFF999999);
        topShadowMiddle.blend = MULTIPLY;
        topBarGroup.add(topShadowMiddle);

        topBarGroup.add(topLeft);
        topBarGroup.add(topRight);
        topBarGroup.add(topMiddle);

        var lightBulb:FunkinSprite = new FunkinSprite(topLeft.x + 24 * BASE_SCALE, topLeft.y + 4 * BASE_SCALE).loadGraphic(getImage("lightBulb"));
        lightBulb.scaleSprite(BASE_SCALE);
        lightBulb.camera = mainCamera;
        lightBulb.color = 0xFF43A25A;
        topBarGroup.add(lightBulb);

        var lightGlow:FunkinSprite = new FunkinSprite().loadGraphic(Paths.image("glow"));
        lightGlow.scaleSprite(BASE_SCALE / 2);
        lightGlow.x = lightBulb.x + (lightBulb.width - lightGlow.width) / 2;
        lightGlow.y = lightBulb.y + (lightBulb.height - lightGlow.height) / 2;
        lightGlow.blend = ADD;
        lightGlow.alpha = 0.75;
        lightGlow.color = lightBulb.color;
        topBarGroup.add(lightGlow);

        var lightBulbOverlay:FunkinSprite = new FunkinSprite(lightBulb.x, lightBulb.y).loadGraphic(getImage("lightBulbOverlay"));
        lightBulbOverlay.scaleSprite(BASE_SCALE);
        lightBulbOverlay.camera = mainCamera;
        lightBulbOverlay.blend = ADD;
        topBarGroup.add(lightBulbOverlay);

        var miniTitle:FunkinSprite = new FunkinSprite(3 * BASE_SCALE, topShadowLeft.y + topShadowLeft.height + 2 * BASE_SCALE).loadGraphic(getImage('title'));
        miniTitle.scaleSprite(BASE_SCALE);
        miniTitle.camera = mainCamera;
        add(miniTitle);

        var mainButtonsBack:FunkinSprite = new FunkinSprite(2 * BASE_SCALE, miniTitle.y + miniTitle.height + 2 * BASE_SCALE).loadGraphic(getImage('buttonsBack'));
        mainButtonsBack.scaleSprite(BASE_SCALE);
        mainButtonsBack.camera = mainCamera;

        var buttonsBackShadow:FunkinSprite = new FunkinSprite(mainButtonsBack.x - 1 * BASE_SCALE, mainButtonsBack.y + 3 * BASE_SCALE).loadGraphic(getImage('buttonsBack-shadow'));
        buttonsBackShadow.scaleSprite(BASE_SCALE);
        buttonsBackShadow.blend = MULTIPLY;
        buttonsBackShadow.camera = mainCamera;

        add(buttonsBackShadow);
        add(mainButtonsBack);

        var buttonsDivision:FunkinSprite = cast new FunkinSprite(mainButtonsBack.x + 4 * BASE_SCALE, mainButtonsBack.y + 46 * BASE_SCALE).makeGraphic(94, 1, 0xFF5A5B61);
        for (position in [0, 1, 92, 93]) buttonsDivision.pixels.setPixel(position, 0, 0x3E4044);
        buttonsDivision.scaleSprite(BASE_SCALE);
        buttonsDivision.camera = mainCamera;
        add(buttonsDivision);

        mainButtonsGroup = new FlxTypedGroup<MainMenuButton>(6);
        mainButtonsGroup.camera = mainCamera;
        add(mainButtonsGroup);

        createMainButtons(mainButtonsBack.x + 3 * BASE_SCALE * 2, mainButtonsBack.y + 3 * BASE_SCALE * 2);

        var version:FunkinText = new FunkinText(mainButtonsBack.x, mainButtonsBack.y + mainButtonsBack.height + 2 * BASE_SCALE, mainButtonsBack.width, "", 18, true);
        version.translationData = {id: "common.version", parameters: [Defaults.VERSION]};
        version.alignment = CENTER;
        version.borderSize = 2;
        version.color = 0xFFBFBFBF;
        version.camera = mainCamera;
        add(version);

        add(topBarGroup);

        windowBordersGroup = new FlxTypedGroup<FunkinSprite>();
        windowBordersGroup.camera = mainCamera;
        add(windowBordersGroup);

        var windowBorderLeft:FunkinSprite = new FunkinSprite(mainButtonsBack.x + mainButtonsBack.width + 2 * BASE_SCALE, topLeft.y + topLeft.height + 3 * BASE_SCALE).loadGraphic(getImage("windowBorder-left"));
        windowBorderLeft.scaleSprite(BASE_SCALE);

        var windowBorderDistance:Float = MathUtil.distanceBetweenFloats(windowBorderLeft.x + windowBorderLeft.width, FlxG.width);
        var windowBorderMiddle:FunkinSprite = new FunkinSprite(windowBorderLeft.x + windowBorderLeft.width, windowBorderLeft.y).loadGraphic(getImage("windowBorder-middle"));
        windowBorderMiddle.setGraphicSize(windowBorderDistance, windowBorderMiddle.frameHeight * BASE_SCALE);
        windowBorderMiddle.updateHitbox();

        var windowShadowLeft:FunkinSprite = new FunkinSprite(windowBorderLeft.x - BASE_SCALE, windowBorderLeft.y + 5 * BASE_SCALE).loadGraphic(getImage("windowBorder-shadowL"));
        windowShadowLeft.scaleSprite(BASE_SCALE);
        windowShadowLeft.blend = MULTIPLY;

        var windowShadowDistance:Float = MathUtil.distanceBetweenFloats(windowBorderLeft.x + windowBorderLeft.width, FlxG.width);
        var windowShadowMiddle:FunkinSprite = new FunkinSprite(windowShadowLeft.x + windowShadowLeft.width, windowShadowLeft.y).loadGraphic(getImage("windowBorder-shadowM"));
        windowShadowMiddle.setGraphicSize(windowShadowDistance, windowShadowMiddle.frameHeight * BASE_SCALE);
        windowShadowMiddle.updateHitbox();
        windowShadowMiddle.blend = MULTIPLY;

        floatingCrewGroup = new FlxTypedGroup<FunkinSprite>();
        floatingCrewGroup.camera = FlxG.camera;
        add(floatingCrewGroup);

        var windowAreaX:Float = windowBorderLeft.x + 8 * BASE_SCALE;
        var windowAreaY:Float = windowBorderLeft.y + 8 * BASE_SCALE;
        var windowAreaW:Float = FlxG.width - windowAreaX;
        var windowAreaH:Float = MathUtil.distanceBetweenFloats(windowAreaY, windowBorderLeft.y + windowBorderLeft.height - 8 * BASE_SCALE);
        windowArea = new FlxRect(windowAreaX, windowAreaY, windowAreaW, windowAreaH);

        FlxG.camera.setPosition(windowArea.x, windowArea.y);
        FlxG.camera.setSize(Std.int(windowArea.width), Std.int(windowArea.height));

        var windowShine:FunkinSprite = new FunkinSprite().loadGraphic(getImage("window-shine"));
        windowShine.scaleSprite(BASE_SCALE);
        windowShine.blend = ADD;
        windowShine.alpha = 0.18;
        windowShine.x = windowArea.width * (windowArea.width / 1280) * 0.4;
        windowShine.camera = FlxG.camera;
        add(windowShine);

        windowMenu = new WindowSubMenuHandler(FlxG.camera, windowArea, BASE_SCALE);
        windowMenu.onClose.add(closeWindowSubMenu);
        add(windowMenu);

        windowBordersGroup.add(windowShadowLeft);
        windowBordersGroup.add(windowShadowMiddle);
        windowBordersGroup.add(windowBorderLeft);
        windowBordersGroup.add(windowBorderMiddle);

        var buttonScale:Float = FlxG.onMobile ? 4 : 3;
        backButton = new FunkinButton(FlxG.width * 0.96, FlxG.height);
        backButton.frames = Paths.getFrames("ui/backButton");
        backButton.addAnimationByPrefix("idle", "idle", 24, false);
        backButton.addAnimationByPrefix("hold", "hold", 24, false);
        backButton.addAnimationByPrefix("press", "press", 24, false);
        backButton.playAnimation("idle");
        backButton.scaleSprite(buttonScale);
        backButton.x -= backButton.width;
        backButton.y -= backButton.height * 1.1;
        backButton.camera = mainCamera;
        add(backButton);

        backButton.onPress.add(buttonOnPress);
        backButton.onRelease.add(buttonOnConfirm);
        backButton.onUnhover.add(buttonOnLeave);

        changeSelection();
    }

    function createMainButtons(x:Float = 0, y:Float = 0)
    {
        var yPos:Float = y;

        for (i => buttonData in mainMenuButtons)
        {
            if (i >= 6) return;

            var button:MainMenuButton = new MainMenuButton(i, x, yPos, buttonData, BASE_SCALE);
            mainButtonsGroup.add(button);

            yPos += button.height + BASE_SCALE + 1;
            if (i == 2) yPos += 3 * BASE_SCALE;
        }
    }

    public var allowInput:Bool = true;
    public var usingKeyboard:Bool = true;
    public var curEntry:Int = 0;

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (allowInput)
        {
            switch (curSelectionMode)
            {
                case MAIN: handleMainInput(elapsed);
                case WINDOW: handleWindowInput(elapsed);
            }
        }
    }

    public function handleMainInput(elapsed:Float)
    {
		if (FlxG.onMobile)
			handleTouch();
		else
			handleMouse();

        if (FlxG.keys.justPressed.ANY)
			usingKeyboard = true;

        if (usingKeyboard)
        {
            if (FlxG.keys.justPressed.BACKSPACE)
                FlxG.switchState(() -> new TitleState());

            if (FlxG.keys.justPressed.DOWN)
                changeSelection(1);
            else if (FlxG.keys.justPressed.UP)
                changeSelection(-1);

            if (FlxG.keys.justPressed.ENTER)
                checkSelection();
        }
	}

	public function handleMouse()
	{
		if (FlxG.mouse.justMoved)
			usingKeyboard = false;
		if (usingKeyboard)
			return;

		for (button in mainButtonsGroup.members)
		{
			if (button.available)
			{
				if (FlxG.mouse.overlaps(button, mainCamera))
				{
					curEntry = button._position;
					changeSelection(0);
					if (FlxG.mouse.justReleased)
						checkSelection();
				}
			}
		}
	}

	public function handleTouch()
	{
		for (touch in FlxG.touches.list)
			if (touch.justMoved)
				usingKeyboard = false;
		if (usingKeyboard)
			return;

		for (touch in FlxG.touches.list)
		{
			for (button in mainButtonsGroup.members)
			{
				if (button.available)
				{
					if (touch.overlaps(button, mainCamera))
					{
						curEntry = button._position;
						changeSelection(0);

						if (touch.justReleased)
							checkSelection();
					}
				}
			}
		}
	}

    public function changeSelection(change:Int = 0)
    {
        var oldEntry:Int = curEntry;
        curEntry = FlxMath.wrap(curEntry + change, 0, mainButtonsGroup.countLiving() - 1);

        for (button in mainButtonsGroup.members)
        {
            button.checkPosition(curEntry);
        }
    }

    function buttonOnPress():Void
    {
        if (allowInput)
        {
            backButton.playAnimation("hold");
        }
    }

    function buttonOnConfirm():Void
    {
        if (allowInput)
        {
            disableInput();
            backButton.playAnimation("press");
            backButton.onFinishAnimation.add(_ -> FlxG.switchState(() -> new TitleState()));
        }
    }

    function buttonOnLeave():Void
    {
        backButton.playAnimation("idle");
    }

    public function checkSelection():Void
    {
        var buttonData:MainMenuButtonsData = mainMenuButtons[curEntry];

        if (buttonData.available)
        {
            selectButton(buttonData);
        }
    }

    public function selectButton(buttonData:MainMenuButtonsData)
    {
        switch (buttonData.triggerType)
        {
            case OPEN_WINDOW: openWindowSubMenu(buttonData.onSelect(this));
            case SWITCH_STATE: new FlxTimer().start(1, _ -> FlxG.switchState(buttonData.onSelect(this)));
            case OPEN_SUBSTATE: openSubState(buttonData.onSelect(this));
        }
    }

    public function handleWindowInput(elapsed:Float)
    {
        if (FlxG.keys.justPressed.BACKSPACE)
            closeWindowSubMenu();
    }

    public function openWindowSubMenu(windowSubMenu:WindowSubMenu)
    {
        curSelectionMode = WINDOW;
        backButton.visible = false;
        windowMenu.open(windowSubMenu);
    }

    public function closeWindowSubMenu()
    {
        curSelectionMode = MAIN;
        backButton.visible = true;
        windowMenu.close();
    }

    override function onLanguageUpdate(language:String)
    {
        super.onLanguageUpdate(language);
        windowMenu.onLanguageUpdate(language);
    }

    function enableInput():Void
    {
        allowInput = true;
        windowMenu.enabled = true;
    }

    function disableInput():Void
    {
        allowInput = false;
        windowMenu.enabled = false;
    }
}

enum SelectionMode
{
    MAIN;
    WINDOW;
}

typedef MainMenuButtonsData =
{
    var translationID:String;
    var available:Bool;
    var ?icon:String;
    var ?iconOffsets:Array<Float>;
    var type:MainMenuButtonType;
    var triggerType:MainMenuButtonTriggerType;
    var onSelect:MainMenuState->Dynamic;
}

enum MainMenuButtonTriggerType
{
    OPEN_WINDOW;
    SWITCH_STATE;
    OPEN_SUBSTATE;
}

enum MainMenuButtonType
{
    MAIN;
    EXTRA;
    OTHER;
}

class MainMenuButton extends FlxTypedSpriteGroup<FlxSprite>
{
    public var button(default, null):FunkinSprite;

    public var label(default, null):FunkinText;

    public var icon(default, null):FunkinSprite;

    public var type(default, null):MainMenuButtonType;

    public var available(default, set):Bool;

    public var hovered(default, null):Bool = false;

    public var _position:Int = 0;
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
        button.addAnimationByFrameList("idle", [0], 0);
        button.addAnimationByFrameList("hover", [1], 0);
        button.addAnimationByFrameList("locked", [2], 0);
        button.scaleSprite(scale);
        add(button);

        var labelPosition:Float = 4 * scale;
        label = new FunkinText(labelPosition, button.height / 2, button.width - labelPosition * 2, "", getTextSizeFromType(type));
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

    public function checkPosition(position:Int):Void
    {
        if (available)
        {
            if (position == _position)
                hover();
            else
                idle();
        }
    }

    function idle():Void
    {
        button.playAnimation("idle");
        label.color = _idleColor;

        hovered = false;
    }

    function hover():Void
    {
        button.playAnimation("hover");
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
            case MAIN: Paths.image("menus/mainmenu/mainButton");
            case EXTRA: Paths.image("menus/mainmenu/extraButton");
            case OTHER: Paths.image("menus/mainmenu/otherButton");
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
            button.playAnimation("locked");
            label.color = FlxColor.BLACK;
            icon.color = FlxColor.BLACK;
        }
        else
        {
            button.playAnimation("idle");
            label.color = _idleColor;
            icon.color = FlxColor.WHITE;
        }

        return value;
    }
}

class WindowSubMenuHandler extends FlxBasic
{
    public var isOpen(default, null):Bool;

    public var titleObject(default, null):FunkinText;

    public var closeButton(default, null):FunkinButton;

    public var curSubMenu(default, null):WindowSubMenu;

    public var enabled:Bool = true;

    public var onOpen:FlxSignal = new FlxSignal();

    public var onClose:FlxSignal = new FlxSignal();

    var background:FunkinSprite;
    var line:FunkinSprite;

    var windowCamera:FlxCamera;

    var _mainRect:FlxRect;
    var _subMenuRect:FlxRect;

    public function new(camera:FlxCamera, area:FlxRect, scale:Float = 5)
    {
        super();

        this.camera = camera;

        background = cast new FunkinSprite().makeGraphic(this.camera.width, this.camera.height, 0xFF505050);
        background.scrollFactor.set();
        background.alpha = 0.7;
        background.camera = this.camera;

        closeButton = new FunkinButton(MainMenuState.BASE_SCALE, MainMenuState.BASE_SCALE);
        closeButton.scaleSprite(MainMenuState.BASE_SCALE);
        closeButton.camera = this.camera;

        line = cast new FunkinSprite(0, closeButton.y + closeButton.height + MainMenuState.BASE_SCALE).makeGraphic(Std.int(background.width), Std.int(scale), 0xFFFFFFFF);
        line.scrollFactor.set();
        line.camera = this.camera;

        var titlePos:Float = 2 * scale;
        titleObject = new FunkinText(titlePos, closeButton.y, background.width - titlePos * 2, "", 56);
        titleObject.scrollFactor.set();
        titleObject.alignment = RIGHT;
        titleObject.camera = this.camera;

        _mainRect = new FlxRect(0, 0, this.camera.width, line.y + line.height);
        _subMenuRect = new FlxRect(0, _mainRect.height, _mainRect.width, MathUtil.distanceBetweenFloats(_mainRect.y + _mainRect.height, this.camera.height));

        windowCamera = new FlxCamera(this.camera.x, this.camera.y + _subMenuRect.y, this.camera.width, Std.int(_subMenuRect.height));
        windowCamera.bgColor = FlxColor.TRANSPARENT;
        FlxG.cameras.insert(windowCamera, FlxG.cameras.list.indexOf(this.camera) + 1, false);

        kill();
        isOpen = false;
    }

    public function open(subMenu:WindowSubMenu):Void
    {
        if (subMenu == null) return;
        if (isOpen) return;

        if (curSubMenu != null)
        {
            curSubMenu.destroy();
            curSubMenu = null;
        }

        revive();

        curSubMenu = subMenu;
        curSubMenu.camera = windowCamera;
        curSubMenu.init(this);
        titleObject.translationData = {id: curSubMenu.nameTranslationID};

        onOpen.dispatch();

        isOpen = true;
    }

    public function close(trigger:Bool = false)
    {
        if (!isOpen) return;

        if (curSubMenu != null)
        {
            curSubMenu.destroy();
            curSubMenu = null;
        }

        windowCamera.scroll.set();
        windowCamera.minScrollX = null;
        windowCamera.minScrollY = null;
        windowCamera.maxScrollX = null;
        windowCamera.maxScrollY = null;

        if (trigger) onClose.dispatch();

        kill();

        isOpen = false;
    }

    override function update(elapsed:Float)
    {
        if (!enabled || !isOpen) return;

        super.update(elapsed);

        background.update(elapsed);
        line.update(elapsed);
        titleObject.update(elapsed);
        closeButton.update(elapsed);

        if (curSubMenu != null)
			curSubMenu.update(elapsed);

        if (closeButton.justReleased)
        {
            close(true);
        }
    }

    override function draw()
    {
        if (!isOpen) return;

        super.draw();

        background.draw();
        line.draw();
        titleObject.draw();
        closeButton.draw();

        if (curSubMenu != null)
			curSubMenu.draw();
    }

    public function onLanguageUpdate(language:String)
    {
        titleObject.text = "";

        if (curSubMenu != null)
			curSubMenu.forEach((spr) -> spr.label.text = "");
    }

    override public function revive()
    {
		background.revive();
		closeButton.revive();
		line.revive();
		titleObject.revive();

        super.revive();
    }

    override public function kill()
    {
        background.kill();
		closeButton.kill();
		line.kill();
		titleObject.kill();

        super.kill();
    }

    override public function destroy()
    {
        super.destroy();

		background.destroy();
		closeButton.destroy();
		line.destroy();
		titleObject.destroy();

		if (curSubMenu != null)
			curSubMenu.destroy();
    }
}

class WindowSubMenu extends FlxTypedGroup<WindowButton>
{
    public var nameTranslationID(default, null):String;

    public var customUpdate:Float->Void = null;

    var _parent:WindowSubMenuHandler;

    var _pointerPosition:FlxPoint;
    var _hovering:Bool = false;

    public function new(translationID:String)
    {
        super();

        nameTranslationID = translationID;

        _pointerPosition = FlxPoint.get(-1, -1);
    }

    override function destroy()
    {
        super.destroy();
        customUpdate = null;
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (customUpdate != null) customUpdate(elapsed);

        var _lastPosition:FlxPoint = _pointerPosition.clone();
        _hovering = false;

        for (button in members)
        {
			/*
            if (Pointer.overlapsComplex(button, @:privateAccess _parent.windowCamera) && button.available)
            {
                _hovering = true;
                _pointerPosition.copyFrom(button.index);
                if (_pointerPosition.x != _lastPosition.x || _pointerPosition.y != _lastPosition.y)
                {
                    button.hover();
                }
            }
            else
            {
                button.idle();
            }

            if (_hovering && Pointer.justReleased)
            {
                //button.checkPosition();
            }
			 */
        }

        if (!_hovering)
        {
            _pointerPosition.set(-1, -1);
        }
    }

    public function init(parent:WindowSubMenuHandler):Void
    {
        _parent = parent;

        forEach((spr) -> {
            spr.camera = @:privateAccess _parent.windowCamera;
        });
    }
}

typedef WindowGraphicData =
{
    var position:Array<Int>;
    var ?image:String;
    var width:Int;
    var height:Int;
    var ?idleColor:FlxColor;
    var ?hoverColor:FlxColor;
}

class WindowButton extends FlxTypedSpriteGroup<FlxSprite>
{
    public var button(default, null):FunkinSprite;

    public var label(default, null):FunkinText;

    public var icon(default, null):FunkinText;

    public var available(default, set):Bool = true;

    public var onSelect:Void->Void = null;

    public var hoverColor:FlxColor = FlxColor.WHITE;

    public var idleColor:FlxColor = FlxColor.BLACK;

    public var index:FlxPoint;

    var _idleOpacity:Float = 0.1;
	var _hoverOpacity:Float = 0.45;
    var _hasLabel:Bool = false;
    var _hasIcon:Bool = false;
    var data:WindowGraphicData;
    var _idleColor:FlxColor = FlxColor.BLACK;
    var _hoverColor:FlxColor = FlxColor.WHITE;

    public function new(x:Float = 0, y:Float = 0, data:WindowGraphicData)
    {
        super(x, y);

        this.data = data;

        if (data.idleColor != null) _idleColor = data.idleColor;
        if (data.hoverColor != null) _hoverColor = data.hoverColor;

        index = FlxPoint.get(this.data.position[0], this.data.position[1]);

        button = new FunkinSprite();

        if (this.data.image == null)
        {
            button.makeGraphic(this.data.width, this.data.height, FlxColor.WHITE);
            button.alpha = _idleOpacity;
        }
        else
        {
            button.loadGraphic(this.data.image, true, this.data.width, this.data.height);
            button.addAnimationByFrameList("idle", [0], 0);
            button.addAnimationByFrameList("hover", [1], 0);
            button.addAnimationByFrameList("locked", [2], 0);
            button.scaleSprite(MainMenuState.BASE_SCALE);
        }

        add(button);
    }

    var labelPosition:FlxPoint = FlxPoint.get();

    public function addLabel(translationID:String, ?position:FlxPoint, size:Int = 32, alignment:FlxTextAlign = LEFT, limit:Float = 0)
    {
        if (position == null) position = FlxPoint.get();

        labelPosition.copyFrom(position);

        label = new FunkinText(labelPosition.x * MainMenuState.BASE_SCALE, labelPosition.y * MainMenuState.BASE_SCALE, button.width, "", size);
        label.translationData = {id: translationID};
        label.color = available ? _idleColor : FlxColor.BLACK;
        label.alignment = alignment;
        add(label);

        _hasLabel = true;
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    public function checkPosition(position:FlxPoint):Void
    {
        if (position.x == index.x && position.y == index.y)
            hover();
        else
            idle();
    }

    public function idle():Void
    {
        button.playAnimation("idle");
        if (_hasLabel) label.color = _idleColor;
    }

    public function hover():Void
    {
        button.playAnimation("hover");
        if (_hasLabel) label.color = _hoverColor;
    }

    function set_available(value:Bool):Bool
    {
        available = value;

        if (!available)
        {
            button.playAnimation("locked");
            if (_hasLabel) label.color = FlxColor.BLACK;
            if (_hasIcon) icon.color = FlxColor.BLACK;
        }
        else
        {
            button.playAnimation("idle");
            if (_hasLabel) label.color = _idleColor;
            if (_hasIcon) icon.color = FlxColor.WHITE;
        }

        return value;
    }
}