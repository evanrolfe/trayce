import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;

import '../bloc/proto_def_cubit.dart';
import '../models/proto_def.dart';
import '../repo/proto_def_repo.dart';

Future<void> showProtoDefModal(BuildContext context) {
  return showDialog(
    context: context,
    builder: (dialogContext) => BlocProvider(
      create: (context) => ProtoDefCubit(context.read<ProtoDefRepo>())..loadProtoDefs(),
      child: const ProtoDefModal(),
    ),
  );
}

class ProtoDefModal extends StatefulWidget {
  const ProtoDefModal({super.key});

  @override
  State<ProtoDefModal> createState() => _ProtoDefModalState();
}

class _ProtoDefModalState extends State<ProtoDefModal> {
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
        child: BlocBuilder<ProtoDefCubit, ProtoDefState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Proto Definitions',
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
                Row(
                  children: [
                    const Text(
                      'Manage your .proto file definitions',
                      style: TextStyle(
                        color: Color(0xFFD4D4D4),
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles();
                        if (result != null) {
                          final file = result.files.single;
                          String contents;
                          String filePath;

                          if (file.bytes != null) {
                            // For web platform
                            contents = String.fromCharCodes(file.bytes!);
                            filePath = file.name;
                          } else if (file.path != null) {
                            // For desktop/mobile platforms
                            contents = await File(file.path!).readAsString();
                            filePath = file.path!;
                          } else {
                            return;
                          }

                          final fileName = path.basename(filePath);
                          final protoDef = ProtoDef(
                            name: fileName,
                            filePath: filePath,
                            protoFile: contents,
                            createdAt: DateTime.now(),
                          );

                          final protoDefRepo = context.read<ProtoDefRepo>();
                          await protoDefRepo.save(protoDef);

                          // Refresh the list
                          if (!context.mounted) return;
                          context.read<ProtoDefCubit>().loadProtoDefs();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4DB6AC),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: const Size(0, 30),
                        maximumSize: const Size(double.infinity, 30),
                        textStyle: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFD4D4D4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text('Upload'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (state is ProtoDefLoading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (state is ProtoDefError)
                  Expanded(
                    child: Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: const TextStyle(
                          color: Color(0xFFD4D4D4),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                else if (state is ProtoDefLoaded)
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF474747),
                                width: 1,
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Table(
                                border: TableBorder(
                                  horizontalInside: BorderSide(
                                    color: const Color(0xFF474747).withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                columnWidths: const {
                                  0: FlexColumnWidth(2), // Name
                                  1: FlexColumnWidth(4), // Path
                                  2: FlexColumnWidth(2), // Created At
                                  3: FlexColumnWidth(1), // Actions
                                },
                                children: [
                                  TableRow(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF2D2D2D),
                                    ),
                                    children: [
                                      _buildHeaderCell('Name'),
                                      _buildHeaderCell('Path'),
                                      _buildHeaderCell('Created At'),
                                      _buildHeaderCell('Actions'),
                                    ],
                                  ),
                                  ...state.protoDefs.map((protoDef) => TableRow(
                                        children: [
                                          _buildCell(protoDef.name),
                                          _buildCell(protoDef.filePath),
                                          _buildCell(protoDef.createdAt.toString()),
                                          _buildCell('', alignment: Alignment.center),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4DB6AC),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                minimumSize: const Size(0, 30),
                                maximumSize: const Size(double.infinity, 30),
                                textStyle: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFD4D4D4),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text('Ok'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFD4D4D4),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCell(String text, {Alignment alignment = Alignment.centerLeft}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: alignment,
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFFD4D4D4),
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
