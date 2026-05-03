import 'dart:io';
import 'package:path/path.dart' as path;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart' as fp;
import '../theme/app_theme.dart';

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

  Future<void> _deleteFile(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Delete File'),
          content: Text('Are you sure you want to delete "${_uploadedFiles[index].name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() => _uploadedFiles.removeAt(index));
      _showSnackBar('File deleted successfully', AppTheme.primary);
    }
  }

  Future<void> _deleteAllFiles() async {
    if (_uploadedFiles.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Delete All Files'),
          content: const Text('Are you sure you want to delete all files?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
              ),
              child: const Text('Delete All'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() => _uploadedFiles.clear());
      _showSnackBar('All files deleted', AppTheme.primary);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Student Uploads',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_uploadedFiles.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.white),
              onPressed: _deleteAllFiles,
              tooltip: 'Delete all files',
            ),
        ],
      ),
      body: Column(
        children: [
          // Upload Button Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.upload_file, size: 24),
                  label: const Text(
                    'Upload Files (PDF/PPT)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Supported formats: PDF, PPT, PPTX',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Files List Section
          Expanded(
            child: _uploadedFiles.isEmpty
                ? _buildEmptyState()
                : Column(
              children: [
                // Header with count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        'Uploaded Files',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_uploadedFiles.length}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _uploadedFiles.length,
                    itemBuilder: (context, index) {
                      final file = _uploadedFiles[index];
                      return _buildFileCard(file, index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No files uploaded',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the upload button to add PDF or PPT files',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileCard(UploadedFile file, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // File Icon with gradient background
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: file.fileType == UploadFileType.pdf
                      ? [AppTheme.primary, AppTheme.primaryLight]
                      : [Colors.orange.shade400, Colors.deepOrange.shade700],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: (file.fileType == UploadFileType.pdf ? AppTheme.primary : Colors.orange).withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                file.fileType == UploadFileType.pdf ? Icons.picture_as_pdf : Icons.slideshow,
                size: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),

            // File Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (file.fileType == UploadFileType.pdf ? AppTheme.primary : Colors.orange).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          file.fileType == UploadFileType.pdf ? 'PDF' : 'PPT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: file.fileType == UploadFileType.pdf ? AppTheme.primary : Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.insert_drive_file, size: 12, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        file.size,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.calendar_today, size: 11, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(file.date),
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Delete Button
            IconButton(
              onPressed: () => _deleteFile(index),
              icon: const Icon(Icons.delete_outline),
              color: AppTheme.primary,
              iconSize: 22,
              tooltip: 'Delete file',
            ),
          ],
        ),
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