import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/network_utils.dart';
import '../bloc/containers_cubit.dart';

void showContainersModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => BlocProvider.value(
      value: context.read<ContainersCubit>(),
      child: const ContainersModal(),
    ),
  );
}

class ContainersModal extends StatefulWidget {
  const ContainersModal({super.key});

  @override
  State<ContainersModal> createState() => _ContainersModalState();
}

class _ContainersModalState extends State<ContainersModal> {
  final Map<String, bool> _interceptedStates = {};
  bool _initialized = false;
  String _machineIp = '127.0.0.1';

  @override
  void initState() {
    super.initState();
    getMachineIp().then((ip) {
      setState(() {
        _machineIp = ip;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final cubit = context.read<ContainersCubit>();
      final state = cubit.state;
      if (state is ContainersLoaded) {
        for (var container in state.containers) {
          _interceptedStates[container.id] = cubit.interceptedContainerIds.contains(container.id);
        }
      }
      _initialized = true;
    }
  }

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
        child: BlocBuilder<ContainersCubit, ContainersState>(
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
                                              Opacity(
                                                opacity: container.image == 'trayce_agent:local' ? 0.25 : 1.0,
                                                child: Container(
                                                  padding: const EdgeInsets.only(left: 16),
                                                  child: Row(
                                                    children: [
                                                      Checkbox(
                                                        value: _interceptedStates[container.id] ?? false,
                                                        onChanged: container.image == 'trayce_agent:local'
                                                            ? null // null onChanged makes the checkbox disabled
                                                            : (bool? value) {
                                                                setState(() {
                                                                  _interceptedStates[container.id] = value ?? false;
                                                                });
                                                              },
                                                        side: const BorderSide(color: Color(0xFFD4D4D4)),
                                                        fillColor: MaterialStateProperty.resolveWith(
                                                          (states) {
                                                            if (container.image == 'trayce_agent:local') {
                                                              return Colors.grey; // greyed out when disabled
                                                            }
                                                            return states.contains(MaterialState.selected)
                                                                ? const Color(0xFF4DB6AC)
                                                                : Colors.transparent;
                                                          },
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
                          // Get selected container IDs
                          final selectedIds = state.containers
                              .where((container) => _interceptedStates[container.id] ?? false)
                              .map((container) => container.id)
                              .toList();

                          // Call interceptContainers on the cubit
                          context.read<ContainersCubit>().interceptContainers(selectedIds);

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
            // Default case: show agent not running message
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
                  'Trayce Agent is not running! Start it by running this command in the terminal:',
                  style: TextStyle(
                    color: Color(0xFFD4D4D4),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    border: Border.all(color: const Color(0xFF474747)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: SelectableText(
                    'docker run --pid=host --privileged -v /var/run/docker.sock:/var/run/docker.sock -t traycer/trayce_agent:latest -s $_machineIp:50051',
                    style: const TextStyle(
                      color: Color(0xFFD4D4D4),
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
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
