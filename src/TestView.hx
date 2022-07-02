package;

import format.gfs_revergelabs.*;
import haxe.ui.containers.dialogs.Dialogs;
import sys.FileSystem;
import FileType;
import haxe.ui.containers.*;
import haxe.ui.events.MouseEvent;
import haxe.ui.core.Screen;
import haxe.ui.core.Component;
import hx.widgets.DropFilesEvent;
import haxe.ui.components.*;
import haxe.ui.containers.dialogs.Dialog.DialogButton;
import haxe.ui.containers.dialogs.OpenFileDialog;
import haxe.ui.containers.dialogs.SaveFileDialog;

@:build(haxe.ui.ComponentBuilder.build("assets/test.xml"))
class TestView extends Box {
	public function new() {
		super();
	}

	private override function onReady() {
		super.ready();
		setupDrop(dropTarget1, theLabel1);
		setupDrop(dropTarget2, theLabel2);
		setupDrop(dropTarget3, theLabel3);
		setupDrop(dropTarget4, theLabel4);
	}

	private function setupDrop(target:Component, label:Label) {
		target.window.dragAcceptFiles(true);
		target.window.bind(hx.widgets.EventType.DROP_FILES, function(e:hx.widgets.Event) {
			var dfe = e.convertTo(DropFilesEvent);
			trace("on dropped - " + dfe.numberOfFiles);
			label.text = dfe.files.join("\n");
		});
	}
}
