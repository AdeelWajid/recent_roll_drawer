import 'package:flutter/material.dart';

class ScreenPreview {
  final String title;
  final Widget? icon;
  final Color? color;
  final VoidCallback? onTap;
  final DateTime timestamp;
  final Widget? previewWidget;

  ScreenPreview({
    required this.title,
    this.icon,
    this.color,
    this.onTap,
    DateTime? timestamp,
    this.previewWidget,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ScreenPreviewList extends StatelessWidget {
  final List<ScreenPreview> screens;
  final int maxVisible;
  final double previewHeight;
  final VoidCallback? onClearAll;
  final Color? backgroundColor;

  const ScreenPreviewList({
    super.key,
    required this.screens,
    this.maxVisible = 5,
    this.previewHeight = 120.0,
    this.onClearAll,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (screens.isEmpty) {
      return const SizedBox.shrink();
    }

    final visibleScreens = screens.take(maxVisible).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Pages',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (onClearAll != null && screens.isNotEmpty)
                  TextButton(
                    onPressed: onClearAll,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Clear',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Container(
          color: backgroundColor,
          child: SizedBox(
            height: previewHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: visibleScreens.length,
              itemBuilder: (context, index) {
                return _ScreenPreviewCard(
                  screen: visibleScreens[index],
                  height: previewHeight,
                  isFirst: index == 0,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ScreenPreviewCard extends StatelessWidget {
  final ScreenPreview screen;
  final double height;
  final bool isFirst;

  const _ScreenPreviewCard({
    required this.screen,
    required this.height,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = height * 0.9;

    return GestureDetector(
      onTap: screen.onTap,
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(left: 8, right: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              if (screen.previewWidget != null)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: screenWidth,
                        height: screenHeight,
                        child: RepaintBoundary(
                          child: Container(
                            color: Colors.transparent,
                            child: screen.previewWidget!,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else
                Container(
                  color: screen.color ?? Colors.grey.shade800,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (screen.icon != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Icon(
                            (screen.icon as Icon?)?.icon ?? Icons.pageview,
                            color: Colors.white,
                            size: 32,
                          ),
                        )
                      else
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.pageview,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          screen.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.3],
                    ),
                  ),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.9),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 1,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Text(
                      screen.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
