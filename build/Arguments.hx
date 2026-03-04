package;

using StringTools;

class Arguments
{
	public var length(get, never):Int;

	var arguments:Array<String> = [];

	public function new(args:Array<String>)
	{
		for (rawArg in args)
		{
			if (rawArg.startsWith('-'))
			{
				var argument:String = rawArg.substr(0, 1);

				if (argument.startsWith('-'))
				{
					argument = argument.substr(0, 1);
				}

				arguments.push(argument);
			}
		}
	}

	public function exists(arg:String):Bool
	{
		return arguments.indexOf(arg) >= 0;
	}

	public function getArgument(index:Int):String
	{
		return arguments[index];
	}

	public function getArgumentIndex(argument:String):Int
	{
		return arguments.indexOf(argument);
	}

	function get_length():Int
	{
		return arguments.length;
	}
}
