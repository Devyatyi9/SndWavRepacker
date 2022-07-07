package;

import sys.FileSystem;
import format.gfs_revergelabs.*;

class MainFunctions {
	public function new() {}

	public function unpackSndWavFile(location:String) {
		var value = false;
		if (FileSystem.exists(location)) {
			new SoundsRepacker().unpack(location);
			value = true;
		} else
			trace("Can't open " + location);
		return value;
	}

	public function repackSndWavFile(location:String) {
		var value = false;
		if (FileSystem.exists(location)) {
			new SoundsRepacker().repack(location);
			value = true;
		} else
			trace("Can't open " + location);
		return value;
	}

	public function readGfsFile(location:String) {
		var gi = sys.io.File.read(location);
		trace('Start of gfs file reading: "$location"');
		var gfs = new Reader(gi).read();
		gi.close();
		return gfs;
	}

	function filtrateGfs() {}
}
