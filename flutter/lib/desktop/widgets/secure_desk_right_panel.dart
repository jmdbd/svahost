// SecureDesk right panel - decorative banner with nature scene + PeerTabPage + security tip

import 'package:flutter/material.dart';
import 'package:flutter_hbb/common.dart';
import 'package:flutter_hbb/common/widgets/peer_tab_page.dart';
import 'package:flutter_hbb/desktop/pages/desktop_tab_page.dart';

class SecureDeskRightPanel extends StatefulWidget {
  const SecureDeskRightPanel({Key? key}) : super(key: key);

  @override
  State<SecureDeskRightPanel> createState() => _SecureDeskRightPanelState();
}

class _SecureDeskRightPanelState extends State<SecureDeskRightPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
      child: Column(
        children: [
          _buildBanner(context),
          Expanded(child: _buildPeerContent(context)),
          _buildSecurityTip(context),
        ],
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [Color(0xFF1A2A3D), Color(0xFF0F1F2F), Color(0xFF162D45)]
              : [Color(0xFFBBDEFB), Color(0xFF90CAF9), Color(0xFF64B5F6)],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            // Sky clouds
            _buildCloudLayer(isDark),
            // Far mountain
            _buildFarMountain(isDark),
            // Waterfall
            _buildWaterfall(isDark),
            // Near mountain
            _buildNearMountain(isDark),
            // Trees at base
            _buildTreeLayer(isDark),
            // Sun with pulse
            Positioned(
              right: 20,
              top: 16,
              child: _buildSun(),
            ),
            // Text content
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Secure Remote Desktop',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Color(0xFF0D47A1),
                      shadows: [
                        Shadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '轻松远程，无限连接',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Color(0xFF90CAF9) : Color(0xFF1565C0),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '安全、快速、稳定的远程桌面体验',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? Color(0xFF64B5F6).withOpacity(0.7)
                          : Color(0xFF1976D2).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloudLayer(bool isDark) {
    return Stack(
      children: [
        Positioned(
          left: 150,
          top: 10,
          child: _buildCloud(50, 22, Colors.white.withOpacity(0.85)),
        ),
        Positioned(
          left: 240,
          top: 28,
          child: _buildCloud(38, 16, Colors.white.withOpacity(0.7)),
        ),
        Positioned(
          left: 320,
          top: 8,
          child: _buildCloud(44, 20, Colors.white.withOpacity(0.75)),
        ),
        Positioned(
          left: 420,
          top: 35,
          child: _buildCloud(34, 14, Colors.white.withOpacity(0.6)),
        ),
        Positioned(
          left: 500,
          top: 12,
          child: _buildCloud(40, 18, Colors.white.withOpacity(0.65)),
        ),
      ],
    );
  }

  Widget _buildNearMountain(bool isDark) {
    return Positioned(
      right: -40,
      bottom: -10,
      child: CustomPaint(
        size: Size(300, 160),
        painter: _MountainPainter(
          isDark
              ? Color(0xFF2A4A6B)
              : Color(0xFF5C8DB5),
          isDark
              ? Color(0xFF1E3A5A)
              : Color(0xFF4A7EA8),
        ),
      ),
    );
  }

  Widget _buildFarMountain(bool isDark) {
    return Positioned(
      right: 60,
      bottom: 30,
      child: CustomPaint(
        size: Size(220, 120),
        painter: _MountainPainter(
          isDark
              ? Color(0xFF3A5A7B)
              : Color(0xFF7BA7CB),
          isDark
              ? Color(0xFF2A4A6B)
              : Color(0xFF6A9AC0),
        ),
      ),
    );
  }

  Widget _buildWaterfall(bool isDark) {
    return Positioned(
      right: 155,
      bottom: 45,
      child: CustomPaint(
        size: Size(16, 65),
        painter: _WaterfallPainter(isDark),
      ),
    );
  }

  Widget _buildTreeLayer(bool isDark) {
    return Stack(
      children: [
        // Trees on the left side
        Positioned(
          right: 240,
          bottom: -2,
          child: _buildPineTree(38, isDark
              ? Color(0xFF2E7D32).withOpacity(0.7)
              : Color(0xFF388E3C).withOpacity(0.7)),
        ),
        Positioned(
          right: 260,
          bottom: -2,
          child: _buildPineTree(30, isDark
              ? Color(0xFF388E3C).withOpacity(0.6)
              : Color(0xFF43A047).withOpacity(0.6)),
        ),
        Positioned(
          right: 215,
          bottom: -2,
          child: _buildPineTree(28, isDark
              ? Color(0xFF43A047).withOpacity(0.55)
              : Color(0xFF4CAF50).withOpacity(0.55)),
        ),
        // Trees on the right side
        Positioned(
          right: 90,
          bottom: -2,
          child: _buildPineTree(34, isDark
              ? Color(0xFF2E7D32).withOpacity(0.65)
              : Color(0xFF388E3C).withOpacity(0.65)),
        ),
        Positioned(
          right: 110,
          bottom: -2,
          child: _buildPineTree(26, isDark
              ? Color(0xFF388E3C).withOpacity(0.55)
              : Color(0xFF43A047).withOpacity(0.55)),
        ),
      ],
    );
  }

  Widget _buildPineTree(double height, Color color) {
    return CustomPaint(
      size: Size(height * 0.6, height),
      painter: _PineTreePainter(color),
    );
  }

  Widget _buildCloud(double width, double height, Color color) {
    return CustomPaint(
      size: Size(width, height),
      painter: _CloudPainter(color),
    );
  }

  Widget _buildSun() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + (_pulseController.value * 0.12);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xFFFFF59D).withOpacity(0.95),
                  Color(0xFFFFF176).withOpacity(0.6),
                  Color(0xFFFFD54F).withOpacity(0.2),
                  Colors.transparent,
                ],
                stops: [0.2, 0.45, 0.7, 1.0],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPeerContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: const PeerTabPage(),
    );
  }

  Widget _buildSecurityTip(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1A2E3D) : Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Color(0xFF2C8CFF).withOpacity(0.3) : Color(0xFF90CAF9),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, size: 30,
              color: isDark ? Color(0xFF64B5F6) : Color(0xFF1976D2)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '端到端加密保护您的连接',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Color(0xFF90CAF9) : Color(0xFF1565C0),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '连接已加密，数据通过安全通道传输',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark
                        ? Color(0xFF64B5F6).withOpacity(0.7)
                        : Color(0xFF1976D2).withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.lock_outline, size: 18,
              color: isDark
                  ? Color(0xFF64B5F6).withOpacity(0.5)
                  : Color(0xFF1976D2).withOpacity(0.5)),
        ],
      ),
    );
  }
}

// --- Custom Painters ---

/// Cloud painter
class _CloudPainter extends CustomPainter {
  final Color color;

  _CloudPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final r = h * 0.48;

    canvas.drawCircle(Offset(w * 0.3, h * 0.55), r, paint);
    canvas.drawCircle(Offset(w * 0.5, h * 0.32), r * 1.2, paint);
    canvas.drawCircle(Offset(w * 0.72, h * 0.48), r * 0.85, paint);
    canvas.drawCircle(Offset(w * 0.48, h * 0.65), r * 0.65, paint);

    final bottomPath = Path();
    bottomPath.moveTo(w * 0.08, h * 0.68);
    bottomPath.quadraticBezierTo(w * 0.28, h * 1.08, w * 0.52, h * 0.72);
    bottomPath.quadraticBezierTo(w * 0.68, h * 0.95, w * 0.85, h * 0.62);
    bottomPath.quadraticBezierTo(w * 0.92, h * 0.68, w * 0.92, h * 0.68);
    bottomPath.lineTo(w * 0.08, h * 0.68);
    bottomPath.close();
    canvas.drawPath(bottomPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Mountain painter — draws a stylized mountain with snow cap
class _MountainPainter extends CustomPainter {
  final Color mainColor;
  final Color shadowColor;

  _MountainPainter(this.mainColor, this.shadowColor);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Main mountain body
    final mountainPath = Path();
    mountainPath.moveTo(w * 0.5, 0); // peak
    mountainPath.lineTo(w * 0.82, h); // right base
    mountainPath.lineTo(w * 0.2, h); // left base
    mountainPath.close();

    final mainPaint = Paint()
      ..color = mainColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(mountainPath, mainPaint);

    // Shadow side (right half)
    final shadowPath = Path();
    shadowPath.moveTo(w * 0.5, 0);
    shadowPath.lineTo(w * 0.82, h);
    shadowPath.lineTo(w * 0.5, h);
    shadowPath.close();

    final shadowPaint = Paint()
      ..color = shadowColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(shadowPath, shadowPaint);

    // Snow cap
    final snowPath = Path();
    snowPath.moveTo(w * 0.5, 0);
    snowPath.lineTo(w * 0.6, h * 0.22);
    snowPath.quadraticBezierTo(w * 0.5, h * 0.3, w * 0.4, h * 0.22);
    snowPath.close();

    final snowPaint = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..style = PaintingStyle.fill;
    canvas.drawPath(snowPath, snowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Waterfall painter — white/blue cascading lines
class _WaterfallPainter extends CustomPainter {
  final bool isDark;

  _WaterfallPainter(this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Main waterfall stream
    final waterfallPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.9),
          Color(0xFFBBDEFB).withOpacity(0.8),
          Color(0xFF90CAF9).withOpacity(0.6),
          Color(0xFF64B5F6).withOpacity(0.4),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(w * 0.25, 0);
    path.quadraticBezierTo(w * 0.6, h * 0.3, w * 0.3, h * 0.6);
    path.quadraticBezierTo(w * 0.5, h * 0.8, w * 0.55, h);
    path.lineTo(w * 0.7, h);
    path.quadraticBezierTo(w * 0.65, h * 0.75, w * 0.5, h * 0.55);
    path.quadraticBezierTo(w * 0.8, h * 0.25, w * 0.5, 0);
    path.close();
    canvas.drawPath(path, waterfallPaint);

    // Mist at bottom
    final mistPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final mistPath = Path();
    mistPath.moveTo(w * 0.2, h * 0.85);
    mistPath.quadraticBezierTo(w * 0.5, h * 0.7, w * 0.85, h * 0.8);
    mistPath.quadraticBezierTo(w * 0.6, h * 0.85, w * 0.4, h * 0.95);
    mistPath.close();
    canvas.drawPath(mistPath, mistPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Pine tree painter — triangular evergreen
class _PineTreePainter extends CustomPainter {
  final Color color;

  _PineTreePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Trunk
    final trunkPaint = Paint()
      ..color = Color(0xFF5D4037).withOpacity(0.5)
      ..style = PaintingStyle.fill;
    final trunkPath = Path();
    trunkPath.moveTo(w * 0.44, h);
    trunkPath.lineTo(w * 0.56, h);
    trunkPath.lineTo(w * 0.53, h * 0.3);
    trunkPath.lineTo(w * 0.47, h * 0.3);
    trunkPath.close();
    canvas.drawPath(trunkPath, trunkPaint);

    // Three layers of foliage
    final foliagePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Bottom layer
    final bottomPath = Path();
    bottomPath.moveTo(w * 0.08, h * 0.65);
    bottomPath.quadraticBezierTo(w * 0.5, h * 0.35, w * 0.92, h * 0.65);
    bottomPath.lineTo(w * 0.08, h * 0.65);
    bottomPath.close();
    canvas.drawPath(bottomPath, foliagePaint);

    // Middle layer
    final middlePath = Path();
    middlePath.moveTo(w * 0.13, h * 0.48);
    middlePath.quadraticBezierTo(w * 0.5, h * 0.12, w * 0.87, h * 0.48);
    middlePath.lineTo(w * 0.13, h * 0.48);
    middlePath.close();
    canvas.drawPath(middlePath, foliagePaint..color = color.withOpacity(0.82));

    // Top layer
    final topPath = Path();
    topPath.moveTo(w * 0.22, h * 0.3);
    topPath.quadraticBezierTo(w * 0.5, h * 0.0, w * 0.78, h * 0.3);
    topPath.lineTo(w * 0.22, h * 0.3);
    topPath.close();
    canvas.drawPath(topPath, foliagePaint..color = color.withOpacity(0.7));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
