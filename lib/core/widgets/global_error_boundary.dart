import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'neon_button.dart';

// =============================================================================
// GLOBAL ERROR HANDLING & RESILIENCE
// =============================================================================

class GlobalErrorBoundary extends StatefulWidget {
  final Widget child;

  const GlobalErrorBoundary({super.key, required this.child});

  @override
  State<GlobalErrorBoundary> createState() => _GlobalErrorBoundaryState();
}

class _GlobalErrorBoundaryState extends State<GlobalErrorBoundary> {
  FlutterErrorDetails? _errorDetails;

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      setState(() {
        _errorDetails = details;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_errorDetails != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: Scaffold(
          backgroundColor: const Color(0xFF09090B),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.triangleAlert,
                      size: 64, color: Color(0xFFEF4444)),
                  const SizedBox(height: 24),
                  const Text(
                    'Oops! Something went wrong',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'An unexpected error occurred. We\'ve been notified and are working on it.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 32),
                  NeonButton(
                    title: 'Restart App',
                    onPress: () {
                      setState(() {
                        _errorDetails = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: _errorDetails.toString()));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Error details copied to clipboard')),
                      );
                    },
                    child: Text(
                      'Copy Error Details',
                      style:
                          TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return widget.child;
  }
}
