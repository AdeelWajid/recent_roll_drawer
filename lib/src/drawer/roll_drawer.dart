import 'package:flutter/material.dart';
import '../controllers/drawer_controller.dart';
import '../controllers/screen_stack_controller.dart';
import 'screen_preview.dart';

class RollDrawer extends StatefulWidget {
  final Widget child;
  final Widget drawer;
  final RollDrawerController? controller;
  final ScreenStackController? screenStackController;
  final double drawerWidth;
  final Duration animationDuration;
  final Curve animationCurve;
  final VoidCallback? onDrawerChanged;
  final double cylinderWidth;
  final EdgeInsets drawerPadding;
  final bool showScreenPreviews;
  final int maxScreenPreviews;
  final Color? screenPreviewBackgroundColor;
  final bool enableAnimation;
  final bool enableRollEffect;

  const RollDrawer({
    super.key,
    required this.child,
    required this.drawer,
    this.controller,
    this.screenStackController,
    this.drawerWidth = 300.0,
    this.animationDuration = const Duration(milliseconds: 600),
    this.animationCurve = Curves.easeInOutCubic,
    this.onDrawerChanged,
    this.cylinderWidth = 45.0,
    this.drawerPadding = EdgeInsets.zero,
    this.showScreenPreviews = true,
    this.maxScreenPreviews = 5,
    this.screenPreviewBackgroundColor,
    this.enableAnimation = true,
    this.enableRollEffect = true,
  });

  @override
  State<RollDrawer> createState() => _RollDrawerState();
}

class _RollDrawerState extends State<RollDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rollAnimation;
  late RollDrawerController _internalController;
  double _actualDrawerWidth = 0;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? RollDrawerController();
    _internalController.addListener(_onControllerChanged);

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _rollAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    )..addListener(() {
        setState(() {});
      });

    _actualDrawerWidth = widget.drawerWidth;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted && _actualDrawerWidth != widget.drawerWidth) {
        setState(() {
          _actualDrawerWidth = widget.drawerWidth;
        });
      }
    });
  }

  void _onControllerChanged() {
    if (widget.enableAnimation) {
      if (_internalController.isOpen) {
        if (!_controller.isAnimating) {
          _controller.forward();
        }
      } else {
        if (!_controller.isAnimating) {
          _controller.reverse();
        }
      }
    } else {
      if (_internalController.isOpen) {
        _controller.value = 1.0;
      } else {
        _controller.value = 0.0;
      }
      setState(() {});
    }
    widget.onDrawerChanged?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    _rollAnimation.removeListener(() {});
    _internalController.removeListener(_onControllerChanged);
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  void _handleTap() {
    _internalController.close();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double rollProgress = _rollAnimation.value;
    final double rollPos = rollProgress * _actualDrawerWidth;

    if (!widget.enableRollEffect) {
      return _buildSimpleDrawer(rollProgress);
    }

    return _buildRollDrawer(size, rollProgress, rollPos);
  }

  Widget _buildSimpleDrawer(double rollProgress) {
    return Stack(
      children: [
        Positioned.fill(child: widget.child),
        AnimatedPositioned(
          duration:
              widget.enableAnimation ? widget.animationDuration : Duration.zero,
          curve: widget.animationCurve,
          right: rollProgress > 0.1 ? 0 : -_actualDrawerWidth,
          top: 0,
          bottom: 0,
          width: _actualDrawerWidth,
          child: IgnorePointer(
            ignoring: rollProgress < 0.1,
            child: Container(
              color: Theme.of(context).drawerTheme.backgroundColor ??
                  Theme.of(context).scaffoldBackgroundColor,
              child: _buildDrawerWithPreviews(),
            ),
          ),
        ),
        if (rollProgress > 0.8)
          Positioned(
            left: 0,
            right: _actualDrawerWidth,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _handleTap,
              child: Container(
                color: Colors.black.withValues(alpha: 0.3),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRollDrawer(Size size, double rollProgress, double rollPos) {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: rollProgress < 0.1,
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: _actualDrawerWidth,
              child: Padding(
                padding: widget.drawerPadding,
                child: _buildDrawerWithPreviews(),
              ),
            ),
          ),
        ),
        ClipRect(clipper: _RightClipper(rollPos), child: widget.child),
        if (rollProgress > 0)
          Positioned(
            right: rollPos - (widget.cylinderWidth / 2),
            top: 0,
            bottom: 0,
            width: widget.cylinderWidth,
            child: IgnorePointer(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(widget.cylinderWidth / 2),
                    child: OverflowBox(
                      maxWidth: size.width,
                      alignment: Alignment.centerRight,
                      child: Transform.translate(
                        offset: Offset(rollPos, 0),
                        child: widget.child,
                      ),
                    ),
                  ),
                  _buildCylinderLighting(widget.cylinderWidth),
                ],
              ),
            ),
          ),
        if (rollProgress > 0.8)
          Positioned(
            left: 0,
            right: _actualDrawerWidth,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _handleTap,
              child: Container(color: Colors.transparent),
            ),
          ),
      ],
    );
  }

  Widget _buildCylinderLighting(double width) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withValues(alpha: 0.5),
            Colors.white.withValues(alpha: 0.35),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.6),
          ],
          stops: const [0.0, 0.2, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildDrawerWithPreviews() {
    if (!widget.showScreenPreviews || widget.screenStackController == null) {
      return widget.drawer;
    }

    final screenController = widget.screenStackController!;

    return ListenableBuilder(
      listenable: screenController,
      builder: (context, _) {
        final screens = screenController.screens;

        if (screens.isEmpty) {
          return widget.drawer;
        }

        return Column(
          children: [
            ScreenPreviewList(
              screens: screens,
              maxVisible: widget.maxScreenPreviews,
              onClearAll: () => screenController.clearAll(),
              backgroundColor: widget.screenPreviewBackgroundColor,
            ),
            const Divider(color: Colors.white24, height: 1),
            Expanded(child: widget.drawer),
          ],
        );
      },
    );
  }
}

class _RightClipper extends CustomClipper<Rect> {
  final double offset;

  _RightClipper(this.offset);

  @override
  Rect getClip(Size size) =>
      Rect.fromLTRB(0, 0, size.width - offset, size.height);

  @override
  bool shouldReclip(_RightClipper oldClipper) => oldClipper.offset != offset;
}
