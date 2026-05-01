import 'package:flutter/material.dart';
import 'dart:math' as math;

class WhiteboardScreen extends StatefulWidget {
  const WhiteboardScreen({super.key});

  @override
  State<WhiteboardScreen> createState() => _WhiteboardScreenState();
}

class _WhiteboardScreenState extends State<WhiteboardScreen> {
  List<DrawPoint> _points = [];
  List<DrawPath> _paths = [];
  ToolType _currentTool = ToolType.pen;
  Color _currentColor = Colors.red;
  double _currentStrokeWidth = 4.0;

  // For tracking drawing state
  bool _isDrawing = false;
  Offset? _lastPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Whiteboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Clear All Button
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            onPressed: _clearCanvas,
            tooltip: 'Clear canvas',
          ),
          // Save Button
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveWhiteboard,
            tooltip: 'Save drawing',
          ),
        ],
      ),
      body: Column(
        children: [
          // Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Pen Tool
                _buildToolButton(
                  icon: Icons.edit,
                  label: 'Pen',
                  isActive: _currentTool == ToolType.pen,
                  onTap: () {
                    setState(() {
                      _currentTool = ToolType.pen;
                    });
                  },
                ),
                // Eraser Tool - Fixed icon
                _buildToolButton(
                  icon: Icons.cleaning_services,  // ✅ Changed from Icons.eraser
                  label: 'Eraser',
                  isActive: _currentTool == ToolType.eraser,
                  onTap: () {
                    setState(() {
                      _currentTool = ToolType.eraser;
                    });
                  },
                ),
                // Color Selector
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey.shade200,
                ),
                // Color options
                _buildColorOption(Colors.red),
                _buildColorOption(Colors.blue),
                _buildColorOption(Colors.green),
                _buildColorOption(Colors.orange),
                _buildColorOption(Colors.purple),
                _buildColorOption(Colors.black),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey.shade200,
                ),
                // Stroke width
                Row(
                  children: [
                    const Icon(Icons.line_weight, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 100,
                      child: Slider(
                        value: _currentStrokeWidth,
                        min: 2.0,
                        max: 20.0,
                        activeColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            _currentStrokeWidth = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${_currentStrokeWidth.toInt()}',
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Drawing Canvas
          Expanded(
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: Container(
                color: Colors.white,
                child: CustomPaint(
                  painter: WhiteboardPainter(
                    paths: _paths,
                    currentTool: _currentTool,
                    currentColor: _currentColor,
                    currentStrokeWidth: _currentStrokeWidth,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),

          // Bottom info bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _currentTool == ToolType.pen ? Icons.edit : Icons.cleaning_services,  // ✅ Fixed
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_currentTool == ToolType.pen ? 'Pen' : 'Eraser'} mode',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${_getTotalPoints()} points drawn',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.red.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive
              ? Border.all(color: Colors.red, width: 1.5)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.red : Colors.grey.shade700,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.red : Colors.grey.shade700,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentColor = color;
          if (_currentTool == ToolType.eraser) {
            _currentTool = ToolType.pen;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: _currentColor == color
              ? Border.all(color: Colors.red, width: 3)
              : Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: _currentColor == color
              ? [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ]
              : null,
        ),
        child: _currentColor == color
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : null,
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    _isDrawing = true;
    _lastPoint = details.localPosition;

    // Start a new path
    setState(() {
      _paths.add(DrawPath(
        points: [details.localPosition],
        color: _currentTool == ToolType.eraser ? Colors.white : _currentColor,
        strokeWidth: _currentTool == ToolType.eraser ? _currentStrokeWidth * 2 : _currentStrokeWidth,
        isEraser: _currentTool == ToolType.eraser,
      ));
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDrawing) return;

    final currentPoint = details.localPosition;
    if (_lastPoint != null && _paths.isNotEmpty) {
      // Add intermediate points for smooth drawing
      final points = _getPointsBetween(_lastPoint!, currentPoint);

      setState(() {
        points.forEach((point) {
          _paths.last.points.add(point);
        });
      });
    }

    _lastPoint = currentPoint;
  }

  void _onPanEnd(DragEndDetails details) {
    _isDrawing = false;
    _lastPoint = null;
  }

  // Interpolate points between two positions for smooth lines
  List<Offset> _getPointsBetween(Offset start, Offset end) {
    List<Offset> points = [];
    double distance = (end - start).distance;

    if (distance > 1.0) {
      int steps = distance.toInt();
      for (int i = 1; i <= steps; i++) {
        double t = i / steps;
        double dx = start.dx + (end.dx - start.dx) * t;
        double dy = start.dy + (end.dy - start.dy) * t;
        points.add(Offset(dx, dy));
      }
    } else {
      points.add(end);
    }

    return points;
  }

  void _clearCanvas() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Canvas'),
          content: const Text('Are you sure you want to clear everything?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _paths.clear();
                  _points.clear();
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Canvas cleared'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _saveWhiteboard() {
    // Simulate saving
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Drawing saved! (${_getTotalPoints()} points)'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
    // In a real app, you would save to file or share
  }

  int _getTotalPoints() {
    int total = 0;
    for (var path in _paths) {
      total += path.points.length;
    }
    return total;
  }
}

// Custom Painter for drawing
class WhiteboardPainter extends CustomPainter {
  final List<DrawPath> paths;
  final ToolType currentTool;
  final Color currentColor;
  final double currentStrokeWidth;

  WhiteboardPainter({
    required this.paths,
    required this.currentTool,
    required this.currentColor,
    required this.currentStrokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var path in paths) {
      if (path.points.isEmpty) continue;

      final paint = Paint()
        ..color = path.isEraser ? Colors.white : path.color
        ..strokeWidth = path.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      // Draw the path as connected lines
      for (int i = 0; i < path.points.length - 1; i++) {
        canvas.drawLine(path.points[i], path.points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(WhiteboardPainter oldDelegate) {
    return oldDelegate.paths != paths ||
        oldDelegate.currentTool != currentTool ||
        oldDelegate.currentColor != currentColor ||
        oldDelegate.currentStrokeWidth != currentStrokeWidth;
  }
}

// Data models
enum ToolType { pen, eraser }

class DrawPath {
  List<Offset> points;
  Color color;
  double strokeWidth;
  bool isEraser;

  DrawPath({
    required this.points,
    required this.color,
    required this.strokeWidth,
    this.isEraser = false,
  });
}

// Alternative: Simple point-based drawing (simpler version)
class SimpleWhiteboardScreen extends StatefulWidget {
  const SimpleWhiteboardScreen({super.key});

  @override
  State<SimpleWhiteboardScreen> createState() => _SimpleWhiteboardScreenState();
}

class _SimpleWhiteboardScreenState extends State<SimpleWhiteboardScreen> {
  List<DrawPoint> _drawPoints = [];
  ToolType _currentTool = ToolType.pen;
  Color _currentColor = Colors.red;
  double _currentStrokeWidth = 4.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Simple Whiteboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            onPressed: () {
              setState(() {
                _drawPoints.clear();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Simple toolbar
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: _currentTool == ToolType.pen ? Colors.red : Colors.grey),
                  onPressed: () => setState(() => _currentTool = ToolType.pen),
                  iconSize: 30,
                ),
                IconButton(
                  icon: Icon(Icons.cleaning_services, color: _currentTool == ToolType.eraser ? Colors.red : Colors.grey),  // ✅ Fixed
                  onPressed: () => setState(() => _currentTool = ToolType.eraser),
                  iconSize: 30,
                ),
                const VerticalDivider(),
                _buildSimpleColorOption(Colors.red),
                _buildSimpleColorOption(Colors.blue),
                _buildSimpleColorOption(Colors.green),
                _buildSimpleColorOption(Colors.black),
                const VerticalDivider(),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => setState(() => _currentStrokeWidth = math.max(2, _currentStrokeWidth - 1)),
                ),
                Text('${_currentStrokeWidth.toInt()}'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() => _currentStrokeWidth = math.min(20, _currentStrokeWidth + 1)),
                ),
              ],
            ),
          ),
          // Drawing area
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _drawPoints.add(DrawPoint(
                    offset: details.localPosition,
                    color: _currentTool == ToolType.eraser ? Colors.white : _currentColor,
                    strokeWidth: _currentTool == ToolType.eraser ? _currentStrokeWidth * 2 : _currentStrokeWidth,
                  ));
                });
              },
              child: Container(
                color: Colors.white,
                child: CustomPaint(
                  painter: SimpleWhiteboardPainter(points: _drawPoints),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleColorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentColor = color;
          _currentTool = ToolType.pen;
        });
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: _currentColor == color
              ? Border.all(color: Colors.red, width: 2)
              : null,
        ),
      ),
    );
  }
}

class DrawPoint {
  final Offset offset;
  final Color color;
  final double strokeWidth;

  DrawPoint({
    required this.offset,
    required this.color,
    required this.strokeWidth,
  });
}

class SimpleWhiteboardPainter extends CustomPainter {
  final List<DrawPoint> points;

  SimpleWhiteboardPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      final paint = Paint()
        ..color = points[i].color
        ..strokeWidth = points[i].strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(points[i].offset, points[i + 1].offset, paint);
    }
  }

  @override
  bool shouldRepaint(SimpleWhiteboardPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}