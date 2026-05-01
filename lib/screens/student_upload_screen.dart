import 'dart:io';
import 'package:path/path.dart' as path;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart' as fp;

class StudentUploadScreen extends StatefulWidget {
  const StudentUploadScreen({super.key});

  @override
  State<StudentUploadScreen> createState() => _StudentUploadScreenState();
}

class _StudentUploadScreenState extends State<StudentUploadScreen> {
  List<UploadedFile> _uploadedFiles = [];

  @override
  void initState() {
    super.initState();
    _uploadedFiles = [
      UploadedFile(
        name: 'Sample_Project_Proposal.pdf',
        filePath: '/samples/sample1.pdf',
        size: '2.4 MB',
        date: DateTime.now().subtract(const Duration(days: 2)),
        fileType: UploadFileType.pdf,
      ),
      UploadedFile(
        name: 'Final_Presentation.pptx',
        filePath: '/samples/sample2.pptx',
        size: '5.1 MB',
        date: DateTime.now().subtract(const Duration(days: 1)),
        fileType: UploadFileType.ppt,
      ),
    ];
  }

  Future<void> _pickFile() async {
    try {
      fp.FilePickerResult? result = await fp.FilePicker.platform.pickFiles(
        type: fp.FileType.custom,
        allowedExtensions: ['pdf', 'ppt', 'pptx'],
        allowMultiple: true,
      );

      if (result != null) {
        setState(() {
          for (var file in result.files) {
            String fileSize = _formatFileSize(file.size);
            String extension = path.extension(file.name).toLowerCase();
            UploadFileType fileType = extension == '.pdf' ? UploadFileType.pdf : UploadFileType.ppt;

            _uploadedFiles.add(UploadedFile(
              name: file.name,
              filePath: file.path ?? '',
              size: fileSize,
              date: DateTime.now(),
              fileType: fileType,
              bytes: file.bytes,
            ));
          }
        });

        _showSnackBar(
          '${result.files.length} file(s) uploaded successfully',
          Colors.green,
        );
      } else {
        _showSnackBar('No file selected', Colors.orange);
      }
    } catch (e) {
      _showSnackBar('Error picking file: $e', Colors.red);
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void _deleteFile(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete File'),
          content: Text('Are you sure you want to delete "${_uploadedFiles[index].name}"?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                setState(() => _uploadedFiles.removeAt(index));
                Navigator.pop(context);
                _showSnackBar('File deleted successfully', Colors.red);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Student Uploads', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_uploadedFiles.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                setState(() => _uploadedFiles.clear());
                _showSnackBar('All files deleted', Colors.red);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Files (PDF/PPT)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
          Expanded(
            child: _uploadedFiles.isEmpty
                ? const Center(child: Text('No files uploaded'))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _uploadedFiles.length,
              itemBuilder: (context, index) {
                final file = _uploadedFiles[index];
                return Card(
                  child: ListTile(
                    leading: Icon(
                      file.fileType == UploadFileType.pdf ? Icons.picture_as_pdf : Icons.slideshow,
                      color: Colors.red,
                    ),
                    title: Text(file.name),
                    subtitle: Text('${file.size} • ${_formatDate(file.date)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _deleteFile(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum UploadFileType { pdf, ppt }

class UploadedFile {
  final String name;
  final String filePath;
  final String size;
  final DateTime date;
  final UploadFileType fileType;
  final Uint8List? bytes;

  UploadedFile({
    required this.name,
    required this.filePath,
    required this.size,
    required this.date,
    required this.fileType,
    this.bytes,
  });
}
