import 'package:flutter/material.dart';

class DeleteKontakDialog extends StatelessWidget {
  final List<Map<String, String?>> contacts;
  final Function(String) onDelete;

  const DeleteKontakDialog({Key? key, required this.contacts, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Hapus Kontak"),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: contacts.map((contact) {
              return ListTile(
                title: Text(contact['name']!, style: const TextStyle(fontFamily: 'Poppins')),
                trailing: IconButton(
                  icon: Image.asset(
                    'assets/delete.png',
                    height: 24,
                    width: 24,
                  ),
                  onPressed: () {
                    onDelete(contact['name']!);
                    Navigator.pop(context);
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
      ],
    );
  }
}
