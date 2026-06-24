// SecureDesk right panel with green decorative banner
import 'package:flutter/material.dart';
import 'package:flutter_hbb/common/widgets/peer_tab_page.dart';
import 'package:flutter_hbb/desktop/pages/connection_page.dart';
import 'package:get/get.dart';

class SecureDeskRightPanel extends StatelessWidget {
  const SecureDeskRightPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: Column(
        children: [
          _buildBanner(context, isDark),
          Expanded(
            child: ConnectionPage(),
          ),
          _buildSecurityFooter(context, isDark),
        ],
      ),
    );
  }

  Widget _buildBanner(BuildContext context, bool isDark) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1B3A2D), const Color(0xFF0F2B1F)]
              : [const Color(0xFFE8F5EB), const Color(0xFFCDE8D3)],
        ),
      ),
      child: Stack(
        children: [
          // Decorative elements - trees
          Positioned(
            left: 20,
            bottom: 0,
            child: CustomPaint(
              size: const Size(40, 50),
              painter: _TreePainter(isDark: isDark),
            ),
          ),
          Positioned(
            right: 30,
            bottom: 0,
            child: CustomPaint(
              size: const Size(30, 40),
              painter: _TreePainter(isDark: isDark, scale: 0.7),
            ),
          ),
          // Center text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SecureDesk',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFF81C784)
                        : const Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Secure Remote Desktop',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFFA5D6A7)
                        : const Color(0xFF43A047),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityFooter(BuildContext context, bool isDark) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE0E0E0),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 14,
            color: isDark ? const Color(0xFF81C784) : const Color(0xFF43A047),
          ),
          const SizedBox(width: 6),
          Text(
            'End-to-end encrypted',
            style: TextStyle(
              fontSize: 11,
              color: isDark ? const Color(0xFF888888) : const Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }
}

class _TreePainter extends CustomPainter {
  final bool isDark;
  final double scale;

  _TreePainter({required this.isDark, this.scale = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(scale, scale);
    final paint = Paint()
      ..color = isDark
          ? const Color(0xFF2E7D32).withOpacity(0.3)
          : const Color(0xFF81C784).withOpacity(0.4)
      ..style = PaintingStyle.fill;

    // Tree trunk
    final trunkPaint = Paint()
      ..color = isDark
          ? const Color(0xFF4E342E).withOpacity(0.3)
          : const Color(0xFF8D6E63).withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Simple tree shape
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(w * 0.42, h * 0.6, w * 0.16, h * 0.4),
          topLeft: const Radius.circular(2),
          topRight: const Radius.circular(2),
        ),
        trunkPaint);

    // Canopy
    canvas.drawOval(Rect.fromLTWH(w * 0.1, h * 0.15, w * 0.8, h * 0.5), paint);
    canvas.drawOval(Rect.fromLTWH(w * 0.2, h * 0.0, w * 0.6, h * 0.45), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
