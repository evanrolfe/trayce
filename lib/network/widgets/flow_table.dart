import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/style.dart';
import '../bloc/flow_table_cubit.dart';
import '../models/flow.dart' as models;
import 'containers_modal.dart';

class FlowTable extends StatefulWidget {
  final ScrollController controller;
  final List<double> columnWidths;
  final Function(int, double) onColumnResize;
  final Function(models.Flow?) onFlowSelected;
  static const int totalItems = 10000;
  static const double minColumnWidth = 10.0;

  const FlowTable({
    super.key,
    required this.controller,
    required this.columnWidths,
    required this.onColumnResize,
    required this.onFlowSelected,
  });

  @override
  State<FlowTable> createState() => _FlowTableState();
}

class _FlowTableState extends State<FlowTable> {
  int? selectedRow;

  @override
  void initState() {
    super.initState();
    // Load flows when widget initializes
    context.read<FlowTableCubit>().reloadFlows();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Input Pane
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: const BoxDecoration(
            color: Color(0xFF252526),
            border: Border(
              bottom: BorderSide(color: Colors.black),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: TextField(
                  style: textFieldStyle,
                  decoration: textFieldDecor,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => showContainersModal(context),
                style: commonButtonStyle,
                child: const Text('Containers'),
              ),
            ],
          ),
        ),
        // Table Section
        Expanded(
          child: Column(
            children: [
              // Fixed Header Row
              Container(
                height: 25,
                decoration: const BoxDecoration(
                  color: Color(0xFF333333),
                  border: Border(
                    bottom: BorderSide(color: Colors.black),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final totalWidth = constraints.maxWidth;
                    return Row(
                      children: List.generate(6, (colIndex) {
                        final titles = const ['#', 'Protocol', 'Source', 'Destination', 'Operation', 'Response'];
                        return SizedBox(
                          width: totalWidth * widget.columnWidths[colIndex],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              titles[colIndex],
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFFD4D4D4),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
              // Scrollable Grid
              Expanded(
                child: BlocBuilder<FlowTableCubit, FlowTableState>(
                  builder: (context, state) {
                    if (state is DisplayFlows) {
                      return Focus(
                        autofocus: true,
                        onKeyEvent: (node, event) {
                          if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.arrowUp) {
                            if (selectedRow == null && state.flows.length > 0) {
                              setState(() {
                                selectedRow = 0;
                                widget.onFlowSelected(state.flows[0]);
                              });
                            } else if (selectedRow != null && selectedRow! > 0) {
                              setState(() {
                                selectedRow = selectedRow! - 1;
                                widget.onFlowSelected(state.flows[selectedRow!]);
                              });
                            }
                            return KeyEventResult.handled;
                          } else if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.arrowDown) {
                            if (selectedRow == null && state.flows.isNotEmpty) {
                              setState(() {
                                selectedRow = 0;
                                widget.onFlowSelected(state.flows[0]);
                              });
                            } else if (selectedRow != null && selectedRow! < state.flows.length - 1) {
                              setState(() {
                                selectedRow = selectedRow! + 1;
                                widget.onFlowSelected(state.flows[selectedRow!]);
                              });
                            }
                            return KeyEventResult.handled;
                          }
                          return KeyEventResult.ignored;
                        },
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: widget.controller,
                          thickness: 8,
                          radius: const Radius.circular(4),
                          child: ListView.builder(
                            controller: widget.controller,
                            itemCount: state.flows.length,
                            cacheExtent: 1000,
                            itemExtent: 25,
                            addAutomaticKeepAlives: false,
                            addRepaintBoundaries: false,
                            itemBuilder: (context, index) {
                              final flow = state.flows[index];
                              bool isHovered = false;
                              return StatefulBuilder(
                                builder: (context, setState) => MouseRegion(
                                  onEnter: (_) => setState(() => isHovered = true),
                                  onExit: (_) => setState(() => isHovered = false),
                                  child: GestureDetector(
                                    onTap: () {
                                      this.setState(() {
                                        if (selectedRow == index) {
                                          selectedRow = null;
                                          widget.onFlowSelected(null);
                                        } else {
                                          selectedRow = index;
                                          widget.onFlowSelected(flow);
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(color: Colors.black),
                                        ),
                                        color: selectedRow == index
                                            ? const Color(0xFF4DB6AC).withAlpha(77)
                                            : isHovered
                                                ? const Color(0xFF2D2D2D).withAlpha(77)
                                                : null,
                                      ),
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          final totalWidth = constraints.maxWidth;
                                          return Stack(
                                            children: [
                                              Row(
                                                children: [
                                                  _buildCell(
                                                      totalWidth * widget.columnWidths[0], flow.id?.toString() ?? ''),
                                                  _buildCell(totalWidth * widget.columnWidths[1], flow.l7Protocol),
                                                  _buildCell(totalWidth * widget.columnWidths[2], flow.sourceAddr),
                                                  _buildCell(totalWidth * widget.columnWidths[3], flow.destAddr),
                                                  _buildCell(totalWidth * widget.columnWidths[4],
                                                      flow.request?.operationCol() ?? ''),
                                                  _buildCell(totalWidth * widget.columnWidths[5],
                                                      flow.response?.responseCol() ?? '', true),
                                                ],
                                              ),
                                              ...List.generate(5, (i) {
                                                double leftOffset = totalWidth *
                                                    widget.columnWidths.take(i + 1).reduce((a, b) => a + b);
                                                return _buildDivider(i, totalWidth, leftOffset);
                                              }),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String text) {
    if (text.isEmpty) return Colors.transparent;

    final green = const Color(0xFF3B6118);

    if (text.toLowerCase() == 'ok') return green;

    switch (text[0]) {
      case '1':
        return const Color(0xFF514779);
      case '2':
        return green;
      case '3':
        return const Color(0xFF205A6D);
      case '4':
        return const Color(0xFF7A4C15);
      case '5':
        return const Color(0xFF7A3435);
      default:
        return Colors.transparent;
    }
  }

  Widget _buildCell(double width, String text, [bool isResponse = false]) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: isResponse && text.isNotEmpty
            ? Align(
                alignment: Alignment.centerLeft,
                child: IntrinsicWidth(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    decoration: BoxDecoration(
                      color: _getStatusColor(text),
                      border: Border.all(
                        color: const Color(0xFF1E1E1E),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFD4D4D4),
                      ),
                    ),
                  ),
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFFD4D4D4),
                ),
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );
  }

  Widget _buildDivider(int index, double totalWidth, double leftOffset) {
    return Positioned(
      left: leftOffset - 1.5,
      top: 0,
      bottom: 0,
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: GestureDetector(
          onPanUpdate: (details) {
            // Calculate the proposed new widths in pixels
            double newLeftWidth = widget.columnWidths[index] * totalWidth + details.delta.dx;
            double newRightWidth = widget.columnWidths[index + 1] * totalWidth - details.delta.dx;

            // Only update if both columns would remain wider than minimum
            if (newLeftWidth >= FlowTable.minColumnWidth && newRightWidth >= FlowTable.minColumnWidth) {
              widget.onColumnResize(index, details.delta.dx / totalWidth);
            }
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
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
