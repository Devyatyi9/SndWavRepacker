package;

import sys.FileSystem;
import haxe.io.Path;
import format.sndwav_revergelabs.*;
import format.sndwav_revergelabs.Data;

class SoundsRepacker {
	var i:sys.io.FileInput;

	public function new() {}

	public function unpack(location:String, ?another_location = '', ?ignoreSfx = false) {
		// Reader
		// todo: добавить игнор лист для звуков в конкретных файлах (only character voice)
		if (FileSystem.exists(location)) {} else
			trace("Can't open " + location);
		var i = sys.io.File.read(location);
		trace('Start of file reading snd-wav: "$location"');
		var sndWavFile = new Reader(i).read();
		i.close();

		var path = new haxe.io.Path(location);
		var fileName = path.file;
		if (another_location.length > 0) {
			if (FileSystem.exists(another_location)) {} else {
				FileSystem.createDirectory(another_location);
			}
			another_location = Path.normalize(another_location);
			another_location = Path.addTrailingSlash(another_location);
			path = new haxe.io.Path(another_location);
			trace('Saving location is: "${another_location}"');
		} else
			FileSystem.createDirectory('${path.dir}/${fileName}');
		var soundsInfo = [];
		var jsonSoundsArray = {
			IgnoreList: [],
			soundsInfo: []
		};

		var it = 0;
		while (it < sndWavFile.soundsCount) {
			var soundData = sndWavFile.soundsBlock[it].soundFile;
			var format = sndWavFile.soundsBlock[it].soundFormat;
			var name = '';
			// checking location
			if (another_location.length > 0) {
				name = '${path.dir}/${fileName}_${it + 1}.${format}';
			} else {
				name = '${path.dir}/${fileName}/${fileName}_${it + 1}.${format}';
			}
			sys.io.File.saveBytes(name, soundData);
			var object:SoundJson = {
				SoundNumber: it,
				SoundName: '${fileName}_${it + 1}.${format}',
				Description: ''
			};
			soundsInfo.push(object);
			it++;
		}
		jsonSoundsArray.soundsInfo = soundsInfo;
		var stringifyJson = haxe.Json.stringify(jsonSoundsArray, "\t");
		var save_location;
		// checking location
		if (another_location.length > 0) {
			save_location = Path.withExtension('${path.dir}/${fileName}', "json");
		} else
			save_location = Path.withExtension('${path.dir}/${fileName}/${fileName}', "json");
		sys.io.File.saveContent(save_location, stringifyJson);
		trace('Snd-wav has been unpacked');
	}

	public function repack(location:String, ?another_location = '', ?ignoreSfx = false) {
		// 'location' for snd-wav file and directory
		// 'another_location' only for directory with sounds
		if (FileSystem.exists(location)) {
			var path:Path;
			if (FileSystem.isDirectory(location)) {
				// 'path/cow'
				location = Path.removeTrailingSlashes(location);
				path = new haxe.io.Path(location);
				location = '${location}.snd-wav';
				path = new haxe.io.Path(location);
			} else {
				// 'path/cow.snd-wav'
				path = new haxe.io.Path(location);
			}
			var another_path:Path;
			var configPath:String;
			var dir = '${path.dir}/${path.file}/';
			if (another_location.length > 0) {
				another_location = Path.addTrailingSlash(another_location);
				another_path = new haxe.io.Path(another_location);
				configPath = '${another_path.dir}/${path.file}.json';
				dir = '${another_path.dir}/';
			} else
				configPath = '${path.dir}/${path.file}/${path.file}.json';
			if (FileSystem.exists(configPath)) {} else
				trace("Can't open " + configPath);
			var loadConfig:String = sys.io.File.getContent(configPath);
			// var sndJson:ArrayJson = haxe.Json.parse(loadConfig); // JSON PARSE (failed because of Dynamic type)
			var sndJson:{
				IgnoreList:Array<String>,
				soundsInfo:Array<{SoundNumber:Int, Description:String, SoundName:String}>
			};
			sndJson = tink.Json.parse(loadConfig);
			var i = sys.io.File.read(path.toString());
			trace('Start of file reading snd-wav: "$location"');
			var sndWavFile = new Reader(i).read();
			i.close();
			for (key in sndJson.soundsInfo) {
				var number = key.SoundNumber;
				var soundName = key.SoundName;
				var soundData = sys.io.File.getBytes(dir + soundName);
				sndWavFile.soundsBlock[number].soundLength = soundData.length;
				sndWavFile.soundsBlock[number].soundFile = soundData;
			}
			var o = sys.io.File.write(path.toString());
			trace('Start of file writing snd-wav: "$location"');
			new Writer(o).write(sndWavFile);
			o.close();
			trace('Snd-wav has been repacked');
		}
	}
}
