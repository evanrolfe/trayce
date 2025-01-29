import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftrayce/common/style.dart';

class AppMenuBar extends StatelessWidget {
  final Widget child;
  final String appVersion;

  const AppMenuBar({
    super.key,
    required this.child,
    required this.appVersion,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isMacOS) {
      return PlatformMenuBar(
        menus: [
          PlatformMenu(
            label: 'File',
            menus: [
              PlatformMenuItem(
                label: 'Open',
                shortcut: const SingleActivator(LogicalKeyboardKey.keyO, meta: true),
                onSelected: () {
                  // TODO: Implement open
                },
              ),
              PlatformMenuItem(
                label: 'Save',
                shortcut: const SingleActivator(LogicalKeyboardKey.keyS, meta: true),
                onSelected: () {
                  // TODO: Implement save
                },
              ),
            ],
          ),
          PlatformMenu(
            label: 'Help',
            menus: [
              PlatformMenuItem(
                label: 'About',
                onSelected: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Trayce',
                    applicationVersion: appVersion,
                    applicationIcon: const Icon(Icons.track_changes),
                  );
                },
              ),
            ],
          ),
        ],
        child: child,
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: MenuBar(
          style: const MenuStyle(
            backgroundColor: WidgetStatePropertyAll(Color(0xFF333333)),
            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
            elevation: WidgetStatePropertyAll(0),
          ),
          children: [
            SubmenuButton(
              style: menuButtonStyle,
              menuStyle: menuStyle,
              alignmentOffset: const Offset(0, 24),
              menuChildren: [
                MenuItemButton(
                  style: menuItemStyle,
                  onPressed: () {
                    // TODO: Implement open
                  },
                  shortcut: const SingleActivator(LogicalKeyboardKey.keyO, control: true),
                  child: const Text('Open'),
                ),
                MenuItemButton(
                  style: menuItemStyle,
                  onPressed: () {
                    // TODO: Implement save
                  },
                  shortcut: const SingleActivator(LogicalKeyboardKey.keyS, control: true),
                  child: const Text('Save'),
                ),
              ],
              child: const Text('File'),
            ),
            SubmenuButton(
              style: menuButtonStyle,
              menuStyle: menuStyle,
              alignmentOffset: const Offset(0, 24),
              menuChildren: [
                MenuItemButton(
                  style: menuItemStyle,
                  onPressed: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Trayce',
                      applicationVersion: appVersion,
                      applicationIcon: const Icon(Icons.track_changes),
                    );
                  },
                  child: const Text('About'),
                ),
              ],
              child: const Text('Help'),
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}
