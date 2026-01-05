package impostor.menus;

import impostor.graphics.text.GameboyText;
import impostor.ui.StarsBackdrop;

class TitleState extends MusicBeatState
{
	static var PRESS_START_TWEEN_DURATION:Float = 1.5;
	static var CAMERA_DEFAULT_ZOOM:Float = 1;
	static var CAMERA_BEAT_BOP_STRENGTH:Float = 0.01;

    public var curState:TitleStateMode = IDLE;

    public var stars:StarsBackdrop;

    public var introGroup:FlxGroup;
    public var introText:FunkinText;

    public var titleRGBSprite:FunkinSprite;
    public var titleMainSprite:FunkinSprite;
	public var pressStartText:GameboyText;

    var titleColors:Array<Array<FlxColor>> = [
        [0xFFE31629, 0xFF90003A],
        [0xFF3842AE, 0xFF2A1F78],
        [0xFF18683B, 0xFF0D412E],
        [0xFFEf69CB, 0xFFB74175],
        [0xFFF6CC5A, 0xFFD98E25],
        [0xFF352441, 0xFF23182F],
        [0xFFD2E5E8, 0xFF97ABB5],
        [0xFF461D87, 0xFF251161],
        [0xFF5D3E31, 0xFF412720],
        [0xFF61C2EF, 0xFF3B75C0],
        [0xFF5DD95D, 0xFF338C44],
        [0xFF58223C, 0xFF41132E],
        [0xFFFFBBD9, 0xFFCD7FB4],
        [0xFFF8ECAA, 0xFFE2BC69],
        [0xFF67768E, 0xFF4C5371],
        [0xFF998877, 0xFF6F5B4E],
        [0xFFFF7488, 0xFFD94368],
    ];

	var doCameraBop:Bool = true;

    override public function create() {
        MusicBeatState.skipTransOut = true;

        super.create();

        FunkinSound.playMusic(Paths.music('mainMenu'), 1, {bpm: 102});

        DiscordClient.changePresence({
			state: "Navigating Menus",
			details: "Title Screen"
		});

        stars = new StarsBackdrop(-10, 5);
        add(stars);

        var titleSpriteGroup:FlxSpriteGroup = new FlxSpriteGroup();
        titleSpriteGroup.y = FlxG.height * 0.2;
        add(titleSpriteGroup);

        titleRGBSprite = new FunkinSprite().loadGraphic(Paths.image("menus/title/color"));
        titleRGBSprite.scaleSprite(4);
        titleSpriteGroup.add(titleRGBSprite);

		var titleAnimIndices:Array<Int> = [0, 0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 0];
        titleMainSprite = new FunkinSprite().loadGraphic(Paths.image("menus/title/title"), true, 197, 65);
        titleMainSprite.addAnimationByFrameList(null, titleAnimIndices, 24, false);
        titleMainSprite.scaleSprite(4);
        titleSpriteGroup.add(titleMainSprite);

        titleSpriteGroup.screenCenter(X);
		pressStartText = new GameboyText(0, 0, "TEXT TEST ASDJEIFJH", 56);
		pressStartText.translationData = {id: "titleScreen.pressStart.press", parameters: ["ENTER"]};
		pressStartText.letterSpacing = -1;
		pressStartText.screenCenter(X);
		pressStartText.y = FlxG.height * 0.9 - pressStartText.height;
		pressStartText.alpha = 1;
		add(pressStartText);

		tweenPressStart();
    }

    var allowInput:Bool = true;

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

		FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, CAMERA_DEFAULT_ZOOM, 0.05);
    }

    override public function beatHit(beat:Int) {
        if (beat % 4 == 3)
        {
            titleMainSprite.playAnimation();
        }

        if (doCameraBop)
        {
            bopTitle();
			FlxG.camera.zoom += CAMERA_BEAT_BOP_STRENGTH;
		}
	}

	var pressStartTweenIn:FlxTween = null;
	var pressStartTweenOut:FlxTween = null;
	var altPSText:Bool = false;

	public function tweenPressStart():Void
	{
		if (altPSText = !altPSText)
		{
			pressStartText.translationData = {id: "titleScreen.pressStart.press", parameters: ["ENTER"]};
		}
		else
		{
			if (FlxG.onMobile)
				pressStartText.translationData = {id: "titleScreen.pressStart.touch"};
			else
				pressStartText.translationData = {id: "titleScreen.pressStart.mouse"};
		}

		pressStartText.screenCenter(X);

		if (pressStartTweenIn != null)
			pressStartTweenIn.cancel();

		if (pressStartTweenOut != null)
			pressStartTweenOut.cancel();

		pressStartText.alpha = 0;
		pressStartTweenIn = FlxTween.tween(pressStartText, {alpha: 1}, PRESS_START_TWEEN_DURATION, {
			ease: FlxEase.quadOut,
			onComplete: _ ->
			{
				pressStartTweenOut = FlxTween.tween(pressStartText, {alpha: 0}, PRESS_START_TWEEN_DURATION, {
					ease: FlxEase.quadIn,
					onComplete: _ -> tweenPressStart()
				});
			}
		});
	}

	public function bopTitle():Void
	{
        FlxTween.cancelTweensOf(titleMainSprite, ["scale.x", "scale.y"]);
        FlxTween.cancelTweensOf(titleRGBSprite, ["scale.x", "scale.y"]);

        var beatScale:Float = 4 * 1.08;
        var tweenDuration:Float = (Conductor.stepLengthMs / 1000) * 4;

        titleMainSprite.scale.set(beatScale, beatScale);
        titleRGBSprite.scale.set(beatScale, beatScale);
        FlxTween.tween(titleMainSprite, {"scale.x": 4, "scale.y": 4}, tweenDuration, {ease: FlxEase.quadOut});
        FlxTween.tween(titleRGBSprite, {"scale.x": 4, "scale.y": 4}, tweenDuration, {ease: FlxEase.quadOut});
    }
	override function onLanguageUpdate(language:String)
	{
		super.onLanguageUpdate(language);

		pressStartText.screenCenter(X);
	}
}

enum TitleStateMode
{
    INTRO;
    IDLE;
    DEMO;
}