import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../model/exam_tip.dart';
import '../../resource/app_colors.dart';

class TipDetailView extends StatelessWidget {
  final ExamTip tip;
  final Color accentColor;

  const TipDetailView({super.key, required this.tip, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Get.back(),
          child: Icon(Icons.arrow_back_ios_new_rounded, size: 20.w, color: AppColors.textPrimary),
        ),
        title: Text(
          'Chi tiết',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border(left: BorderSide(color: accentColor, width: 4.w)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(_getIcon(tip.icon), color: accentColor, size: 24.w),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    tip.title,
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.3),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    tip.summary,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary, height: 1.4),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Content
            ..._buildMarkdownContent(tip.content),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMarkdownContent(String content) {
    final lines = content.split('\n');
    final widgets = <Widget>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      if (line.startsWith('## ')) {
        widgets.add(Padding(
          padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
          child: Text(
            line.replaceFirst('## ', ''),
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
        ));
      } else if (line.startsWith('### ')) {
        widgets.add(Padding(
          padding: EdgeInsets.only(top: 14.h, bottom: 6.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              line.replaceFirst('### ', ''),
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: accentColor),
            ),
          ),
        ));
      } else if (line.startsWith('|') && line.endsWith('|')) {
        // Table row
        final cells = line.split('|').where((c) => c.trim().isNotEmpty).map((c) => c.trim()).toList();
        if (cells.every((c) => c.contains('---'))) continue; // separator row

        final isHeader = i > 0 && i + 1 < lines.length && lines[i + 1].contains('---');
        widgets.add(Container(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: isHeader ? accentColor.withValues(alpha: 0.08) : AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
          ),
          child: Row(
            children: cells.map((cell) => Expanded(
              child: Text(
                cell,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: isHeader ? FontWeight.w700 : FontWeight.w500,
                  color: isHeader ? accentColor : AppColors.textPrimary,
                ),
              ),
            )).toList(),
          ),
        ));
      } else if (line.startsWith('- **') || line.startsWith('- ')) {
        // Bullet with possible bold
        final text = line.replaceFirst('- ', '');
        widgets.add(Padding(
          padding: EdgeInsets.only(left: 8.w, bottom: 6.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 7.h),
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(color: accentColor, shape: BoxShape.circle),
              ),
              SizedBox(width: 10.w),
              Expanded(child: _buildRichText(text)),
            ],
          ),
        ));
      } else if (RegExp(r'^\d+\.\s').hasMatch(line)) {
        // Numbered list
        final match = RegExp(r'^(\d+)\.\s(.+)$').firstMatch(line);
        if (match != null) {
          widgets.add(Padding(
            padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 26.w,
                  height: 26.w,
                  decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      match.group(1)!,
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: accentColor),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(child: _buildRichText(match.group(2)!)),
              ],
            ),
          ));
        }
      } else if (line.startsWith('→')) {
        widgets.add(Padding(
          padding: EdgeInsets.only(left: 16.w, bottom: 6.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.subdirectory_arrow_right_rounded, size: 16.w, color: accentColor),
              SizedBox(width: 6.w),
              Expanded(child: _buildRichText(line.replaceFirst('→ ', ''))),
            ],
          ),
        ));
      } else {
        // Normal paragraph
        widgets.add(Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: _buildRichText(line),
        ));
      }
    }

    return widgets;
  }

  Widget _buildRichText(String text) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'\*\*(.+?)\*\*');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      ));
      lastEnd = match.end;
    }
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary, height: 1.6),
        children: spans.isEmpty ? [TextSpan(text: text)] : spans,
      ),
    );
  }

  IconData _getIcon(String name) {
    const map = {
      'swap_horiz': Icons.swap_horiz_rounded,
      'speed': Icons.speed_rounded,
      'social_distance': Icons.social_distance_rounded,
      'priority_high': Icons.priority_high_rounded,
      'no_drinks': Icons.no_drinks_rounded,
      'block': Icons.block_rounded,
      'warning': Icons.warning_amber_rounded,
      'check_circle': Icons.check_circle_outline_rounded,
      'car_crash': Icons.car_crash_rounded,
      'traffic': Icons.traffic_rounded,
      'do_not_disturb': Icons.do_not_disturb_rounded,
      'local_parking': Icons.local_parking_rounded,
      'directions_car': Icons.directions_car_rounded,
      'grid_view': Icons.grid_view_rounded,
      'directions_walk': Icons.directions_walk_rounded,
      'straighten': Icons.straighten_rounded,
      'terrain': Icons.terrain_rounded,
      'swap_vert': Icons.swap_vert_rounded,
      'compare_arrows': Icons.compare_arrows_rounded,
      'shuffle': Icons.shuffle_rounded,
      'info': Icons.info_outline_rounded,
      'u_turn_left': Icons.u_turn_left_rounded,
      'psychology': Icons.psychology_rounded,
      'timer': Icons.timer_rounded,
      'filter_list': Icons.filter_list_rounded,
      'search': Icons.search_rounded,
      'star': Icons.star_rounded,
      'menu_book': Icons.menu_book_rounded,
      'warning_amber': Icons.warning_amber_rounded,
      'bolt': Icons.bolt_rounded,
      'route': Icons.route_rounded,
      'signpost': Icons.signpost_rounded,
      'dangerous': Icons.dangerous_rounded,
      'palette': Icons.palette_rounded,
      'gpp_bad': Icons.gpp_bad_rounded,
    };
    return map[name] ?? Icons.lightbulb_outline_rounded;
  }
}

