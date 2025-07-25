// import 'package:flutter/material.dart';
// import 'dart:math' as math;
// import 'dart:ui' as ui;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Quantum Particle Field',
//       theme: ThemeData.dark(),
//       home: ParticleFieldScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class ParticleFieldScreen extends StatefulWidget {
//   const ParticleFieldScreen({super.key});

//   @override
//   _ParticleFieldScreenState createState() => _ParticleFieldScreenState();
// }

// class _ParticleFieldScreenState extends State<ParticleFieldScreen> with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late AnimationController _waveController;
//   List<Particle> particles = [];
//   Offset? touchPoint;
//   double attractionStrength = 1.0;
//   bool isRepelling = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(duration: Duration(milliseconds: 16), vsync: this)..repeat();

//     _waveController = AnimationController(duration: Duration(seconds: 4), vsync: this)..repeat();

//     _initializeParticles();
//   }

//   void _initializeParticles() {
//     particles.clear();
//     final random = math.Random();
//     for (int i = 0; i < 250; i++) {
//       particles.add(
//         Particle(
//           position: Offset(random.nextDouble() * 400, random.nextDouble() * 800),
//           velocity: Offset((random.nextDouble() - 0.5) * 2, (random.nextDouble() - 0.5) * 2),
//           color: HSVColor.fromAHSV(
//             0.8,
//             random.nextDouble() * 360,
//             0.7 + random.nextDouble() * 0.3,
//             0.8 + random.nextDouble() * 0.2,
//           ).toColor(),
//           size: 2 + random.nextDouble() * 4,
//           mass: 0.5 + random.nextDouble() * 1.5,
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _waveController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF0a0a0a),
//       body: Stack(
//         children: [
//           // Animated background gradient
//           AnimatedBuilder(
//             animation: _waveController,
//             builder: (context, child) {
//               return Container(
//                 decoration: BoxDecoration(
//                   gradient: RadialGradient(
//                     center: Alignment(
//                       math.sin(_waveController.value * 2 * math.pi) * 0.3,
//                       math.cos(_waveController.value * 2 * math.pi) * 0.3,
//                     ),
//                     colors: [Color(0xFF1a0033).withValues(alpha: 0.3), Color(0xFF000011), Colors.black],
//                     stops: [0.0, 0.6, 1.0],
//                   ),
//                 ),
//               );
//             },
//           ),

//           // Particle system
//           GestureDetector(
//             onPanUpdate: (details) {
//               setState(() {
//                 touchPoint = details.localPosition;
//               });
//             },
//             onPanEnd: (details) {
//               setState(() {
//                 touchPoint = null;
//               });
//             },
//             onTap: () {
//               setState(() {
//                 isRepelling = !isRepelling;
//                 attractionStrength = isRepelling ? -2.0 : 1.0;
//               });
//             },
//             child: AnimatedBuilder(
//               animation: _controller,
//               builder: (context, child) {
//                 _updateParticles();
//                 return CustomPaint(
//                   size: Size.infinite,
//                   painter: ParticleFieldPainter(
//                     particles: particles,
//                     touchPoint: touchPoint,
//                     time: _controller.value,
//                     isRepelling: isRepelling,
//                   ),
//                 );
//               },
//             ),
//           ),

//           // UI Controls
//           // Positioned(
//           //   top: 60,
//           //   left: 20,
//           //   right: 20,
//           //   child: Column(
//           //     crossAxisAlignment: CrossAxisAlignment.start,
//           //     children: [
//           //       Text(
//           //         'QUANTUM PARTICLE FIELD',
//           //         style: TextStyle(
//           //           color: Colors.white.withOpacity(0.9),
//           //           fontSize: 24,
//           //           fontWeight: FontWeight.bold,
//           //           letterSpacing: 2,
//           //         ),
//           //       ),
//           //       SizedBox(height: 10),
//           //       Text(
//           //         '• Drag to attract particles\n• Tap to toggle repulsion\n• Watch the quantum dance',
//           //         style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
//           //       ),
//           //     ],
//           //   ),
//           // ),

//           // Mode indicator
//           Positioned(
//             bottom: 60,
//             // right: 20,
//             left: 20,
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: isRepelling ? Colors.red.withValues(alpha: 0.3) : Colors.blue.withValues(alpha: 0.3),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: isRepelling ? Colors.red : Colors.blue, width: 1),
//               ),
//               child: Text(
//                 isRepelling ? 'REPULSION MODE' : 'ATTRACTION MODE',
//                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             _initializeParticles();
//           });
//         },
//         backgroundColor: Colors.purple.withValues(alpha: 0.8),
//         child: Icon(Icons.refresh, color: Colors.white),
//       ),
//     );
//   }

//   void _updateParticles() {
//     final size = MediaQuery.of(context).size;

//     for (int i = 0; i < particles.length; i++) {
//       final particle = particles[i];

//       // Apply gravity towards touch point
//       if (touchPoint != null) {
//         final distance = (touchPoint! - particle.position).distance;
//         if (distance > 0) {
//           final force = (touchPoint! - particle.position) / distance;
//           final strength = attractionStrength * 50 / (distance + 10);
//           particle.velocity += force * strength / particle.mass;
//         }
//       }

//       // Particle interactions
//       for (int j = i + 1; j < particles.length; j++) {
//         final other = particles[j];
//         final distance = (other.position - particle.position).distance;

//         if (distance < 80 && distance > 0) {
//           final force = (other.position - particle.position) / distance;
//           final strength = 0.1 / (distance * distance + 1);

//           particle.velocity += force * strength / particle.mass;
//           other.velocity -= force * strength / other.mass;
//         }
//       }

//       // Apply velocity damping
//       particle.velocity *= 0.99;

//       // Update position
//       particle.position += particle.velocity;

//       // Boundary collision with energy conservation
//       if (particle.position.dx < 0 || particle.position.dx > size.width) {
//         particle.velocity = Offset(-particle.velocity.dx * 0.8, particle.velocity.dy);
//         particle.position = Offset(particle.position.dx.clamp(0, size.width), particle.position.dy);
//       }

//       if (particle.position.dy < 0 || particle.position.dy > size.height) {
//         particle.velocity = Offset(particle.velocity.dx, -particle.velocity.dy * 0.8);
//         particle.position = Offset(particle.position.dx, particle.position.dy.clamp(0, size.height));
//       }
//     }
//   }
// }

// class Particle {
//   Offset position;
//   Offset velocity;
//   Color color;
//   double size;
//   double mass;

//   Particle({required this.position, required this.velocity, required this.color, required this.size, required this.mass});
// }

// class ParticleFieldPainter extends CustomPainter {
//   final List<Particle> particles;
//   final Offset? touchPoint;
//   final double time;
//   final bool isRepelling;

//   ParticleFieldPainter({required this.particles, this.touchPoint, required this.time, required this.isRepelling});

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Draw connections between nearby particles
//     final connectionPaint = Paint()
//       ..strokeWidth = 0.5
//       ..style = PaintingStyle.stroke;

//     for (int i = 0; i < particles.length; i++) {
//       for (int j = i + 1; j < particles.length; j++) {
//         final distance = (particles[i].position - particles[j].position).distance;
//         if (distance < 100) {
//           final opacity = (1 - distance / 100) * 0.3;
//           connectionPaint.color = Colors.white.withValues(alpha: opacity);
//           canvas.drawLine(particles[i].position, particles[j].position, connectionPaint);
//         }
//       }
//     }

//     // Draw particles with glow effect
//     for (final particle in particles) {
//       // Outer glow
//       final glowPaint = Paint()
//         ..color = particle.color.withValues(alpha: 0.3)
//         ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, particle.size);

//       canvas.drawCircle(particle.position, particle.size * 2, glowPaint);

//       // Inner particle
//       final particlePaint = Paint()
//         ..color = particle.color
//         ..style = PaintingStyle.fill;

//       canvas.drawCircle(particle.position, particle.size, particlePaint);

//       // Particle core highlight
//       final highlightPaint = Paint()
//         ..color = Colors.white.withValues(alpha: 0.8)
//         ..style = PaintingStyle.fill;

//       canvas.drawCircle(particle.position, particle.size * 0.3, highlightPaint);
//     }

//     // Draw touch point effect
//     if (touchPoint != null) {
//       final touchPaint = Paint()
//         ..color = (isRepelling ? Colors.red : Colors.blue).withValues(alpha: 0.3)
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 2;

//       // Animated rings
//       for (int i = 0; i < 3; i++) {
//         final radius = 30 + i * 20 + math.sin(time * 10 + i) * 10;
//         canvas.drawCircle(touchPoint!, radius, touchPaint);
//       }

//       // Center point
//       final centerPaint = Paint()
//         ..color = isRepelling ? Colors.red : Colors.blue
//         ..style = PaintingStyle.fill;

//       canvas.drawCircle(touchPoint!, 5, centerPaint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

/// Flutter Quantum Particles - Interactive Physics Simulation
///
/// A real-time particle physics engine built with Flutter, featuring:
/// - 200+ interactive particles with collision detection
/// - Touch-based gravity and repulsion forces
/// - Realistic physics with energy conservation
/// - 60fps smooth animations using CustomPainter
///
/// Author: [Your Name]
/// Repository: https://github.com/yourusername/flutter-quantum-particles

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

void main() {
  runApp(const QuantumParticleApp());
}

/// Main application widget for Quantum Particle Field
class QuantumParticleApp extends StatelessWidget {
  const QuantumParticleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quantum Particle Field',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(primary: Colors.purple, secondary: Colors.cyan),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ParticleFieldScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Interactive particle physics simulation screen
///
/// Manages particle state, user interactions, and real-time physics updates
class ParticleFieldScreen extends StatefulWidget {
  const ParticleFieldScreen({super.key});

  @override
  State<ParticleFieldScreen> createState() => _ParticleFieldScreenState();
}

class _ParticleFieldScreenState extends State<ParticleFieldScreen> with TickerProviderStateMixin {
  // Animation controllers for smooth 60fps rendering
  late AnimationController _physicsController;
  late AnimationController _waveController;

  // Particle system state
  List<Particle> particles = [];
  Offset? touchPoint;
  double attractionStrength = 1.0;
  bool isRepelling = false;

  // Physics constants
  static const int particleCount = 200;

  @override
  void initState() {
    super.initState();
    _initializeAnimationControllers();
    _initializeParticles();
  }

  /// Initialize animation controllers for physics and visual effects
  void _initializeAnimationControllers() {
    _physicsController = AnimationController(
      duration: const Duration(milliseconds: 16), // 60fps target
      vsync: this,
    )..repeat();

    _waveController = AnimationController(duration: const Duration(seconds: 4), vsync: this)..repeat();
  }

  /// Initialize particle system with random positions and properties
  void _initializeParticles() {
    particles.clear();
    final random = math.Random();

    for (int i = 0; i < particleCount; i++) {
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

  /// Handle touch drag events for particle attraction
  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      touchPoint = details.localPosition;
    });
  }

  /// Handle end of touch drag
  void _handlePanEnd(DragEndDetails details) {
    setState(() {
      touchPoint = null;
    });
  }

  /// Toggle between attraction and repulsion modes
  void _toggleAttractionMode() {
    setState(() {
      isRepelling = !isRepelling;
      attractionStrength = isRepelling ? -2.0 : 1.0;
    });
  }

  @override
  void dispose() {
    _physicsController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  /// Update particle physics simulation
  void _updatePhysics() {
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
                    colors: [Color(0xFF1a0033).withOpacity(0.3), Color(0xFF000011), Colors.black],
                    stops: [0.0, 0.6, 1.0],
                  ),
                ),
              );
            },
          ),

          // Interactive particle physics simulation
          GestureDetector(
            onPanUpdate: _handlePanUpdate,
            onPanEnd: _handlePanEnd,
            onTap: _toggleAttractionMode,
            child: AnimatedBuilder(
              animation: _physicsController,
              builder: (context, child) {
                _updatePhysics();
                return CustomPaint(
                  size: Size.infinite,
                  painter: ParticleFieldPainter(
                    particles: particles,
                    touchPoint: touchPoint,
                    time: _physicsController.value,
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
            left: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isRepelling ? Colors.red.withOpacity(0.3) : Colors.blue.withOpacity(0.3),
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
      floatingActionButton: AnimatedBuilder(
        animation: _waveController,
        builder: (context, child) {
          return Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Colors.purple.withOpacity(0.8), Colors.blue.withOpacity(0.6), Colors.cyan.withOpacity(0.4)],
                stops: [0.3, 0.7, 1.0],
              ),
              boxShadow: [
                BoxShadow(color: Colors.purple.withOpacity(0.5), blurRadius: 20, spreadRadius: 2),
                BoxShadow(color: Colors.cyan.withOpacity(0.3), blurRadius: 30, spreadRadius: 1),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _initializeParticles();
                });
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: AnimatedBuilder(
                animation: _physicsController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _physicsController.value * 2 * math.pi,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer spinning ring
                        Transform.rotate(
                          angle: _waveController.value * 4 * math.pi,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                            ),
                          ),
                        ),
                        // Inner pulsing core
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          width: 20 + math.sin(_waveController.value * 6 * math.pi) * 3,
                          height: 20 + math.sin(_waveController.value * 6 * math.pi) * 3,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.9),
                            boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)],
                          ),
                          child: const Icon(Icons.auto_awesome, size: 12, color: Colors.purple),
                        ),
                        // Particle-like dots around the button
                        for (int i = 0; i < 6; i++)
                          Transform.rotate(
                            angle: (i * math.pi / 3) + (_physicsController.value * 2 * math.pi),
                            child: Transform.translate(
                              offset: const Offset(25, 0),
                              child: Container(
                                width: 4,
                                height: 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(
                                    0.6 + 0.4 * math.sin(_physicsController.value * 4 * math.pi + i),
                                  ),
                                  boxShadow: [BoxShadow(color: Colors.cyan.withOpacity(0.5), blurRadius: 8)],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
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

/// Represents a single particle with physics properties
class Particle {
  Offset position;
  Offset velocity;
  Color color;
  double size;
  double mass;

  Particle({required this.position, required this.velocity, required this.color, required this.size, required this.mass});
}

/// Custom painter for rendering the particle field with connections and effects
class ParticleFieldPainter extends CustomPainter {
  final List<Particle> particles;
  final Offset? touchPoint;
  final double time;
  final bool isRepelling;

  const ParticleFieldPainter({required this.particles, this.touchPoint, required this.time, required this.isRepelling});

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
          connectionPaint.color = Colors.white.withOpacity(opacity);
          canvas.drawLine(particles[i].position, particles[j].position, connectionPaint);
        }
      }
    }

    // Draw particles with glow effect
    for (final particle in particles) {
      // Outer glow
      final glowPaint = Paint()
        ..color = particle.color.withOpacity(0.3)
        ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, particle.size);

      canvas.drawCircle(particle.position, particle.size * 2, glowPaint);

      // Inner particle
      final particlePaint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(particle.position, particle.size, particlePaint);

      // Particle core highlight
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(particle.position, particle.size * 0.3, highlightPaint);
    }

    // Draw touch point effect
    if (touchPoint != null) {
      final touchPaint = Paint()
        ..color = (isRepelling ? Colors.red : Colors.blue).withOpacity(0.3)
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
