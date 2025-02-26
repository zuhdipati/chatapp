import 'package:flutter/material.dart';

class DefaultData {
// default list of five reactions to be displayed from emojis and a plus icon at the end
// the plus icon will be used to add more reactions
  static const List<String> reactions = [
    '👍',
    '❤️',
    '😂',
    '😮',
    '😢',
    '😠',
    '➕',
  ];
  // The default list of menuItems
  static const List<MenuItem> menuItems = [
    reply,
    copy,
    delete,
  ];

  // defaul reply menu item
  static const MenuItem reply = MenuItem(
    label: 'Reply',
    icon: Icons.reply,
  );

  // default copy menu item
  static const MenuItem copy = MenuItem(
    label: 'Copy',
    icon: Icons.copy,
  );

  // default edit menu item
  static const MenuItem delete = MenuItem(
    label: 'Delete',
    icon: Icons.delete_forever,
    isDestuctive: true,
  );
}

class MenuItem {
  final String label;
  final IconData icon;
  final bool isDestuctive;

  // contsructor
  const MenuItem({
    required this.label,
    required this.icon,
    this.isDestuctive = false,
  });
}
