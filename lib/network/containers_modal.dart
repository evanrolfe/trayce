import 'package:flutter/material.dart';

void showContainersModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const ContainersModal(),
  );
}

class ContainersModal extends StatelessWidget {
  const ContainersModal({super.key});

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
        child: Column(
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
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  border: Border.all(color: const Color(0xFF474747)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
