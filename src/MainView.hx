package;

import format.gfs_revergelabs.*;
import haxe.ui.containers.VBox;
import haxe.ui.events.MouseEvent;

@:build(haxe.ui.ComponentBuilder.build("assets/main-view.xml"))
class MainView extends VBox {
	public function new() {
		super();
		var soundPath = '../test/assets/snds/cow.snd-wav';
		var packagePath = '../test/assets/gfs/big-floppa.gfs';
		button1.onClick = function(e) {
			button1.text = "Thanks!";
			readGfsFile(packagePath);
		}
	}

	@:bind(button2, MouseEvent.CLICK)
	private function onMyButton(e:MouseEvent) {
		button2.text = "Thanks!";
		var packagePath = '../test/assets/gfs/big-floppa.gfs';
		readGfsFile(packagePath);
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
