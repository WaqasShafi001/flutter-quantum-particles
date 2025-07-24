import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quantum Particle Field',
      theme: ThemeData.dark(),
      home: ParticleFieldScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ParticleFieldScreen extends StatefulWidget {
  const ParticleFieldScreen({super.key});

  @override
  _ParticleFieldScreenState createState() => _ParticleFieldScreenState();
}

class _ParticleFieldScreenState extends State<ParticleFieldScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _waveController;
  List<Particle> particles = [];
  Offset? touchPoint;
  double attractionStrength = 1.0;
  bool isRepelling = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 16), vsync: this)..repeat();

    _waveController = AnimationController(duration: Duration(seconds: 4), vsync: this)..repeat();

    _initializeParticles();
  }

  void _initializeParticles() {
    particles.clear();
    final random = math.Random();
    for (int i = 0; i < 250; i++) {
      particles.add(
        Particle(
          position: Offset(random.nextDouble() * 400, random.nextDouble() * 800),
          velocity: Offset((random.nextDouble() - 0.5) * 2, (random.nextDouble() - 0.5) * 2),
          color: HSVColor.fromAHSV(
            0.8,
            random.nextDouble() * 360,
            0.7 + random.nextDouble() * 0.3,
            0.8 + random.nextDouble() * 0.2,
          ).toColor(),
          size: 2 + random.nextDouble() * 4,
          mass: 0.5 + random.nextDouble() * 1.5,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0a0a0a),
      body: Stack(
        children: [
          // Animated background gradient
          AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(
                      math.sin(_waveController.value * 2 * math.pi) * 0.3,
                      math.cos(_waveController.value * 2 * math.pi) * 0.3,
                    ),
                    colors: [Color(0xFF1a0033).withValues(alpha: 0.3), Color(0xFF000011), Colors.black],
                    stops: [0.0, 0.6, 1.0],
                  ),
                ),
              );
            },
          ),

          // Particle system
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                touchPoint = details.localPosition;
              });
            },
            onPanEnd: (details) {
              setState(() {
                touchPoint = null;
              });
            },
            onTap: () {
              setState(() {
                isRepelling = !isRepelling;
                attractionStrength = isRepelling ? -2.0 : 1.0;
              });
            },
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                _updateParticles();
                return CustomPaint(
                  size: Size.infinite,
                  painter: ParticleFieldPainter(
                    particles: particles,
                    touchPoint: touchPoint,
                    time: _controller.value,
                    isRepelling: isRepelling,
                  ),
                );
              },
            ),
          ),

          // UI Controls
          // Positioned(
          //   top: 60,
          //   left: 20,
          //   right: 20,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         'QUANTUM PARTICLE FIELD',
          //         style: TextStyle(
          //           color: Colors.white.withOpacity(0.9),
          //           fontSize: 24,
          //           fontWeight: FontWeight.bold,
          //           letterSpacing: 2,
          //         ),
          //       ),
          //       SizedBox(height: 10),
          //       Text(
          //         '• Drag to attract particles\n• Tap to toggle repulsion\n• Watch the quantum dance',
          //         style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
          //       ),
          //     ],
          //   ),
          // ),

          // Mode indicator
          Positioned(
            bottom: 60,
            // right: 20,
            left: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isRepelling ? Colors.red.withValues(alpha: 0.3) : Colors.blue.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isRepelling ? Colors.red : Colors.blue, width: 1),
              ),
              child: Text(
                isRepelling ? 'REPULSION MODE' : 'ATTRACTION MODE',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _initializeParticles();
          });
        },
        backgroundColor: Colors.purple.withValues(alpha: 0.8),
        child: Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  void _updateParticles() {
    final size = MediaQuery.of(context).size;

    for (int i = 0; i < particles.length; i++) {
      final particle = particles[i];

      // Apply gravity towards touch point
      if (touchPoint != null) {
        final distance = (touchPoint! - particle.position).distance;
        if (distance > 0) {
          final force = (touchPoint! - particle.position) / distance;
          final strength = attractionStrength * 50 / (distance + 10);
          particle.velocity += force * strength / particle.mass;
        }
      }

      // Particle interactions
      for (int j = i + 1; j < particles.length; j++) {
        final other = particles[j];
        final distance = (other.position - particle.position).distance;

        if (distance < 80 && distance > 0) {
          final force = (other.position - particle.position) / distance;
          final strength = 0.1 / (distance * distance + 1);

          particle.velocity += force * strength / particle.mass;
          other.velocity -= force * strength / other.mass;
        }
      }

      // Apply velocity damping
      particle.velocity *= 0.99;

      // Update position
      particle.position += particle.velocity;

      // Boundary collision with energy conservation
      if (particle.position.dx < 0 || particle.position.dx > size.width) {
        particle.velocity = Offset(-particle.velocity.dx * 0.8, particle.velocity.dy);
        particle.position = Offset(particle.position.dx.clamp(0, size.width), particle.position.dy);
      }

      if (particle.position.dy < 0 || particle.position.dy > size.height) {
        particle.velocity = Offset(particle.velocity.dx, -particle.velocity.dy * 0.8);
        particle.position = Offset(particle.position.dx, particle.position.dy.clamp(0, size.height));
      }
    }
  }
}

class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double mass;

  Particle({required this.position, required this.velocity, required this.color, required this.size, required this.mass});
}

class ParticleFieldPainter extends CustomPainter {
  final List<Particle> particles;
  final Offset? touchPoint;
  final double time;
  final bool isRepelling;

  ParticleFieldPainter({required this.particles, this.touchPoint, required this.time, required this.isRepelling});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw connections between nearby particles
    final connectionPaint = Paint()
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final distance = (particles[i].position - particles[j].position).distance;
        if (distance < 100) {
          final opacity = (1 - distance / 100) * 0.3;
          connectionPaint.color = Colors.white.withValues(alpha: opacity);
          canvas.drawLine(particles[i].position, particles[j].position, connectionPaint);
        }
      }
    }

    // Draw particles with glow effect
    for (final particle in particles) {
      // Outer glow
      final glowPaint = Paint()
        ..color = particle.color.withValues(alpha: 0.3)
        ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, particle.size);

      canvas.drawCircle(particle.position, particle.size * 2, glowPaint);

      // Inner particle
      final particlePaint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(particle.position, particle.size, particlePaint);

      // Particle core highlight
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.8)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(particle.position, particle.size * 0.3, highlightPaint);
    }

    // Draw touch point effect
    if (touchPoint != null) {
      final touchPaint = Paint()
        ..color = (isRepelling ? Colors.red : Colors.blue).withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      // Animated rings
      for (int i = 0; i < 3; i++) {
        final radius = 30 + i * 20 + math.sin(time * 10 + i) * 10;
        canvas.drawCircle(touchPoint!, radius, touchPaint);
      }

      // Center point
      final centerPaint = Paint()
        ..color = isRepelling ? Colors.red : Colors.blue
        ..style = PaintingStyle.fill;

      canvas.drawCircle(touchPoint!, 5, centerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
