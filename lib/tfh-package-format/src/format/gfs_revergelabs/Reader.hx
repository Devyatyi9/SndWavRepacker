package format.gfs_revergelabs;

import haxe.io.Bytes;
import haxe.Int32;
import format.gfs_revergelabs.Data;

class Reader {
	var i:sys.io.FileInput;

	public function new(i) {
		this.i = i;
		i.bigEndian = true;
	}

	public function read():GfsMetadata {
		var header = parseHeader();
		var metaInfBlock = [];
		var _ = 0;
		while (_ < header.n_of_files) {
			metaInfBlock.push(fileInfo());
			_++;
		}
		trace('Gfs header and metadata has been read.');
		return {
			header: header,
			metaInfBlock: metaInfBlock
		}
	}

	public function getFile(?name:String = '', ?index:Int32 = -1) {
		var gfsMeta = read();
		var data = Bytes.alloc(0);
		var running_offset = gfsMeta.header.data_offset;
		var result = {
			data: data,
			offset: running_offset
		};
		// search by name
		if (name.length != 0 || index >= 0) {
			if (name.length != 0) {
				var exist = false;
				var fileCount = 0;
				while (fileCount < gfsMeta.header.n_of_files) {
					if (gfsMeta.metaInfBlock[fileCount].reference_path == name) {
						exist = true;
						var fileIndex = 0;
						// skip files behind found index
						while (fileIndex != fileCount) {
							var skip = true;
							var fileDataInstance = fileData(fileIndex, running_offset, gfsMeta.metaInfBlock, skip);
							running_offset = fileDataInstance.running_offset;
							fileIndex++;
						}
						var fileDataInstance = fileData(fileIndex, running_offset, gfsMeta.metaInfBlock);
						var data = fileDataInstance.fData;
						var offset = fileDataInstance.running_offset - gfsMeta.metaInfBlock[fileIndex].reference_length;
						result = {
							data: data,
							offset: offset
						};
						trace('File ${name} has been read.');
					}
					fileCount++;
				}
				if (exist == false) {
					trace('File ${name} not found.');
					result.offset = -1;
				}
			}
			// search by index
			if (index >= 0) {
				var exist = false;
				if (index < gfsMeta.header.n_of_files) {
					exist = true;
					var fileCount = 0;
					// skip files behind index
					while (fileCount != index) {
						var skip = true;
						var fileDataInstance = fileData(fileCount, running_offset, gfsMeta.metaInfBlock, skip);
						running_offset = fileDataInstance.running_offset;
						fileCount++;
					}
					var fileDataInstance = fileData(index, running_offset, gfsMeta.metaInfBlock);
					var data = fileDataInstance.fData;
					var offset = fileDataInstance.running_offset - gfsMeta.metaInfBlock[index].reference_length;
					result = {
						data: data,
						offset: offset
					};
					trace('File by index ${index} has been read.');
				}
				if (exist == false) {
					trace('File by index ${index} not found.');
					result.offset = -1;
				}
			}
		}
		return result;
	}

	function parseHeader():GfsHeader {
		var data_offset = i.readInt32();
		if (data_offset < 48)
			throw 'Gfs file header is too short.';
		i.readInt32();
		var file_identifier_length = i.readInt32();
		var file_identifier = i.readString(file_identifier_length);
		if (file_identifier != 'Reverge Package File')
			throw 'File is not a valid gfs file.';
		i.readInt32();
		var file_version_length = i.readInt32();
		var file_version = i.readString(file_version_length);
		i.readInt32();
		var n_of_files = i.readInt32();

		return {
			data_offset: data_offset,
			file_identifier_length: file_identifier_length,
			file_identifier: file_identifier,
			file_version_length: file_version_length,
			file_version: file_version,
			n_of_files: n_of_files
		}
	}

	function fileInfo():GfsFileInfo {
		i.readInt32();
		var file_path_length = i.readInt32();
		var reference_path = i.readString(file_path_length);
		i.readInt32();
		var reference_length = i.readInt32();
		var reference_alignment = i.readInt32();

		return {
			file_path_length: file_path_length,
			reference_path: reference_path,
			reference_length: reference_length,
			reference_alignment: reference_alignment
		}
	}

	function getMultipleFiles(header, running_offset, metaInfBlock) {
		var dataBlock = [];
		var _ = 0;
		while (_ < header.n_of_files) {
			var fileDataInstance = fileData(_, running_offset, metaInfBlock);
			dataBlock.push(fileDataInstance.fData);
			running_offset = fileDataInstance.running_offset;
			_++;
		}
		return dataBlock;
	}

	function fileData(index:Int32, running_offset:Int32, metaInfBlock, ?skip:Bool = false) {
		var data_offset = running_offset;
		running_offset += (metaInfBlock[index].reference_alignment - (running_offset % metaInfBlock[index].reference_alignment)) % metaInfBlock[index].reference_alignment;
		// skip empty space (alignment)
		i.read(running_offset - data_offset);
		var size = metaInfBlock[index].reference_length;
		var fData = Bytes.alloc(0);

		if (size > 0 && skip == false) {
			fData = i.read(size);
		} else if (size > 0 && skip == true) {
			i.read(size);
		}
		return {
			running_offset: running_offset += metaInfBlock[index].reference_length,
			fData: fData
		};
	}
}
