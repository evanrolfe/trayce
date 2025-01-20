import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftrayce/network/bloc/containers_cubit.dart';
import 'package:ftrayce/network/widgets/containers_modal.dart';

class StatusBar extends StatefulWidget {
  const StatusBar({super.key});

  @override
  State<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {
  bool _agentRunning = false;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      decoration: const BoxDecoration(
        color: Color(0xFF333333),
        border: Border(
          top: BorderSide(
            color: Color(0xFF4DB6AC),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BlocBuilder<ContainersCubit, ContainersState>(
            builder: (context, state) {
              final cubit = context.read<ContainersCubit>();
              _agentRunning = cubit.agentRunning;

              return MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() => _isHovering = true),
                onExit: (_) => setState(() => _isHovering = false),
                child: GestureDetector(
                  onTap: () => showContainersModal(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: _isHovering ? const Color(0xFF3A3A3A) : Colors.transparent,
                    ),
                    child: DefaultTextStyle.merge(
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFD4D4D4),
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none,
                      ),
                      child: Text(
                        'Agent: ${_agentRunning ? 'running' : 'not running'}',
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
