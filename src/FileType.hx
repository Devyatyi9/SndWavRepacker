package;

import haxe.ui.containers.dialogs.Dialogs;

class FileType extends FileDialogTypes {
	public static var SNDWAV(get, null):Array<FileDialogExtensionInfo>;

	private static function get_SNDWAV():Array<FileDialogExtensionInfo> {
		return [{label: "*.snd-wav", extension: "snd-wav"}];
	}

	public static var GFS(get, null):Array<FileDialogExtensionInfo>;

	private static function get_GFS():Array<FileDialogExtensionInfo> {
		return [{label: "*.gfs", extension: "gfs"}];
	}
}
