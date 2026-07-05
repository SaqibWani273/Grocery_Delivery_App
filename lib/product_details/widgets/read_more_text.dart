import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/product_details/product_details_provider.dart';
import 'package:provider/provider.dart';

/// Description paragraph that truncates with an inline "Read more" link
/// and expands in place.
class ReadMoreText extends StatefulWidget {
  final String text;

  const ReadMoreText({super.key, required this.text});

  @override
  State<ReadMoreText> createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  static const _collapsedLength = 130;

  late final TapGestureRecognizer _toggleTap;

  @override
  void initState() {
    super.initState();
    _toggleTap = TapGestureRecognizer()
      ..onTap = () => context.read<ProductDetailsProvider>().toggleDescription();
  }

  @override
  void dispose() {
    _toggleTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expanded =
        context.watch<ProductDetailsProvider>().isDescriptionExpanded;
    final needsTrim = widget.text.length > _collapsedLength;
    final visibleText = (expanded || !needsTrim)
        ? widget.text
        : '${widget.text.substring(0, _collapsedLength).trimRight()}...';

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: double.infinity,
        child: Text.rich(
          TextSpan(
            text: visibleText,
            style: const TextStyle(
              color: AppColors.textSecondaryGrey,
              fontSize: 14,
              height: 1.6,
            ),
            children: [
              if (needsTrim)
                TextSpan(
                  text: expanded ? ' Read less' : 'Read more',
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                  ),
                  recognizer: _toggleTap,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
