package format.sndwav_revergelabs;

import format.sndwav_revergelabs.Data;

class Reader {
	var i:sys.io.FileInput;

	public function new(i) {
		this.i = i;
		i.bigEndian = false;
	}

	public function read():SoundContainer {
		// Skip unknown data
		var dataLength = Tools.skipUnknownData(i);
		var unknownData = i.read(dataLength);
		var soundsCount = i.readInt32();
		var soundsBlock = [];
		var _ = 0;
		while (_ < soundsCount) {
			var soundFile = parseSounds();
			soundsBlock.push(soundFile);
			_++;
		}
		trace('Snd-wav file has been read.');
		return {
			unknownData: unknownData,
			soundsCount: soundsCount,
			soundsBlock: soundsBlock
		}
	}

	function parseSounds():Sound {
		var S_OGG = 0x5367674F;
		var S_RIFF = 0x46464952;
		var soundLength = i.readInt32();
		i.read(8);
		var soundFile = i.read(soundLength);
		var fileTag = soundFile.getInt32(0);
		var soundFormat = ogg;
		if (fileTag == S_OGG) {
			soundFormat = ogg;
		} else if (fileTag == S_RIFF) {
			soundFormat = wav;
		}
		return {
			soundLength: soundLength,
			soundFormat: soundFormat,
			soundFile: soundFile
		}
	}
}
