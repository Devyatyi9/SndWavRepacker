package;

import format.gfs_revergelabs.*;
import haxe.ui.containers.dialogs.Dialogs;
import FileType;
import haxe.ui.containers.*;
import haxe.ui.events.MouseEvent;
import haxe.ui.core.Screen;
import haxe.ui.containers.dialogs.Dialog.DialogButton;
import haxe.ui.containers.dialogs.OpenFileDialog;
import haxe.ui.containers.dialogs.SaveFileDialog;

@:build(haxe.ui.ComponentBuilder.build("assets/main-view.xml"))
class MainView extends VBox {
	public function new() {
		super();
		Screen.instance.frame.dragAcceptFiles(true);
		Screen.instance.frame.bind(hx.widgets.EventType.DROP_FILES, function(e:hx.widgets.Event) {
			var dfe = e.convertTo(hx.widgets.DropFilesEvent);
			trace(dfe.files);
			trace("on dropped - " + dfe.numberOfFiles);
			theLabel.text = dfe.files.join("\n");
		});
	}

	/*
		@:bind(button1, MouseEvent.CLICK)
		private function onMyButton1(e:MouseEvent) {
			button1.text = "Thanks! From button 1";
			var packagePath = '../test/assets/gfs/big-floppa.gfs';
			readGfsFile(packagePath);
		}
	 */
	@:bind(button2, MouseEvent.CLICK)
	private function buttonUnpackSnd(e:MouseEvent) {
		var filesArray = [];
		Dialogs.openFile(function(button2, selectedFiles) {
			if (button2 == DialogButton.OK) {
				filesArray = selectedFiles;
				trace(filesArray[0].fullPath);
			}
		}, {
			readContents: false,
			title: "Select Snd-wav file",
			readAsBinary: false,
			extensions: FileType.SNDWAV,
			multiple: false
		});
		trace('open file dialog.');
		var soundPath = filesArray[0].fullPath;
		unpackSndWavFile(soundPath);
	}

	@:bind(button3, MouseEvent.CLICK)
	private function buttonRepackSnd(e:MouseEvent) {
		// var dialog = new openFile();
		var filesArray = [];
		Dialogs.openFile(function(button3, selectedFiles) {
			if (button3 == DialogButton.OK) {
				filesArray = selectedFiles;
				trace(filesArray[0].fullPath);
			}
		}, {
			readContents: false,
			title: "Select Snd-wav file",
			readAsBinary: false,
			extensions: FileType.SNDWAV,
			multiple: false
		});
		trace('open file dialog.');
		var soundPath = filesArray[0].fullPath;
		repackSndWavFile(soundPath);
	}

	/*
		Dialogs.openBinaryFile("Open Snd-wav file", FileType.SNDWAV, function(selectedFile) {
			var options = {
				readContents: false,
				readAsBinary: true,
				multiple: true
			}
			trace(selectedFile.bytes.length);
		});
	 */
	/*
		@:bind(button2, MouseEvent.CLICK)
		private function onMyButton2(e:MouseEvent) {
			button2.text = "Thanks! From button 2";
			var soundPath = '../test/assets/snds/cow.snd-wav';
			unpackSndWavFile(soundPath);
		}
	 */
	static function unpackSndWavFile(location:String) {
		// new SoundsRepacker().unpack(location, another_location);
		new SoundsRepacker().unpack(location);
	}

	static function repackSndWavFile(location:String) {
		new SoundsRepacker().repack(location);
	}

	static function readGfsFile(location:String) {
		var gi = sys.io.File.read(location);
		trace('Start of gfs file reading: "$location"');
		var gfs = new Reader(gi).read();
		gi.close();
		return gfs;
	}
}
