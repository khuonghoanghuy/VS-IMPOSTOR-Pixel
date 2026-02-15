package funkin.system.plugins;

import flixel.FlxBasic;

class HotReloadPlugin extends FlxBasic
{
    @:allow(funkin.InitState)
    static function init()
    {
        FlxG.plugins.addPlugin(new HotReloadPlugin());
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}