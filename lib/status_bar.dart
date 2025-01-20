import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftrayce/network/bloc/containers_cubit.dart';

class StatusBar extends StatefulWidget {
  const StatusBar({super.key});

  @override
  State<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {
  bool _agentRunning = false;

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

              return DefaultTextStyle.merge(
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFD4D4D4),
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                ),
                child: Text(
                  'Agent: ${_agentRunning ? 'running' : 'not running'}',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
