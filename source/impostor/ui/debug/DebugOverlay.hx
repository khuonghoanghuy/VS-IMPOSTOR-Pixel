package impostor.ui.debug;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

#if desktop
import impostor.api.Git;
#end

class DebugOverlay extends Sprite
{
    public var framerate:Framerate;

    public var memory:Memory;

    public var conductor:impostor.ui.debug.Conductor;

    public var system:SystemStats;

    public var engine:GameEngine;

    var mod:ImpostorMod;

    var updateTimer:Float = 0;
    var updateFrequency:Float = 0.5;

    public function new(backgroundColor:Int = 0x7F7F7F)
    {
        super();

        framerate = new Framerate(backgroundColor);
        addChild(framerate);

        conductor = new impostor.ui.debug.Conductor(backgroundColor);
        conductor.verticalOffset = framerate.overlayHeight + 5;
        addChild(conductor);

        engine = new GameEngine(backgroundColor);
        engine.verticalOffset = conductor.verticalOffset + conductor.overlayHeight + 5;
        addChild(engine);

        mod = new ImpostorMod(backgroundColor);
        addChild(mod);

        system = new SystemStats(backgroundColor);
        system.verticalOffset = mod.overlayHeight + 5;
        addChild(system);

        memory = new Memory(backgroundColor);
        memory.verticalOffset = system.verticalOffset + system.overlayHeight + 5;
        addChild(memory);

        visible = true;

        framerate.update(0);
        conductor.update();
        engine.update();
        system.update();
        memory.update();
    }

    public function toggleVisibility()
    {
        visible = !visible;
    }

    override function __enterFrame(deltaTime:Int)
    {
        if (#if html5 FlxG.keys.pressed.SHIFT && FlxG.keys.justPressed.THREE #else FlxG.keys.justPressed.F3 #end) toggleVisibility();
        if (!visible) return;

        framerate.updatePosition();
        conductor.updatePosition();
        engine.updatePosition();
        memory.updatePosition();
        mod.updatePosition();
        system.updatePosition();

        framerate.update(deltaTime);
        conductor.update();

        if (updateTimer < updateFrequency)
        {
            updateTimer += (deltaTime / 1000);
            return;
        }

        engine.update();
        system.update();
        memory.update();

        updateTimer = 0;
    }
}

private class ImpostorMod extends DebugCategory
{
    var modTitle:TextField;

    var modInfo:TextField;

    public function new(backgroundColor:Int)
    {
        super(null, 472, 62, backgroundColor, TOP_RIGHT);

        modInfo = new TextField();
        modInfo.x = getPositionFromCategoryAlignment();
        modInfo.y = 38;
        modInfo.width = overlayWidth;
        modInfo.height = overlayHeight;
        modInfo.selectable = false;
		modInfo.mouseEnabled = false;
        modInfo.defaultTextFormat = new TextFormat(Defaults.DEFAULT_FONT, 15, 0xFFFFFF, null, null, null, null, null, getTextAlignFromCategoryAlignment());
        addChild(modInfo);

        modTitle = new TextField();
        modTitle.x = getPositionFromCategoryAlignment();
        modTitle.y = 2;
        modTitle.width = overlayWidth;
        modTitle.height = overlayHeight;
        modTitle.selectable = false;
		modTitle.mouseEnabled = false;
        modTitle.defaultTextFormat = new TextFormat(Defaults.DEFAULT_FONT, 28, 0xFFFFFF, null, null, null, null, null, getTextAlignFromCategoryAlignment());
        modTitle.text = '${Defaults.TITLE} - ${Defaults.VERSION}';
        addChild(modTitle);

        final modStuff:Array<String> = [];
        #if desktop
        modStuff.push('Git Commit: ${Git.getCommitHash()}');
        #end

        modInfo.text = modStuff.join("\n");
    }
}