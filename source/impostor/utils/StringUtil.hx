package impostor.utils;

class StringUtil
{
    static var sizeLabels:Array<String> = ["B", "KB", "MB", "GB", "TB"];

    /**
     * Converts a byte size amount to it's human-readable form.
     * @param size The byte size amount to convert.
     */
    public static function getByteSizeString(size:Float):String
    {
        var label:Int = 0;
        var sizesLength:Int = sizeLabels.length;
        while (size >= 1024 && label < sizesLength - 1)
        {
            label++;
            size /= 1024;
        }

        return Std.int(size) + ((label <= 1) ? "" : "." + Std.string(Std.int(size % 1) * 100).lpad("0", 2)) + sizeLabels[label];
    }
}