package;

import haxe.io.Path;
import format.gfs_revergelabs.*;
import haxe.ui.containers.dialogs.Dialogs;
import sys.FileSystem;
import FileType;
import haxe.ui.core.Screen;
import haxe.ui.containers.*;
import haxe.ui.core.Component;
import haxe.ui.events.MouseEvent;
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.OpenFileDialog;
import haxe.ui.containers.dialogs.SaveFileDialog;

@:build(haxe.ui.ComponentBuilder.build("assets/main-view.xml"))
class MainView extends VBox {
	public function new() {
		super();
		/*
			Screen.instance.frame.dragAcceptFiles(true);
			Screen.instance.frame.bind(hx.widgets.EventType.DROP_FILES, function(e:hx.widgets.Event) {
				var dfe = e.convertTo(hx.widgets.DropFilesEvent);
				trace(dfe.files);
				trace("on dropped - " + dfe.numberOfFiles);
				theLabel.text = dfe.files.join("\n");
			});
		 */
	}

	private override function onReady() {
		super.ready();
		setupDrop(dropFiled1);
		setupDrop(dropFiled2);
		setupDrop(dropFiled3);
	}

	private function setupDrop(target:Component) {
		target.window.dragAcceptFiles(true);
		target.window.bind(hx.widgets.EventType.DROP_FILES, function(e:hx.widgets.Event) {
			var dfe = e.convertTo(hx.widgets.DropFilesEvent);
			// trace("on dropped - " + dfe.numberOfFiles);
			// theLabel.text = dfe.files.join("\n");
			if (target == dropFiled1) {
				workWithSnd(dfe.files, true, true);
			}
			if (target == dropFiled2) {
				workWithSnd(dfe.files, true, false);
			}
			if (target == dropFiled3) {
				workWithGfs(dfe.files, true);
			}
		});
	}

	@:bind(button1, MouseEvent.CLICK)
	private function buttonUnpackSnd(e:MouseEvent) {
		theLabel.text = "Drop files or press buttons";
		Dialogs.openFile(function(button1, selectedFiles) {
			trace('open file dialog.');
			if (button1 == DialogButton.OK) {
				workWithSnd(selectedFiles, false, true);
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
		theLabel.text = "Drop files or press buttons";
		Dialogs.openFile(function(button2, selectedFiles) {
			trace('open file dialog.');
			if (button2 == DialogButton.OK) {
				workWithSnd(selectedFiles, false, false);
			}
		}, {
			readContents: false,
			title: "Select Snd-wav file",
			readAsBinary: false,
			extensions: FileType.SNDWAV,
			multiple: true
		});
	}

	@:bind(button3, MouseEvent.CLICK)
	private function buttonLoadGfs(e:MouseEvent) {
		theLabel.text = "Status";
		var filesArray = [];
		Dialogs.openFile(function(button1, selectedFiles) {
			trace('open file dialog.');
			if (button1 == DialogButton.OK) {
				filesArray = selectedFiles;
				theLabel.text = "...";
				trace(filesArray[0].fullPath);
				var packagePath = filesArray[0].fullPath;
				new MainFunctions().readGfsFile(packagePath);
				theLabel.text = '${filesArray[0].name} has been loaded';
				var dialog = new GfsWindow();
				dialog.onDialogClosed = function(e:DialogEvent) {
					trace(e.button);
				}
				dialog.showDialog();
				// Dialogs.dialog(Screen.instance.frame, "Test", null, true);
			}
		}, {
			readContents: false,
			title: "Open gfs file",
			readAsBinary: false,
			extensions: FileType.GFS,
			multiple: false
		});
	}

	function workWithGfs(?buttonFilesArray:Array<SelectedFileInfo>, ?dropFilesArray:Array<String>, dfe = false) {
		if (dfe == false) {
			theLabel.text = "...";
			trace(buttonFilesArray[0].fullPath);
			var packagePath = buttonFilesArray[0].fullPath;
			new MainFunctions().readGfsFile(packagePath);
			theLabel.text = '${buttonFilesArray[0].name} has been loaded';
			openGfsDialog();
		} else {
			theLabel.text = "...";
			trace(dropFilesArray[0]);
			var packagePath = dropFilesArray[0];
			var path = new haxe.io.Path(dropFilesArray[0]);
			if (!FileSystem.isDirectory(packagePath) && path.ext == "gfs") {
				new MainFunctions().readGfsFile(packagePath);
				theLabel.text = '${dropFilesArray[0]} has been loaded';
				openGfsDialog();
			}
		}
	}

	function openGfsDialog() {
		var dialog = new GfsWindow();
		dialog.onDialogClosed = function(e:DialogEvent) {
			trace(e.button);
		}
		dialog.showDialog();
		// Dialogs.dialog(Screen.instance.frame, "Test", null, true);
	}

	function workWithSnd(?buttonFilesArray:Array<SelectedFileInfo>, ?dropFilesArray:Array<String>, dfe = false, unpacking = true) {
		if (dfe == false) { // button
			var i = 0;
			while (i < buttonFilesArray.length) {
				theLabel.text = "...";
				trace(buttonFilesArray[i].fullPath);
				var soundPath = buttonFilesArray[i].fullPath;
				if (unpacking == true) { // unpacking
					new MainFunctions().unpackSndWavFile(soundPath);
					theLabel.text = '${buttonFilesArray[i].name} has been unpacked';
				} else { // repacking
					var path = new haxe.io.Path(soundPath);
					if (FileSystem.exists(path.dir + '/' + path.file)) {
						new MainFunctions().repackSndWavFile(soundPath);
						theLabel.text = '${buttonFilesArray[i].name} has been repacked';
					} else {
						trace("Can't open " + buttonFilesArray[i].name + " folder");
						theLabel.text = "Can't open " + buttonFilesArray[i].name + " folder";
					}
				}
				i++;
			}
		} else { // drop
			var i = 0;
			while (i < dropFilesArray.length) {
				theLabel.text = "...";
				trace(dropFilesArray[i]);
				var path = new haxe.io.Path(dropFilesArray[i]);
				if (unpacking == true) { // unpacking
					if (path.ext == "snd-wav") {
						var soundPath = dropFilesArray[i];
						var success = new MainFunctions().unpackSndWavFile(soundPath);
						if (success == true)
							theLabel.text = '${path.file}.${path.ext} has been unpacked';
					} else {
						var soundPath = '${path.dir}\\${path.file}.snd-wav';
						var success = new MainFunctions().unpackSndWavFile(soundPath);
						if (success == true)
							theLabel.text = '${path.file}.snd-wav has been unpacked';
					}
				} else { // repacking
					var soundPath = dropFilesArray[i];
					if (((!FileSystem.isDirectory(soundPath) && path.ext == "snd-wav") && FileSystem.exists(path.dir + '/' + path.file))
						|| (FileSystem.isDirectory(soundPath) && FileSystem.exists(path.dir + '/' + path.file + ".snd-wav"))) {
						new MainFunctions().repackSndWavFile(soundPath);
						theLabel.text = '${path.file}.snd-wav has been repacked';
					} else {
						trace("Can't open " + path.file + ".snd-wav" + " folder");
						theLabel.text = "Can't open " + path.file + ".snd-wav" + " folder";
					}
				}
				i++;
			}
		}
	}
	/*
		@:bind(button3, MouseEvent.CLICK)
		private function onMyButton3(e:MouseEvent) {
			var packagePath = '../test/assets/gfs/big-floppa.gfs';
			readGfsFile(packagePath);
		}
	 */
}

@:build(haxe.ui.macros.ComponentMacros.build("assets/gfs-view.xml"))
class GfsWindow extends Dialog {
	public function new() {
		super();
		// buttons = DialogButton.APPLY | "Custom Button" | DialogButton.CANCEL;
		title = "GFS file";
	}
}
