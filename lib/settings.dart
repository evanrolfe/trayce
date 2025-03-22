import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trayce/common/style.dart';
import 'package:trayce/network/bloc/containers_cubit.dart';

Future<void> showSettingsModal(BuildContext context) {
  return showDialog(
    context: context,
    builder: (dialogContext) => BlocProvider.value(
      value: context.read<ContainersCubit>(),
      child: const SettingsModal(),
    ),
  );
}

class SettingsModal extends StatefulWidget {
  const SettingsModal({super.key});

  @override
  State<SettingsModal> createState() => _SettingsModalState();
}

class _SettingsModalState extends State<SettingsModal> {
  late final TextEditingController _licenseController;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _licenseController = TextEditingController(
      text: context.read<ContainersCubit>().licenseKey,
    );
  }

  @override
  void dispose() {
    _licenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF252526),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<ContainersCubit, ContainersState>(
          builder: (context, state) {
            String? verificationMessage;
            if (state is AgentVerified) {
              _isVerifying = false;
            }
            verificationMessage =
                context.read<ContainersCubit>().isVerified ? 'License key is valid' : 'License key is invalid';

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Settings',
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
                const SizedBox(height: 24),
                const Text(
                  'License Key',
                  style: TextStyle(
                    color: Color(0xFFD4D4D4),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _licenseController,
                        style: const TextStyle(color: Color(0xFFD4D4D4)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(
                              color: Color(0xFF474747),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(
                              color: Color(0xFF474747),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: const BorderSide(
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isVerifying
                          ? null
                          : () async {
                              final licenseKey = _licenseController.text.trim();
                              if (licenseKey.isNotEmpty) {
                                setState(() => _isVerifying = true);
                                await context.read<ContainersCubit>().setLicenseKey(licenseKey);
                              }
                            },
                      style: commonButtonStyle,
                      child: _isVerifying
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Verify'),
                    ),
                  ],
                ),
                if (verificationMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    verificationMessage,
                    style: TextStyle(
                      color: verificationMessage.contains('invalid') ? Colors.red : Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final licenseKey = _licenseController.text.trim();
                        if (licenseKey.isNotEmpty) {
                          context.read<ContainersCubit>().setLicenseKey(licenseKey);
                        }
                        Navigator.of(context).pop();
                      },
                      style: commonButtonStyle,
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
