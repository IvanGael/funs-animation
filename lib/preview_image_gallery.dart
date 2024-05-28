// ignore_for_file: library_private_types_in_public_api

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';

// class PreviewImageGallery extends StatefulWidget {
//   final List<String> imageUrls;
//   final int initialIndex;
//   final double minScale;
//   final double maxScale;

//   const PreviewImageGallery({
//     super.key,
//     required this.imageUrls,
//     required this.initialIndex,
//     this.maxScale = 2.5,
//     this.minScale = 1.0,
//   });

//   @override
//   _PreviewImageGalleryState createState() => _PreviewImageGalleryState();
// }

// class _PreviewImageGalleryState extends State<PreviewImageGallery> with TickerProviderStateMixin {
//   final TransformationController _transformationController = TransformationController();
//   late final AnimationController _animationController = AnimationController(
//     vsync: this,
//     duration: const Duration(milliseconds: 300),
//   )..addListener(() {
//       _transformationController.value = _animation!.value;
//     });
//   late final AnimationController _dragAnimationController = AnimationController(
//     vsync: this,
//     duration: const Duration(milliseconds: 200),
//   );
//   late final AnimationController _hideController = AnimationController(
//     vsync: this,
//     duration: const Duration(milliseconds: 100),
//   )..addListener(() {
//       if (_hideController.status == AnimationStatus.dismissed) {
//         _hideMenu();
//       }
//     });

//   Animation<Matrix4>? _animation;
//   Animation<Offset>? _dragAnimation;
//   Offset? _dragOffset;
//   Offset? _doubleTapLocalPosition;
//   int _currentIndex = 0;
//   bool _enablePageView = true;
//   bool _enableDrag = true;
//   final bool _isTapScreen = false;

//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.initialIndex;
//   }

//   @override
//   void dispose() {
//     _hideController.dispose();
//     _dragAnimationController.dispose();
//     _animationController.dispose();
//     _transformationController.dispose();
//     super.dispose();
//   }

//   Future<void> _hideMenu() async {
//     if (!_isTapScreen) await _hideController.forward();
//   }

//   void _onAnimationEnd(AnimationStatus status) {
//     if (status == AnimationStatus.completed) {
//       _dragAnimationController.reset();
//       setState(() {
//         _dragOffset = null;
//       });
//     }
//   }

//   // void _onDragStart(ScaleStartDetails details) {
//   //   _dragOffset = Offset.zero;
//   // }

//   void _onDragUpdate(ScaleUpdateDetails details) {
//     final Offset currentPosition = details.focalPoint;
//     final Offset previousPosition = _doubleTapLocalPosition ?? currentPosition;
//     final Offset offsetDelta = currentPosition - previousPosition;

//     if (_enableDrag) {
//       setState(() {
//         _dragOffset = Offset(0, (_dragOffset?.dy ?? 0) + offsetDelta.dy);
//         _doubleTapLocalPosition = currentPosition;
//       });
//     }
//   }

//   void _onDragEnd(ScaleEndDetails details) {
//     if (_dragOffset != null && _dragOffset!.dy.abs() > MediaQuery.of(context).size.height / 3) {
//       Navigator.of(context).pop();
//     } else {
//       _dragAnimation = Tween<Offset>(
//         begin: _dragOffset!,
//         end: Offset.zero,
//       ).animate(_dragAnimationController)
//         ..addStatusListener(_onAnimationEnd);
//       _dragAnimationController.forward(from: 0);
//     }
//   }

//   void _onDoubleTap() {
//     final Matrix4 matrix = _transformationController.value.clone();
//     final double currentScale = matrix.getMaxScaleOnAxis();
//     final double targetScale = currentScale == widget.minScale ? widget.maxScale : widget.minScale;

//     final double offsetX = targetScale == widget.minScale ? 0.0 : -_doubleTapLocalPosition!.dx * (targetScale - 1);
//     final double offsetY = targetScale == widget.minScale ? 0.0 : -_doubleTapLocalPosition!.dy * (targetScale - 1);

//     final Matrix4 targetMatrix = Matrix4.identity()
//       ..scale(targetScale)
//       ..translate(offsetX, offsetY);

//     _animation = Matrix4Tween(
//       begin: _transformationController.value,
//       end: targetMatrix,
//     ).animate(CurveTween(curve: Curves.easeOut).animate(_animationController));
//     _animationController.forward(from: 0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: false,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Stack(
//           children: [
//             AnimatedBuilder(
//               animation: _dragAnimationController,
//               builder: (context, child) {
//                 final Offset offset = _dragOffset ?? Offset.zero;
//                 if (_dragAnimationController.isAnimating) {
//                   return Transform.translate(offset: _dragAnimation!.value, child: child);
//                 }
//                 return Transform.translate(offset: offset, child: child);
//               },
//               child: CarouselSlider(
//                 items: widget.imageUrls.map((url) {
//                   return InteractiveViewer(
//                     transformationController: _transformationController,
//                     minScale: widget.minScale,
//                     maxScale: widget.maxScale,
//                     onInteractionUpdate: (details) {
//                       _onDragUpdate(details);
//                       setState(() {
//                         _enablePageView = _transformationController.value.getMaxScaleOnAxis() == 1.0;
//                         _enableDrag = _enablePageView;
//                       });
//                     },
//                     onInteractionEnd: _onDragEnd,
//                     child: GestureDetector(
//                       onDoubleTapDown: (details) => _doubleTapLocalPosition = details.localPosition,
//                       onDoubleTap: _onDoubleTap,
//                       child: Hero(
//                         tag: 'img_${widget.imageUrls.indexOf(url)}',
//                         child: Image.network(
//                           url,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//                 options: CarouselOptions(
//                   initialPage: _currentIndex,
//                   height: MediaQuery.of(context).size.height,
//                   viewportFraction: 1.0,
//                   scrollPhysics: _enablePageView ? null : const NeverScrollableScrollPhysics(),
//                   onPageChanged: (index, reason) {
//                     setState(() {
//                       _currentIndex = index;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             AnimatedBuilder(
//               animation: _hideController,
//               builder: (context, child) {
//                 return Opacity(
//                   opacity: _hideController.value,
//                   child: child,
//                 );
//               },
//               child: SafeArea(
//                 child: AppBar(
//                   backgroundColor: Colors.transparent,
//                   title: Text(
//                     '${_currentIndex + 1}/${widget.imageUrls.length}',
//                     style: const TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w500),
//                   ),
//                   centerTitle: true,
//                   leading: IconButton(
//                     icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//                     onPressed: () => Navigator.of(context).pop(),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PreviewImageGalleryScreen extends StatelessWidget {
//   final String title;

//   const PreviewImageGalleryScreen({super.key, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     final List<String> imageUrls = [
//       'https://images.unsplash.com/photo-1698357877700-034b990b7f21?q=80&w=2792&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//       'https://plus.unsplash.com/premium_photo-1705421624826-8276b4fe4c08?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//       'https://images.unsplash.com/photo-1705507367127-c90cc471517d?q=80&w=2781&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//       'https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?q=80&w=2772&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//       'https://images.unsplash.com/photo-1569084024058-1632922a4e1d?q=80&w=2819&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//       'https://images.unsplash.com/photo-1602028286725-a4aad1b5d3d9?q=80&w=2835&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//     ];

//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           title: Text(
//             title,
//             style: const TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w500),
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 56.0),
//           child: CarouselSlider(
//             items: imageUrls.map((url) {
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).push(
//                     PageRouteBuilder(
//                       opaque: false,
//                       pageBuilder: (context, animation, _) => PreviewImageGallery(
//                         imageUrls: imageUrls,
//                         initialIndex: imageUrls.indexOf(url),
//                       ),
//                     ),
//                   );
//                 },
//                 child: Hero(
//                   tag: 'img_${imageUrls.indexOf(url)}',
//                   child: Image.network(
//                     url,
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               );
//             }).toList(),
//             options: CarouselOptions(
//               height: MediaQuery.of(context).size.height,
//               enlargeCenterPage: true,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }




import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PreviewImageGallery extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;
  final double minScale;
  final double maxScale;
  const PreviewImageGallery({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
    this.maxScale = 2.5,
    this.minScale = 1.0,
  });

  @override
  State<PreviewImageGallery> createState() => _PreviewImageGalleryState();
}

class _PreviewImageGalleryState extends State<PreviewImageGallery> with TickerProviderStateMixin {
  final TransformationController _transformationController = TransformationController();

  /// The current scale of the [InteractiveViewer].
  double get _scale => _transformationController.value.row0.x;
  var _currentIndex = 0;
  bool _enablePageView = true;

  /// Handle double tap to zoom in/out
  late Offset _doubleTapLocalPosition;

  /// The controller to animate the transformation value of the
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  /// For handle drag to pop action
  late final AnimationController _dragAnimationController;

  /// Drag offset animation controller.
  late Animation<Offset> _dragAnimation;
  Offset? _dragOffset;
  Offset? _previousPosition;

  /// Flag to enabled/disabled drag to pop action
  bool _enableDrag = true;

  /// Animate hide bar
  late final AnimationController _hidePercentController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
  );
  late final Animation<double> _aniHidePercent =
      Tween<double>(begin: 1.0, end: 0.0).animate(_hidePercentController);
  bool _isTapScreen = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        _transformationController.value = _animation?.value ?? Matrix4.identity();
      });

    /// initial drag animation controller
    _dragAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addStatusListener((status) {
        _onAnimationEnd(status);
      });
    _dragAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_dragAnimationController);

    /// initial hide bar animation
    _hidePercentController.addListener(() {
      if (_hidePercentController.status == AnimationStatus.dismissed) {
        _delayHideMenu();
      }
    });
  }

  _checkShowBar() {
    if (_aniHidePercent.value <= 0) {
      _hidePercentController.reverse();
    } else {
      _hidePercentController.forward();
    }
  }

  Future _delayHideMenu() async {
    if (_isTapScreen) return;
    await _hidePercentController.forward();
  }

  void _onAnimationEnd(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _dragAnimationController.reset();
      setState(() {
        _dragOffset = null;
        _previousPosition = null;
      });
    }
  }

  @override
  void dispose() {
    _hidePercentController.dispose();
    _dragAnimationController.removeStatusListener(_onAnimationEnd);
    _dragAnimationController.dispose();
    _animationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.loose,
          children: [
            _buildImageSliders(context),
            _buildToolbar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    return AnimatedBuilder(
      animation: _aniHidePercent,
      builder: (context, child) {
        return Opacity(
          opacity: _aniHidePercent.value,
          child: child,
        );
      },
      child: SafeArea(
        maintainBottomViewPadding: true,
        child: SizedBox(
          height: kToolbarHeight,
          child: AppBar(
            toolbarHeight: kToolbarHeight,
            backgroundColor: Colors.transparent,
            title: Text(
              '${_currentIndex + 1}/${widget.imageUrls.length}',
              style:
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18.0),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSliders(BuildContext context) {
    return AnimatedBuilder(
      builder: (context, Widget? child) {
        Offset finalOffset = _dragOffset ?? const Offset(0.0, 0.0);
        if (_dragAnimation.status == AnimationStatus.forward) finalOffset = _dragAnimation.value;
        return Transform.translate(
          offset: finalOffset,
          child: child,
        );
      },
      animation: _dragAnimation,
      child: CarouselSlider(
        disableGesture: true,
        items: widget.imageUrls
            .map(
              (e) => InteractiveViewer(
                minScale: widget.minScale,
                maxScale: widget.maxScale,
                transformationController: _transformationController,
                onInteractionUpdate: (details) {
                  _onDragUpdate(details);
                  if (_scale == 1.0) {
                    _enablePageView = true;
                    _enableDrag = true;
                  } else {
                    _enablePageView = false;
                    _enableDrag = false;
                  }
                  setState(() {});
                },
                onInteractionEnd: (details) {
                  if (_enableDrag) {
                    _onOverScrollDragEnd(details);
                  }
                },
                onInteractionStart: (details) {
                  if (_enableDrag) {
                    _onDragStart(details);
                  }
                },
                child: Hero(
                  tag: 'img_${widget.imageUrls.indexOf(e)}',
                  child: GestureDetector(
                    onDoubleTapDown: (TapDownDetails details) {
                      _doubleTapLocalPosition = details.localPosition;
                    },
                    onDoubleTap: _onDoubleTap,
                    child: Image.network(
                      e,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
        options: CarouselOptions(
          initialPage: _currentIndex,
          aspectRatio: 1.0,
          viewportFraction: 1.0,
          height: MediaQuery.of(context).size.height,
          scrollPhysics: _enablePageView ? null : const NeverScrollableScrollPhysics(),
          enlargeCenterPage: false,
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  void _onDragStart(ScaleStartDetails scaleDetails) {
    _previousPosition = scaleDetails.focalPoint;
  }

  void _onDragUpdate(ScaleUpdateDetails scaleUpdateDetails) {
    final currentPosition = scaleUpdateDetails.focalPoint;
    final previousPosition = _previousPosition ?? currentPosition;

    final newY = (_dragOffset?.dy ?? 0.0) + (currentPosition.dy - previousPosition.dy);
    _previousPosition = currentPosition;
    if (_enableDrag) {
      setState(() {
        _dragOffset = Offset(0, newY);
      });
    }
  }

  /// Handles the end of an over-scroll drag event.
  ///
  /// If [scaleEndDetails] is not null, it checks if the drag offset exceeds a certain threshold
  /// and if the velocity is fast enough to trigger a pop action. If so, it pops the current route.
  void _onOverScrollDragEnd(ScaleEndDetails? scaleEndDetails) {
    if (_dragOffset == null) return;
    final dragOffset = _dragOffset!;

    final screenSize = MediaQuery.of(context).size;

    if (scaleEndDetails != null) {
      if (dragOffset.dy.abs() >= screenSize.height / 3) {
        Navigator.of(context, rootNavigator: true).pop();
        return;
      }
      final velocity = scaleEndDetails.velocity.pixelsPerSecond;
      final velocityY = velocity.dy;

      /// Make sure the velocity is fast enough to trigger the pop action
      /// Prevent mistake zoom in fast and drag => check dragOffset.dy.abs() > thresholdOffsetYToEnablePop
      const thresholdOffsetYToEnablePop = 75.0;
      const thresholdVelocityYToEnablePop = 200.0;
      if (velocityY.abs() > thresholdOffsetYToEnablePop &&
          dragOffset.dy.abs() > thresholdVelocityYToEnablePop &&
          _enableDrag) {
        Navigator.of(context, rootNavigator: true).pop();
        return;
      }
    }

    /// Reset position to center of the screen when the drag is canceled.
    setState(() {
      _dragAnimation = Tween<Offset>(
        begin: Offset(0.0, dragOffset.dy),
        end: const Offset(0.0, 0.0),
      ).animate(_dragAnimationController);
      _dragOffset = const Offset(0.0, 0.0);
      _dragAnimationController.forward();
    });
  }

  _onDoubleTap() {
    /// clone matrix4 current
    Matrix4 matrix = _transformationController.value.clone();

    /// Get the current value to see if the image is in zoom out or zoom in state
    final double currentScale = matrix.row0.x;

    /// Suppose the current state is zoom out
    double targetScale = widget.minScale;

    /// Determines the state after a double tap action exactly
    if (currentScale <= widget.minScale) {
      targetScale = widget.maxScale;
    }

    /// calculate new offset of double tap
    final double offSetX =
        targetScale == widget.minScale ? 0.0 : -_doubleTapLocalPosition.dx * (targetScale - 1);
    final double offSetY =
        targetScale == widget.minScale ? 0.0 : -_doubleTapLocalPosition.dy * (targetScale - 1);

    matrix = Matrix4.fromList([
      targetScale,
      matrix.row1.x,
      matrix.row2.x,
      matrix.row3.x,
      matrix.row0.y,
      targetScale,
      matrix.row2.y,
      matrix.row3.y,
      matrix.row0.z,
      matrix.row1.z,
      targetScale,
      matrix.row3.z,
      offSetX,
      offSetY,
      matrix.row2.w,
      matrix.row3.w
    ]);

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: matrix,
    ).animate(
      CurveTween(curve: Curves.easeOut).animate(_animationController),
    );
    _animationController.forward(from: 0);
  }
}












class PreviewImageGalleryScreen extends StatefulWidget {
  const PreviewImageGalleryScreen({super.key, required this.title});

  final String title;

  @override
  State<PreviewImageGalleryScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PreviewImageGalleryScreen> {
  final List<String> imageUrls = [
    'https://images.unsplash.com/photo-1698357877700-034b990b7f21?q=80&w=2792&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1705421624826-8276b4fe4c08?q=80&w=2787&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1705507367127-c90cc471517d?q=80&w=2781&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?q=80&w=2772&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1569084024058-1632922a4e1d?q=80&w=2819&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1602028286725-a4aad1b5d3d9?q=80&w=2835&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 56.0),
          child: CarouselSlider(
            items: imageUrls
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false, // set to false to make the background page transparent
                          pageBuilder: (context, animation, _) => PreviewImageGallery(
                            imageUrls: imageUrls,
                            initialIndex: imageUrls.indexOf(e),
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: "img1_${imageUrls.indexOf(e)}",
                      child: Image.network(
                        e,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              enlargeCenterPage: true,
            ),
          ),
        ),
      ),
    );
  }
}