import 'package:flutter/material.dart';

class DeleteKontakDialog extends StatelessWidget {
  final List<Map<String, String>> contacts;
  final Function(String) onDelete;

  const DeleteKontakDialog({
    Key? key,
    required this.contacts,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Hapus Kontak",
        style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: contacts.map((contact) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text(
                    contact['name'] ?? 'Nama tidak tersedia',
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  trailing: IconButton(
                    icon: Image.asset(
                      'assets/delete.png',
                      height: 24,
                      width: 24,
                    ),
                    onPressed: () {
                      _showConfirmationDialog(context, contact['name'] ?? 'Nama tidak tersedia');
                    },
                  ),
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

  void _showConfirmationDialog(BuildContext context, String contactName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Penghapusan"),
          content: Text("Apakah Anda yakin ingin menghapus kontak $contactName?"),
          actions: [
            TextButton(
              onPressed: () {
                onDelete(contactName);
                Navigator.pop(context);
              },
              child: const Text("Hapus"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
          ],
        );
      },
    );
  }
}