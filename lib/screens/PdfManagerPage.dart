import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PdfManagerPage extends StatefulWidget {
  @override
  _PdfManagerPageState createState() => _PdfManagerPageState();
}

class _PdfManagerPageState extends State<PdfManagerPage> {
  List<File> pdfFiles = [];

  @override
  void initState() {
    super.initState();
    _loadPdfFiles();
  }

  // تحميل الملفات المتاحة من المجلد
  Future<void> _loadPdfFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final pdfDirectory = Directory('${dir.path}/pdfs');
    if (!await pdfDirectory.exists()) {
      await pdfDirectory.create();
    }
    final List<FileSystemEntity> files = pdfDirectory.listSync();
    setState(() {
      pdfFiles = files
          .where((file) => file.path.endsWith('.pdf'))
          .map((file) => File(file.path))
          .toList();
    });
  }

  // اختيار ملف PDF من الجهاز
  Future<void> _pickPdfFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      File selectedFile = File(result.files.single.path!);
      final dir = await getApplicationDocumentsDirectory();
      final pdfDirectory = Directory('${dir.path}/pdfs');
      if (!await pdfDirectory.exists()) {
        await pdfDirectory.create();
      }
      String newPath = '${pdfDirectory.path}/${selectedFile.uri.pathSegments.last}';
      await selectedFile.copy(newPath);
      _loadPdfFiles(); // تحديث القائمة بعد إضافة الملف
    }
  }

  // حذف ملف PDF
  Future<void> _deletePdfFile(File pdfFile) async {
    await pdfFile.delete();
    _loadPdfFiles(); // تحديث القائمة بعد الحذف
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إدارة ملفات PDF'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickPdfFile,
            child: Text('إضافة ملف PDF'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pdfFiles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(pdfFiles[index].path.split('/').last),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deletePdfFile(pdfFiles[index]),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfViewerPage(
                          pdfFile: pdfFiles[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PdfViewerPage extends StatelessWidget {
  final File pdfFile;

  PdfViewerPage({required this.pdfFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('عرض ملف PDF'),
      ),
      body: PDFView(
        filePath: pdfFile.path,
      ),
    );
  }
}
