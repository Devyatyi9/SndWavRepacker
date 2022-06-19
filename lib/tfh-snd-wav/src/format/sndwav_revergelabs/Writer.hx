package format.sndwav_revergelabs;

import haxe.io.Bytes;
import format.sndwav_revergelabs.Data;

class Writer {
	var o:haxe.io.Output;

	public function new(o) {
		this.o = o;
		o.bigEndian = false;
	}

	public function write(snd:SoundContainer) {
		o.write(snd.unknownData);
		o.writeInt32(snd.soundsCount);
		var i = 0;
		while (i < snd.soundsCount) {
			writeSounds(snd.soundsBlock[i]);
			i++;
		}
		trace('Snd-wav file has been written.');
	}

	function writeSounds(snd:Sound) {
		o.writeInt32(snd.soundLength);
		o.writeString('\x00\x00\x00\x00\x00\x00\x00\x00');
		o.write(snd.soundFile);
	}
}
