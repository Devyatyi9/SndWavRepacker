package;

import format.gfs_revergelabs.*;
import haxe.ui.containers.dialogs.Dialogs;
import sys.FileSystem;
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
	@:bind(button1, MouseEvent.CLICK)
	private function buttonUnpackSnd(e:MouseEvent) {
		theLabel.text = "Status";
		var filesArray = [];
		Dialogs.openFile(function(button1, selectedFiles) {
			trace('open file dialog.');
			if (button1 == DialogButton.OK) {
				filesArray = selectedFiles;
				var i = 0;
				while (i < filesArray.length) {
					theLabel.text = "...";
					trace(filesArray[i].fullPath);
					var soundPath = filesArray[i].fullPath;
					unpackSndWavFile(soundPath);
					theLabel.text = '${filesArray[i].name} has been unpacked';
					i++;
				}
			}
		}, {
			readContents: false,
			title: "Select Snd-wav file",
			readAsBinary: false,
			extensions: FileType.SNDWAV,
			multiple: true
		});
	}

	@:bind(button2, MouseEvent.CLICK)
	private function buttonRepackSnd(e:MouseEvent) {
		theLabel.text = "Status";
		var filesArray = [];
		Dialogs.openFile(function(button2, selectedFiles) {
			trace('open file dialog.');
			if (button2 == DialogButton.OK) {
				filesArray = selectedFiles;
				var i = 0;
				while (i < filesArray.length) {
					theLabel.text = "...";
					trace(filesArray[i].fullPath);
					var soundPath = filesArray[i].fullPath;
					var path = new haxe.io.Path(soundPath);
					if (FileSystem.exists(path.dir + '/' + path.file)) {
						repackSndWavFile(soundPath);
						theLabel.text = '${filesArray[i].name} has been repacked';
					} else {
						trace("Can't open " + filesArray[i].name + " folder");
						theLabel.text = "Can't open " + filesArray[i].name + " folder";
					}
					i++;
				}
			}
		}, {
			readContents: false,
			title: "Select Snd-wav file",
			readAsBinary: false,
			extensions: FileType.SNDWAV,
			multiple: true
		});
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
	function unpackSndWavFile(location:String) {
		new SoundsRepacker().unpack(location);
	}

	function repackSndWavFile(location:String) {
		new SoundsRepacker().repack(location);
	}

	function readGfsFile(location:String) {
		var gi = sys.io.File.read(location);
		trace('Start of gfs file reading: "$location"');
		var gfs = new Reader(gi).read();
		gi.close();
		return gfs;
	}
}
