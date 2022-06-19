package format.gfs_revergelabs;

import sys.io.FileInput;

class Tools {
	public static function getPosition(i:FileInput) {
		var cur = i.tell();
		return cur;
	}

	public static function setPosition(i:FileInput, pos:Int) {
		i.seek(pos, SeekBegin);
	}
}
