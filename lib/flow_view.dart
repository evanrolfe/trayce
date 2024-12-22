import 'package:flutter/material.dart';

const Color textColor = Color(0xFFD4D4D4);

class FlowView extends StatefulWidget {
  const FlowView({super.key});

  @override
  State<FlowView> createState() => _FlowViewState();
}

class _FlowViewState extends State<FlowView> {
  double _topPaneHeight = 0.5;
  bool isDividerHovered = false;
  int _selectedTopTab = 0;
  int _selectedBottomTab = 0;
  int? _hoveredTabIndex;
  int? _hoveredBottomTabIndex;

  Widget _buildTabs(
      int selectedIndex, Function(int) onTabChanged, bool isTopTabs) {
    return Container(
      height: 30,
      decoration: const BoxDecoration(
        color: Color(0xFF252526),
        border: Border(
          top: BorderSide(color: Color(0xFF474747)),
        ),
      ),
      child: Row(
        children: [
          _buildTab(
              'Tab 1', 0, selectedIndex == 0, () => onTabChanged(0), isTopTabs),
          _buildTab(
              'Tab 2', 1, selectedIndex == 1, () => onTabChanged(1), isTopTabs),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index, bool isSelected, VoidCallback onTap,
      bool isTopTabs) {
    final isHovered =
        isTopTabs ? _hoveredTabIndex == index : _hoveredBottomTabIndex == index;
    return MouseRegion(
      onEnter: (_) => setState(() {
        if (isTopTabs) {
          _hoveredTabIndex = index;
        } else {
          _hoveredBottomTabIndex = index;
        }
      }),
      onExit: (_) => setState(() {
        if (isTopTabs) {
          _hoveredTabIndex = null;
        } else {
          _hoveredBottomTabIndex = null;
        }
      }),
      child: Listener(
        onPointerDown: (_) => onTap(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          constraints: const BoxConstraints(minWidth: 125),
          decoration: BoxDecoration(
            color: isSelected || isHovered
                ? const Color(0xFF2D2D2D)
                : const Color(0xFF252526),
            border: Border(
              top: BorderSide(
                color:
                    isSelected ? const Color(0xFF4DB6AC) : Colors.transparent,
                width: 1,
              ),
              right: const BorderSide(
                color: Color(0xFF474747),
                width: 1,
              ),
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: textColor,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight;
        return Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: totalHeight * _topPaneHeight,
                  child: Column(
                    children: [
                      _buildTabs(_selectedTopTab, (index) {
                        setState(() => _selectedTopTab = index);
                      }, true),
                      Container(
                        height: 1,
                        color: const Color(0xFF474747),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.zero,
                          child: const TextField(
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: 'Enter text here...',
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: totalHeight * (1 - _topPaneHeight),
                  child: Column(
                    children: [
                      _buildTabs(_selectedBottomTab, (index) {
                        setState(() => _selectedBottomTab = index);
                      }, false),
                      Container(
                        height: 1,
                        color: const Color(0xFF474747),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.zero,
                          child: const TextField(
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            style: TextStyle(color: textColor),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: 'Enter text here...',
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              top: totalHeight * _topPaneHeight - 1.5,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeRow,
                onEnter: (_) => setState(() => isDividerHovered = true),
                onExit: (_) => setState(() => isDividerHovered = false),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      final newTopHeight =
                          _topPaneHeight + (details.delta.dy / totalHeight);
                      if (newTopHeight > 0.1 && newTopHeight < 0.9) {
                        _topPaneHeight = newTopHeight;
                      }
                    });
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 3,
                        color: Colors.transparent,
                      ),
                      Positioned(
                        top: 1,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 1,
                          color: isDividerHovered
                              ? const Color(0xFF4DB6AC)
                              : const Color(0xFF474747),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
