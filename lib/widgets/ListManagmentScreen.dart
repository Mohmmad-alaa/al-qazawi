import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListManagementScreen extends StatefulWidget {
  final List<dynamic> initialData; // البيانات الأولية
  final String documentId; // معرف الوثيقة في قاعدة البيانات
  final String fieldName; // اسم الحقل في الوثيقة
  final String title;
  const ListManagementScreen({
    Key? key,
    required this.initialData,
    required this.documentId,
    required this.fieldName,
    required this.title,
  }) : super(key: key);

  @override
  State<ListManagementScreen> createState() => _ListManagementScreenState();
}

class _ListManagementScreenState extends State<ListManagementScreen> {
  late List<dynamic> items; // قائمة البيانات

  @override
  void initState() {
    super.initState();
    items = List<dynamic>.from(widget.initialData); // نسخ البيانات الأولية
  }

  void _addItem() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('إضافة عنصر جديد'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'العنصر الجديد',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  items.add(controller.text);
                });
                Navigator.of(context).pop();
                _updateDatabase();
              },
              child: const Text('إضافة'),
            ),
          ],
        );
      },
    );
  }

  void _editItem(int index) {
    TextEditingController controller =
    TextEditingController(text: items[index]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تعديل العنصر'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'القيمة الجديدة',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  items[index] = controller.text;
                });
                Navigator.of(context).pop();
                _updateDatabase();
              },
              child: const Text('تعديل'),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف العنصر'),
          content: const Text('هل أنت متأكد من أنك تريد حذف هذا العنصر؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  items.removeAt(index);
                });
                Navigator.of(context).pop();
                _updateDatabase();
              },
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateDatabase() async {
    try {
      await FirebaseFirestore.instance
          .collection('projects') // اسم المجموعة
          .doc(widget.documentId) // معرف الوثيقة
          .update({widget.fieldName: items}); // تحديث الحقل
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء التحديث: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addItem,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              items[index],
              textDirection: TextDirection.rtl,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editItem(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteItem(index),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
