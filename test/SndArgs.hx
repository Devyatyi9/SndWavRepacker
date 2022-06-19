package;

import format.sndwav_revergelabs.*;

class SndArgs {
	static function main() {
		// Creating an array using array syntax and explicit type definition Array<String>
		// var strings:Array<String> = ["Apple", "Pear", "Banana"];
		// trace(strings);

		// var chars = [for (c in 65...70) String.fromCharCode(c)];
		// trace(chars); // ['A','B','C','D','E']

		// Save file to disk
		// var user = {name: "Mark", age: 31};
		// var content:String = haxe.Json.stringify(user);
		// sys.io.File.saveContent('src/my_file.json', content);

		/*
			// Cross platform paths
			// var location = "assets/snds/cow";
			var location = "assets/snds/cow.snd-wav";
			var path = new haxe.io.Path(location);
			trace(path.dir); // path/to
			trace(path.file); // file
			trace(path.ext); // txt
		 */
		/*
			// combining path
			var directory = "path/to/";
			var file = "./file.txt";
			trace(haxe.io.Path.join([directory, file])); // path/to/file.txt
			trace('\n');
		 */

		// Check path
		// trace("File location: " + location);
		trace("Program path: " + Sys.programPath());
		trace("Working directory: " + Sys.getCwd());

		// Command Line Arguments
		cmdRun();

		// Read snd-wav
		// sndwavReadWrite(location);
		// new SoundsRepacker().unpack(location);
		// new SoundsRepacker().repack(location);
	}

	static function cmdRun() {
		var args = Sys.args();
		trace(args);
		var i = 0;
		while (i < args.length) {
			if (args[i] == '-unpack') {
				var location = args[i + 1];
				var another_location = '';
				if (args.length > 2) {
					another_location = args[i + 2];
				}
				new SoundsRepacker().unpack(location, another_location);
			} else if (args[i] == '-repack') {
				var location = args[i + 1];
				var another_location = '';
				if (args.length > 2) {
					another_location = args[i + 2];
				}
				new SoundsRepacker().repack(location, another_location);
			} else {
				trace('SndWavRepacker.exe -unpack "files/cow.snd-wav" <"files/velvet">');
				trace('SndWavRepacker.exe -repack "files/cow.snd-wav" <"files/velvet">');
			}
			i++;
		}
		if (args.length < 1) {
			trace('SndWavRepacker.exe -unpack "files/cow.snd-wav" <"files/velvet">');
			trace('SndWavRepacker.exe -repack "files/cow.snd-wav" <"files/velvet">');
		}
	}

	// function new() {};
	// Read / Write Test
	static function sndwavReadWrite(location:String) {
		// Snd-wav Read
		var i = sys.io.File.read(location);
		trace('Start of file reading snd-wav: "$location"');
		var mySndWav = new Reader(i).read();
		trace(mySndWav.soundsCount);
		i.close();

		// Snd-wav Write
		var save_location = "test/TestLobby.snd-wav";
		var o = sys.io.File.write(save_location);
		trace('Start of file writing snd-wav: "$save_location"');
		new Writer(o).write(mySndWav);
		o.close();
	}
}
