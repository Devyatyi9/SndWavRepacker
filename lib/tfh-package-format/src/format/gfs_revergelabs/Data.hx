package format.gfs_revergelabs;

import haxe.Int32;
import haxe.io.Bytes;

typedef GfsHeader = {
	var data_offset:Int32;
	var file_identifier_length:Int32;
	var file_identifier:String;
	var file_version_length:Int32;
	var file_version:String;
	var n_of_files:Int32;
}

typedef GfsFileInfo = {
	var file_path_length:Int32;
	var reference_path:String;
	var reference_length:Int32;
	var reference_alignment:Int32;
}

typedef GfsMetadata = {
	var header:GfsHeader;
	var metaInfBlock:Array<GfsFileInfo>;
}

typedef FileData = {
	var data:Bytes;
	var offset:Int32;
}
