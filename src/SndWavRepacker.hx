package;

import hx.widgets.Window;
import format.gfs_revergelabs.*;
import haxe.ui.HaxeUIApp;

class SndWavRepacker {
	public static function main() {
		var app = new HaxeUIApp();

		var soundPath = '../test/assets/snds/cow.snd-wav';
		var packagePath = '../test/assets/gfs/big-floppa.gfs';

		app.ready(function() {
			app.addComponent(new MainView());
			// begin
			// app.registerEvent();
			// var UnpackSnds = unpackSndWavFile(soundPath);
			readGfsFile(packagePath);
			// end
			app.start();
		});
	}

	static function unpackSndWavFile(location:String) {
		// new SoundsRepacker().unpack(location, another_location);
		new SoundsRepacker().unpack(location);
	}

	static function readGfsFile(location:String) {
		var gi = sys.io.File.read(location);
		trace('Start of gfs file reading: "$location"');
		var gfs = new Reader(gi).read();
		gi.close();
		return gfs;
	}
}
