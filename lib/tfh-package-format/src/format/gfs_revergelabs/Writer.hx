package format.gfs_revergelabs;

import format.gfs_revergelabs.Data;

class Writer {
	var o:sys.io.FileOutput;

	public function new(o) {
		this.o = o;
		o.bigEndian = true;
	}

	public function write(gfs) {
		writeHeader(gfs);
	}

	function writeHeader(gfs:GfsHeader) {
		o.writeInt32(gfs.data_offset);
		o.writeInt32(1);
		o.writeInt32(gfs.file_identifier_length);
		o.writeString(gfs.file_identifier);
		o.writeInt32(1);
		o.writeInt32(gfs.file_version_length);
		o.writeString(gfs.file_version);
		o.writeInt32(1);
		o.writeInt32(gfs.n_of_files);
	}

	public function updateFile(data:FileData, oldLength:Int) {
		// gfs.data_offset
		// gfs.n_of_files
		trace(data.offset);
		trace(data.data);
		// o.writeFullBytes(s:Bytes, pos:Int, len:Int):Void
		// o.writeFullBytes(data.data, data.offset, data.data.length);
		trace('test writer.');
		// запись чанками
	}

	function addFile() {}
}
