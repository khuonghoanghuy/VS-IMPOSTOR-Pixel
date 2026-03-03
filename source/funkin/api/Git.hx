package funkin.api;

#if desktop
import sys.io.Process;

class Git
{
	/**
	 * Returns the latest and current commit's hash.
	 */
	public static function getCommitHash():String
	{
		var process:sys.io.Process = new sys.io.Process("git", ["rev-parse", "HEAD"]);
		if (process.exitCode() != 0)
		{
			var message:String = process.stderr.readAll().toString();
		}

		var commitHash:String = process.stdout.readLine();
		var commitHashSplice:String = commitHash.substr(0, 7);

		process.close();

		return commitHashSplice;
	}
}
#end
