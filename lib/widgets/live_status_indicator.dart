import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class LiveStatusIndicator extends StatefulWidget {
  final int? viewerCount;
  final bool compact;

  const LiveStatusIndicator({
    super.key,
    this.viewerCount,
    this.compact = false,
  });

  @override
  State<LiveStatusIndicator> createState() => _LiveStatusIndicatorState();
}

class _LiveStatusIndicatorState extends State<LiveStatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.compact ? 8 : 12,
        vertical: widget.compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: AppTheme.liveRed.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.liveRed.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: _animation,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppTheme.liveRed,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            widget.viewerCount != null && widget.viewerCount! > 0
                ? 'LIVE • ${widget.viewerCount} watching'
                : 'LIVE NOW',
            style: TextStyle(
              color: AppTheme.liveRed,
              fontWeight: FontWeight.bold,
              fontSize: widget.compact ? 11 : 12,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
