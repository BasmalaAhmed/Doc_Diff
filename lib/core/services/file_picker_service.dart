import 'package:file_picker/file_picker.dart';

class FilePickerService {
  Future<String?> pickDirectory() async {
    return FilePicker.getDirectoryPath();
  }
}