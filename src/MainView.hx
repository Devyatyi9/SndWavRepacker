package;

import hx.widgets.Window;
import format.gfs_revergelabs.*;
import haxe.ui.containers.dialogs.Dialogs;
import FileType;
import haxe.ui.containers.*;
import haxe.ui.events.MouseEvent;
import haxe.ui.core.Screen;

@:build(haxe.ui.ComponentBuilder.build("assets/main-view.xml"))
class MainView extends VBox {
	public function new(parent:Window) {
		super(parent);
	}

	@:bind(button1, MouseEvent.CLICK)
	private function onMyButton1(e:MouseEvent) {
		button1.text = "Thanks! From button 1";
		var packagePath = '../test/assets/gfs/big-floppa.gfs';
		readGfsFile(packagePath);
	}

	@:bind(button2, MouseEvent.CLICK)
	private function onMyButton2(e:MouseEvent) {
		button2.text = "Thanks! From button 2";
		var soundPath = '../test/assets/snds/cow.snd-wav';
		unpackSndWavFile(soundPath);
	}

	@:bind(button3, MouseEvent.CLICK)
	private function onMyButton3(e:MouseEvent) {
		Dialogs.openBinaryFile("Open Snd-wav File", FileType.SNDWAV, function(selectedFile) {
			trace(selectedFile.bytes.length);
		});
		trace('open file dialog.');
	}

	Screen.instance.frame.dragAcceptFiles(true);
	Screen.instance.frame.bind(hx.widgets.EventType.DROP_FILES, function(e:hx.widgets.Event) {
		var dfe = e.convertTo(hx.widgets.DropFilesEvent);
		trace("on dropped - " + dfe.numberOfFiles);
		theLabel.text = dfe.files.join("\n");
	});

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
