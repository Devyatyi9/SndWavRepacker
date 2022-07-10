package;

import format.gfs_revergelabs.Reader;
import format.gfs_revergelabs.Writer;

class GfsTest {
	static function main() {
		// Creating an array using array syntax and explicit type definition Array<String>
		// var strings:Array<String> = ["Apple", "Pear", "Banana"];
		// trace(strings);

		// var chars = [for (c in 65...70) String.fromCharCode(c)];
		// trace(chars); // ['A','B','C','D','E']

		// Save file to disk
		// var user = {name: "Mark", age: 31};
		// var content:String = haxe.Json.stringify(user);
		// sys.io.File.saveContent('test/my_file.json', content);

		// Cross platform paths
		// var location = "test/assets/gfs/empty-container-04.gfs";
		// var location = "test/assets/gfs/empty-container-04-aligned.gfs";
		var location = "test/assets/gfs/test-failik.gfs";
		#if (debug && cpp)
		location = "../test/assets/gfs/test-failik.gfs";
		#end
		var path = new haxe.io.Path(location);
		trace(path.dir); // path/to
		trace(path.file); // file
		trace(path.ext); // txt

		// combining path
		var directory = "path/to/";
		var file = "./file.txt";
		trace(haxe.io.Path.join([directory, file])); // path/to/file.txt
		trace('\n');

		// Check path
		trace("File location: " + location);
		trace("Program path: " + Sys.programPath());
		trace("Working directory: " + Sys.getCwd());
		// Start
		gfsTestReadWrite(location);
	}

	// function new() {};
	static function gfsTestReadWrite(location:String) {
		// GFS Read
		var gi = sys.io.File.read(location);
		trace('Start of gfs file reading: "$location"');
		var myGFS = new Reader(gi).read();
		trace(myGFS.header);
		// gi.seek(0, SeekBegin);
		var testFile2 = new Reader(gi).getFile(17); // 'test-file.txt'
		trace(testFile2.data);
		trace(testFile2.offset);
		// gi.seek(0, SeekBegin);
		var testFile1 = new Reader(gi).getFile('AI/combos/cow/Cow_3_WORK.ini'); // 'test-file2.txt'
		trace(testFile1.data);
		trace(testFile1.offset);
		gi.close();

		// /*
		// GFS Write
		var file_location = "test/assets/gfs/big-floppa.gfs";
		#if (debug && cpp)
		file_location = "../test/assets/gfs/big-floppa.gfs";
		#end
		// 'temp/true_color_sprites/velvet.txt'
		// 721

		var go = sys.io.File.update(file_location);
		trace('Start of gfs file writing: "$file_location"');
		new Writer(go).updateFile(testFile1, 1);
		go.close();
		//  */
	}

	static function unpackGfs(location:String) {
		var gi = sys.io.File.read(location);
		trace('Start of gfs file reading: "$location"');
		var thisGFS = new Reader(gi).read();
		// trace(thisGFS.header);
		var i = 0;
		while (i < thisGFS.metaInfBlock.length) {
			var testFile2 = new Reader(gi).getFile(i, thisGFS);
			var path = thisGFS.metaInfBlock[i].reference_path;
			i++;
		}
		gi.close();
	}

	static function packGfs() {}
}
