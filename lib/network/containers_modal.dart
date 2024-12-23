import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/containers_bloc.dart';

void showContainersModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const ContainersModal(),
  );
}

class ContainersModal extends StatefulWidget {
  const ContainersModal({super.key});

  @override
  State<ContainersModal> createState() => _ContainersModalState();
}

class _ContainersModalState extends State<ContainersModal> {
  final Map<String, bool> _interceptedStates = {};

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF252526),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<ContainersBloc, ContainersState>(
          builder: (context, state) {
            if (state is ContainersLoaded) {
              print('ContainersLoaded state received with ${state.containers.length} containers');
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Containers',
                        style: TextStyle(
                          color: Color(0xFFD4D4D4),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close,
                          color: Color(0xFFD4D4D4),
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select which containers you want to monitor',
                    style: TextStyle(
                      color: Color(0xFFD4D4D4),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        border: Border.all(color: const Color(0xFF474747)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 25,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Color(0xFF474747)),
                              ),
                            ),
                            child: const Row(
                              children: [
                                _HeaderCell(text: 'ID', width: 100),
                                _HeaderCell(text: 'Image', width: 200),
                                _HeaderCell(text: 'IP', width: 120),
                                _HeaderCell(text: 'Name', width: 150),
                                _HeaderCell(text: 'Status', width: 100),
                                Expanded(child: _HeaderCell(text: 'Intercepted?', width: 100)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.containers.length,
                              itemBuilder: (context, index) {
                                final container = state.containers[index];
                                return Container(
                                  height: 25,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Color(0xFF474747)),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      _Cell(text: container.id.substring(0, 6), width: 100),
                                      _Cell(text: container.image, width: 200),
                                      _Cell(text: container.ip, width: 120),
                                      _Cell(text: container.name, width: 150),
                                      _Cell(text: container.status, width: 100),
                                      Expanded(
                                        child: SizedBox(
                                          width: 100,
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                value: _interceptedStates[container.id] ?? false,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    _interceptedStates[container.id] = value ?? false;
                                                  });
                                                },
                                                side: const BorderSide(color: Color(0xFFD4D4D4)),
                                                fillColor: MaterialStateProperty.resolveWith(
                                                  (states) => states.contains(MaterialState.selected)
                                                      ? const Color(0xFF4DB6AC)
                                                      : Colors.transparent,
                                                ),
                                              ),
                                              Text(
                                                _interceptedStates[container.id] ?? false ? 'Yes' : 'No',
                                                style: const TextStyle(
                                                  color: Color(0xFFD4D4D4),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Handle save
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4DB6AC),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final double width;

  const _HeaderCell({
    required this.text,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFD4D4D4),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final double width;

  const _Cell({
    required this.text,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFD4D4D4),
        ),
      ),
    );
  }
}
