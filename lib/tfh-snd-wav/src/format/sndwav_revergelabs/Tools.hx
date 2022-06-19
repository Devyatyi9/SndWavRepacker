package format.sndwav_revergelabs;

import sys.io.FileInput;

class Tools {
	public static function checkInputLength(i:FileInput) {
		var cur = i.tell();
		i.seek(0, SeekBegin);
		var l = i.readAll().length;
		i.seek(cur, SeekBegin);
		return l;
	}

	public static function skipUnknownData(i:FileInput) {
		var S_OGG = 0x5367674F;
		var S_RIFF = 0x46464952;
		var fileLength = Tools.checkInputLength(i);
		var tag:Int;
		var it = 4;
		while (it < (fileLength - 3)) {
			i.seek(it, SeekBegin);
			tag = i.readInt32();
			if (tag == S_OGG || tag == S_RIFF)
				break;
			it++;
		}
		i.seek(0, SeekBegin);
		// Check file
		if (it == (fileLength - 3)) {
			trace("File corrupted or not a valid SND-WAV file.");
			throw(haxe.Exception);
		}
		// return to sounds count
		return it - 16;
	}
}
