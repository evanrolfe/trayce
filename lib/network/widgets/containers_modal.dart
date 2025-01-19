import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/style.dart';
import '../../common/utils.dart';
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
  late final TextEditingController _commandController;
  bool _showCopyCheck = false;

  @override
  void initState() {
    super.initState();
    _commandController = TextEditingController();
    _updateCommandText();
    getMachineIp().then((ip) {
      setState(() {
        _machineIp = ip;
        _updateCommandText();
      });
    });
  }

  void _updateCommandText() {
    final state = context.read<ContainersCubit>().state;
    if (state is ContainersLoaded && !state.versionOk()) {
      _commandController.text = 'docker pull traycer/trayce_agent:latest';
    } else {
      _commandController.text =
          'docker run -d --name trayce_agent -v /var/run/docker.sock:/var/run/docker.sock -e TRAYCE_HOST=$_machineIp traycer/trayce_agent:latest';
    }
    _commandController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _commandController.text.length,
    );
  }

  @override
  void dispose() {
    _commandController.dispose();
    super.dispose();
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
  void didUpdateWidget(ContainersModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateCommandText();
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
            // Update command text whenever state changes
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _updateCommandText();
            });

            if (state is ContainersLoaded) {
              if (state.versionOk()) {
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
                          style: commonButtonStyle,
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Manage your containers',
                          style: TextStyle(
                            color: Color(0xFFD4D4D4),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xFFD4D4D4),
                            size: 20,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Trayce Agent is on an incompatible version. Please update it by running this command and then restarting the agent:',
                      style: TextStyle(
                        color: Color(0xFFD4D4D4),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      height: 70, // Enough height for two lines plus padding
                      child: TextField(
                        readOnly: true,
                        maxLines: null,
                        expands: true,
                        controller: _commandController,
                        style: textFieldStyle,
                        decoration: textFieldDecor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 70,
                        child: ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: _commandController.text));
                            setState(() {
                              _showCopyCheck = true;
                            });
                            Future.delayed(const Duration(seconds: 2), () {
                              if (mounted) {
                                setState(() {
                                  _showCopyCheck = false;
                                });
                              }
                            });
                          },
                          style: commonButtonStyle,
                          child: _showCopyCheck ? const Icon(Icons.check, size: 16) : const Text('Copy'),
                        ),
                      ),
                    ),
                  ],
                );
              }
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
                  height: 70, // Enough height for two lines plus padding
                  child: TextField(
                    readOnly: true,
                    maxLines: null,
                    expands: true,
                    controller: _commandController,
                    style: textFieldStyle,
                    decoration: textFieldDecor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 70,
                    child: ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _commandController.text));
                        setState(() {
                          _showCopyCheck = true;
                        });
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            setState(() {
                              _showCopyCheck = false;
                            });
                          }
                        });
                      },
                      style: commonButtonStyle,
                      child: _showCopyCheck ? const Icon(Icons.check, size: 16) : const Text('Copy'),
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
