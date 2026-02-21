package funkin.menus.debug.character;

import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.animation.FlxAnimation;
import flixel.math.FlxPoint;
import funkin.play.Character;
import haxe.ui.backend.flixel.UIState;

class CharacterEditorState extends FlxState
{
    public var uiCamera:FlxCamera;

    public var background:FlxBackdrop;

    public var reference:FunkinSprite;
    public var character:Character;

    public var zoomText:FunkinText;
    public var animationList:FlxTypedGroup<FunkinText>;

    override public function create()
    {
        FlxG.camera.zoom = 2;

        super.create();

        uiCamera = new FlxCamera();
        uiCamera.bgColor = FlxColor.TRANSPARENT;
        FlxG.cameras.add(uiCamera, false);

        background = new FlxBackdrop(FlxGridOverlay.createGrid(16, 16, 32, 32, true, 0xFFFFFFFF, 0xFFDCDCDC));
        add(background);

        var xAxis:FunkinSprite = new FunkinSprite().makeSolid(9999, 1, FlxColor.RED);
        xAxis.blend = MULTIPLY;
        xAxis.screenCenter(X);
        add(xAxis);

        var yAxis:FunkinSprite = new FunkinSprite().makeSolid(1, 9999, FlxColor.LIME);
        yAxis.blend = MULTIPLY;
        yAxis.screenCenter(Y);
        add(yAxis);

        reference = new FunkinSprite().loadGraphic(Paths.image("menus/debug/character/funker"));
        reference.x = Math.floor(-reference.width / 2);
        reference.y = Math.floor(-reference.height);
        reference.color = FlxColor.BLACK;
        reference.alpha = 0.4;
        add(reference);

        character = new Character();
        character.animation.onFrameChange.add(updateAnimation);
        add(character);

        animationList = new FlxTypedGroup<FunkinText>();
        animationList.camera = uiCamera;
        add(animationList);

        zoomText = new FunkinText(8, FlxG.height - 4, "", 20, true);
        zoomText.text = 'Zoom: ${Math.round(FlxG.camera.zoom * 100)}%';
        zoomText.font = "Arial";
        zoomText.bold = true;
        zoomText.scrollFactor.set();
        zoomText.y -= zoomText.height;
        zoomText.camera = uiCamera;
        add(zoomText);

        changeCharacter(Defaults.DEFAULT_CHARACTER);

        FlxG.camera.scroll.x = -FlxG.camera.width / 2;
        FlxG.camera.scroll.y = -FlxG.camera.height / 2;
    }

    override public function update(elapsed:Float)
    {
        handleCameraControls(elapsed);
        handleCharacterManipulationControls();

        super.update(elapsed);
		if (FlxG.keys.justPressed.BACKSPACE)
			FlxG.switchState(() -> new DebugState());
    }

    function changeCharacter(newCharacter:String)
    {
        character.loadCharacter(newCharacter);
        curAnimIndex = 0;

        animationList.forEach((txt:FunkinText) -> txt.destroy());
        animationList.clear();
        for (i => animation in character.animation.getNameList())
        {
            var animText:FunkinText = new FunkinText(8, 6 + (24 * i), 0, animation, 20, true);
            animText.font = "Arial";
            animText.bold = true;
            animText.scrollFactor.set();

            var animOffset:FlxPoint = character.getAnimationOffsets(animation);
            animText.text = '$animation: [${animOffset.x}, ${animOffset.y}]';

            animationList.add(animText);
        }

        updateTextList();
    }

    var scrollAmount:Float = 100;
    function handleCameraControls(elapsed:Float)
    {
        if (FlxG.keys.pressed.LEFT)
            FlxG.camera.scroll.x -= scrollAmount * elapsed;
        else if (FlxG.keys.pressed.RIGHT)
            FlxG.camera.scroll.x += scrollAmount * elapsed;

        if (FlxG.keys.pressed.UP)
            FlxG.camera.scroll.y -= scrollAmount * elapsed;
        else if (FlxG.keys.pressed.DOWN)
            FlxG.camera.scroll.y += scrollAmount * elapsed;

        if (FlxG.mouse.wheel != 0)
        {
            FlxG.camera.zoom = FlxMath.bound(FlxG.camera.zoom + FlxG.mouse.wheel / 500, 0.5, 8);
            zoomText.text = 'Zoom: ${Math.round(FlxG.camera.zoom * 100)}%';
        }
    }

    var curAnimIndex:Int = 0;

    function handleCharacterManipulationControls()
    {
        if (FlxG.keys.justPressed.W)
            changeAnimation(-1);
        else if (FlxG.keys.justPressed.S)
            changeAnimation(1);

        if (FlxG.keys.justPressed.A)
            changeFrame(-1);
        else if (FlxG.keys.justPressed.D)
            changeFrame(1);

        if (FlxG.keys.justPressed.SPACE)
            character.replayAnimation();
    }

    function changeAnimation(change:Int = 0)
    {
        var animationList:Array<String> = character.animation.getNameList();
        curAnimIndex = FlxMath.wrap(curAnimIndex + change, 0, animationList.length - 1);
        character.playAnimation(animationList[curAnimIndex], true);

        updateTextList();
    }

    function changeFrame(change:Int = 0)
    {
        var anim:FlxAnimation = character.getCurrentAnimation();
        if (anim != null) 
        {
            anim.pause();
            anim.curFrame = FlxMath.wrap(anim.curFrame + change, 0, anim.numFrames - 1);
        }
    }

    function updateAnimation(animation:String, frame:Int, index:Int)
    {
        
    }

    function updateTextList()
    {
        for (i => text in animationList.members)
        {
            if (i == curAnimIndex)
                text.color = FlxColor.CYAN;
            else
                text.color = FlxColor.WHITE;
        }
    }
}