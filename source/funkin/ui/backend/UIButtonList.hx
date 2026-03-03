package funkin.ui.backend;

class UIButtonList extends UIButton
{
    public var minItemWidth(default, set):Float = 80;
    public var itemsLength(default, null):Int = 0;

    public var isOpen(default, null):Bool;

    var items:Array<UIButton>;

    public function new(label:String = "")
    {
        super(label);

        items = new Array<UIButton>();

        isOpen = false;
    }

    public function addItem(item:UIButton):UIButton
    {
        if (item == null)
            return item;

        if (items.indexOf(item) >= 0)
            return item;

        /*
        if (itemsLength > 0)
        {
            item.y = items[itemsLength - 1].y + items[itemsLength - 1].height;
        }
        */

        item.cameras = this.cameras;
        item.text.fieldWidth = 0;
        item.text.alignment = LEFT;

        add(item);
        items.push(item);
        itemsLength++;

        resizeAllItemsAccordingly();

        if (!isOpen) item.kill();

        return item;
    }

    function resizeAllItemsAccordingly()
    {
        var maxWidth:Float = 0;

        for (item in items)
        {
            if (item.width > maxWidth)
                maxWidth = item.width;
        }

        if (maxWidth < minItemWidth)
        {
            maxWidth = minItemWidth;
        }

        var lowestPos:Float = this.y + this.box.height;
        for (item in items)
        {
            item.resize(Std.int(maxWidth));
            item.y = lowestPos;
            lowestPos += item.height;

            item.text.x = item.x + 4;
            item.text.fieldWidth = item.box.width - 8;
        }
    }

    override public function update(elapsed:Float)
    {
        if (!isOpen)
        {
            super.update(elapsed);
        }
        else
        {
            for (item in items)
            {
                item.update(elapsed);
            }

            final overlapping:Bool = checkAnyOverlap();

            if (FlxG.mouse.justPressed && !overlapping)
            {
                release();
            }
        }
    }

    public function checkAnyOverlap():Bool
    {
        for (item in items)
        {
            if (item.checkOverlap())
                return true;
        }

        return false;
    }

    override public function press()
    {
        super.press();
        openDropdown();
    }

    override public function release()
    {
        super.release();
        closeDropdown();
    }

    function openDropdown()
    {
        isOpen = true;

        for (item in items)
        {
            item.revive();
        }
    }

    function closeDropdown()
    {
        isOpen = false;

        for (item in items)
        {
            item.kill();
        }
    }

    function set_minItemWidth(value:Float):Float
    {
        minItemWidth = value;
        resizeAllItemsAccordingly();
        return value;
    }
}