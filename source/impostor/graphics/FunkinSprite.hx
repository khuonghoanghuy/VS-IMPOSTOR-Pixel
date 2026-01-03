package impostor.graphics;

import flixel.FlxSprite;
import flixel.animation.FlxAnimation;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets.FlxGraphicAsset;
import openfl.display.BitmapData;

class FunkinSprite extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0, ?graphic:FlxGraphicAsset)
    {
        super(x, y);

        if (graphic != null)
        {
            loadSprite(graphic);
        }

        antialiasing = false;

        animation.onFinish.add(onFinishAnimation);
    }

    /**
     * Rescales the sprite and updates it's hitbox automatically.
     */
    public function scaleSprite(x:Float = 1, ?y:Float):Void
    {
        if (y == null)
        {
            y = x;
        }

        this.scale.set(x, y);
        updateHitbox();
    }

    /**
     * Loads an image to this sprite from an external or embedded graphic file and parses it's animations if a valid file is alongside it.
     * 
     * @param graphic   The graphic to want to load and parse the animations from.
     *                  Must be an asset path (a `String`) in order to parse the animations.
     */
    public function loadSprite(graphic:FlxGraphicAsset):FunkinSprite
    {
        if (Std.isOfType(graphic, BitmapData) || Std.isOfType(graphic, FlxGraphic))
        {
            loadGraphic(graphic);
        }
        else if (Std.isOfType(graphic, String))
        {
            frames = Paths.parseSprite(graphic);
        }

        return this;
    }

    /**
     * Loads an image to this sprite from an external or embedded graphic file.
     * 
     * @param graphic       The graphic you want to load.
     * @param animated      Whether the graphic is animated, if it is then `frameWidth` and `frameHeight` must be set.
     * @param frameWidth    The width of the graphic, if not set then it just uses the width of the graphic.
     * @param frameHeight   The height of the graphic, if not set then it just uses the height of the graphic.
     * @param unique        Whether the graphic is unique to this sprite.
     *                      This means that the graphic is a unique instance in HaxeFlixel's graphics cache, so whenever
     *                      you change the `pixels` of this sprite, it wouldn't affect other sprites using the same graphic.
     * @param key           Must be set if you're loading a `BitmapData`.
     */
    override public function loadGraphic(graphic:FlxGraphicAsset, animated:Bool = false, frameWidth:Int = 0, frameHeight:Int = 0, unique:Bool = false, ?key:String):FunkinSprite
    {
        super.loadGraphic(graphic, animated, frameWidth, frameHeight, unique, key);
        return this;
    }

    /**
     * Deletes all the animations stored in the sprite and restores the frame rect so it shows the entire loaded graphic.
     */
    public function restoreGraphic():FunkinSprite
    {
        animation.destroyAnimations();
        frames = graphic.imageFrame;
        return this;
    }

    public function playAnimation(?animation:String, force:Bool = false, reverse:Bool = false, frame:Int = 0):Void
    {
        var validAnimation:String = "";

        if (animation != null && hasAnimation(animation))
        {
            validAnimation = animation;
        }
        else if (hasAnimation(Defaults.DEFAULT_ANIMATION_NAME))
        {
            validAnimation = Defaults.DEFAULT_ANIMATION_NAME;
        }

        this.animation.play(validAnimation, force, reverse, frame);
    }

    /**
     * Adds a new animation to the sprite.
     * 
     * @param animation The animation name.
     * @param frames    The frame indices of the animation.
     * @param framerate The speed the animation should play at, in frames per second.
     * @param looped    Whether or not the animation should loop indefinitely when it finishes playing.
     * @param flipX     Whether the frames of the animation should be flipped horizontally.
     * @param flipY     Whether the frames of the animation should be flipped vertically.
     */
    public function addAnimationByFrameList(?animation:String, ?frames:Array<Int>, framerate:Float = 24, looped:Bool = true, flipX:Bool = false, flipY:Bool = false):Void
    {
        if (animation == null)
        {
            animation = Defaults.DEFAULT_ANIMATION_NAME;
        }

        if (frames == null)
        {
            frames = [0];
        }

        this.animation.add(animation, frames, framerate, looped, flipX, flipY);
    }

    /**
     * Makes the whole sprite an animation.
     * 
     * @param frames    How many frames does the animation have?
     * @param framerate The speed the animation should play at, in frames per second.
     * @param looped    Whether or not the animation should loop indefinitely when it finishes playing.
     * @param flipX     Whether the frames of the animation should be flipped horizontally.
     * @param flipY     Whether the frames of the animation should be flipped vertically.
     */
    public function addAnimationByFrameLength(frames:Int, framerate:Float = 24, looped:Bool = true, flipX:Bool = false, flipY:Bool = false):Void
    {
        if (hasAnimation(Defaults.DEFAULT_ANIMATION_NAME))
        {
            FlxG.log.warn('Sprite already has the default animation set up!');
            return;
        }

        var framesLength:Array<Int> = [for (i in 0...frames) i];
        animation.add(Defaults.DEFAULT_ANIMATION_NAME, framesLength, framerate, looped, flipX, flipY);
        playAnimation();
    }

    /**
     * Gets triggered when an animation finishes playing.
     * @param animation The animation name that just finished playing.
     */
    public function onFinishAnimation(animation:String)
    {
        if (hasAnimation('$animation-loop'))
        {
            playAnimation('$animation-loop');
        }
    }

    /**
     * @param animation The animation name.
     * @return The `FlxAnimation`, if it doesn't exists, returns `Null`.
     */
    public function getAnimation(animation:String):Null<FlxAnimation>
    {
        if (!hasAnimation(animation))
        {
            return null;
        }

        return this.animation.getByName(animation);
    }

    public function hasAnimation(animation:String):Bool
    {
        return this.animation.getByName(animation) != null;
    }

    public function removeAnimation(animation:String):Void
    {
        if (!hasAnimation(animation))
        {
            FlxG.log.warn('You can\'t remove the animation "$animation" because it doesn\'t exists!');
            return;
        }

        getAnimation(animation).destroy();
        @:privateAccess this.animation._animations.remove(animation);
    }
}