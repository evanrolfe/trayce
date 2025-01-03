import 'package:flutter/material.dart';

import '../../common/flow_view.dart';
import '../models/flow.dart' as models;
import 'flow_table.dart';

const double minPaneWidth = 300.0;
const Color textColor = Color(0xFFD4D4D4);

class Network extends StatefulWidget {
  const Network({super.key});

  @override
  State<Network> createState() => _NetworkState();
}

class _NetworkState extends State<Network> {
  final ScrollController _controller = ScrollController();
  final List<double> _columnWidths = [
    75.0 / 775.0, // 75px for #
    100.0 / 775.0, // 100px for Protocol
    150.0 / 775.0, // 150px for Source
    150.0 / 775.0, // 150px for Destination
    200.0 / 775.0, // 200px for Operation (expanding)
    100.0 / 775.0, // 100px for Response
  ];
  double _leftPaneWidth = 0.5;
  bool isDividerHovered = false;
  models.Flow? _selectedFlow;

  void _handleColumnResize(int index, double delta) {
    setState(() {
      _columnWidths[index] += delta;
      _columnWidths[index + 1] -= delta;

      // Normalize to ensure total is exactly 1.0
      double total = _columnWidths.reduce((a, b) => a + b);
      if (total != 1.0) {
        double adjustment = (1.0 - total) / 2;
        _columnWidths[index] += adjustment;
        _columnWidths[index + 1] += adjustment;
      }
    });
  }

  void _handleFlowSelected(models.Flow? flow) {
    setState(() {
      _selectedFlow = flow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        return Stack(
          children: [
            Row(
              children: [
                SizedBox(
                  width: totalWidth * _leftPaneWidth,
                  child: FlowTable(
                    controller: _controller,
                    columnWidths: _columnWidths,
                    onColumnResize: _handleColumnResize,
                    onFlowSelected: _handleFlowSelected,
                  ),
                ),
                SizedBox(
                  width: totalWidth * (1 - _leftPaneWidth),
                  child: FlowView(selectedFlow: _selectedFlow),
                ),
              ],
            ),
            Positioned(
              left: totalWidth * _leftPaneWidth - 1.5,
              top: 0,
              bottom: 0,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeColumn,
                onEnter: (_) => setState(() => isDividerHovered = true),
                onExit: (_) => setState(() => isDividerHovered = false),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      double newLeftWidth = _leftPaneWidth * totalWidth + details.delta.dx;
                      double newRightWidth = (1 - _leftPaneWidth) * totalWidth - details.delta.dx;

                      if (newLeftWidth >= minPaneWidth && newRightWidth >= minPaneWidth) {
                        _leftPaneWidth = newLeftWidth / totalWidth;
                      }
                    });
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 3,
                        color: Colors.transparent,
                      ),
                      Positioned(
                        left: 1,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 1,
                          color: isDividerHovered ? const Color(0xFF4DB6AC) : const Color(0xFF474747),
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
