package funkin.graphics.shaders;

import flixel.graphics.tile.FlxGraphicsShader;

class RGBPalette extends FlxGraphicsShader
{
    /**
     * The red channel of the palette.
     */
    public var red(default, set):FlxColor;

    /**
     * The green channel of the palette.
     */
    public var green(default, set):FlxColor;

    /**
     * The blue channel of the palette.
     */
    public var blue(default, set):FlxColor;

    /**
     * How much to multiply the values of each channel.
     */
    public var multiplier(default, set):Float;

    function set_red(value:FlxColor):FlxColor
    {
        this.red = value;
        this.r.value = [value.redFloat, value.greenFloat, value.blueFloat];
        return value;
    }

    function set_green(value:FlxColor):FlxColor
    {
        this.green = value;
        this.g.value = [value.redFloat, value.greenFloat, value.blueFloat];
        return value;
    }

    function set_blue(value:FlxColor):FlxColor
    {
        this.blue = value;
        this.b.value = [value.redFloat, value.greenFloat, value.blueFloat];
        return value;
    }

    function set_multiplier(value:Float):Float
    {
        this.multiplier = value;
        this.mult.value = [value];
        return value;
    }

    @:glFragmentSource("
        #pragma header

        uniform vec3 r;
        uniform vec3 g;
        uniform vec3 b;
        uniform float mult;

        vec4 flixel_texture2DCustom(sampler2D bitmap, vec2 coord)
        {
            vec4 color = flixel_texture2D(bitmap, coord);
            if (!hasTransform || color.a == 0.0 || mult == 0.0) {
                return color;
            }

            vec4 newColor = color;
            newColor.rgb = min(color.r * r + color.g * g + color.b * b, vec3(1.0));
            newColor.a = color.a;

            color = mix(color, newColor, mult);

            if(color.a > 0.0) {
                return vec4(color.rgb, color.a);
            }
            return vec4(0.0, 0.0, 0.0, 0.0);
        }

        void main()
        {
            gl_FragColor = flixel_texture2DCustom(bitmap, openfl_TextureCoordv);
        }
    ")
    public function new(?red:FlxColor, ?green:FlxColor, ?blue:FlxColor)
    {
        super();

        this.red = red;
        this.green = green;
        this.blue = blue;

        this.multiplier = 1.0;
    }
}