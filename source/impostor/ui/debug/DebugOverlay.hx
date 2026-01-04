package impostor.ui.debug;

import openfl.display.DisplayObject;
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

	public var conductor:ConductorDebug;

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

		conductor = new ConductorDebug(backgroundColor);
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

		for (i in 0...numChildren)
		{
			var child:DisplayObject = getChildAt(i);
			if (Std.isOfType(child, DebugCategory))
			{
				cast(child, DebugCategory).updatePosition();
				cast(child, DebugCategory).update(deltaTime);
			}
		}

        if (updateTimer < updateFrequency)
        {
            updateTimer += (deltaTime / 1000);
            return;
        }

		for (i in 0...numChildren)
		{
			var child:DisplayObject = getChildAt(i);
			if (Std.isOfType(child, DebugCategory))
			{
				cast(child, DebugCategory).postUpdate();
			}
		}

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

		modInfo = createTextField();
		modInfo.y = 38;
        addChild(modInfo);

        modTitle = new TextField();
		modTitle.x = 8;
        modTitle.y = 2;
		modTitle.width = overlayWidth - 16;
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