import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> project;
  final role;

  const ProjectDetailsScreen({Key? key, required this.project, required  this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            // عنوان المشروع
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    project['project_name'] ?? 'اسم المشروع غير متوفر',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ),

            // تفاصيل المشروع
           //_buildEditableCardDetail(context, Icons.date_range, 'تاريخ البدء', project['startDate']),
            _buildEditableCardDetail(context, Icons.category, 'نوع المشروع', project['category']),
            _buildEditableCardDetail(context, Icons.calendar_today, 'السنة', project['created_at'].toString()),


            if (project.containsKey('infoCustomer'))
              _buildEditablePaymentCard(context,project['infoCustomer'],  'معلومات الزبون' ),



            if (project.containsKey('completion'))
              _buildEditableCardDetail(context, Icons.percent, 'نسبة الإنجاز', project['completion']),

            if (project.containsKey('features'))
              _buildEditableCardDetail(context, Icons.star, 'الميزات', project['features']),

            if (project.containsKey('filterCleaning'))
              _buildEditableCardLink(context, Icons.cleaning_services, 'تنظيف الفلتر', project['filterCleaning']),

            if (project.containsKey('remoteUsage'))
              _buildEditableCardLink(context, Icons.settings_remote, 'استخدام الريموت', project['remoteUsage']),



            if (project.containsKey('images'))
              //_buildEditableImageGalleryCard(context, project['images']),

            if (project.containsKey('contract') && role == 'admin')
              _buildEditableCardDetail(context, Icons.description, 'اتفاقية العقد', project['contract']),



            if (project.containsKey('templates'))
              _buildEditableCardDetail(context, Icons.file_copy, 'النماذج', project['templates']),

            if(role == 'admin')
              if (project.containsKey('warranty'))
                _buildEditableCardDetail(context, Icons.shield, 'الكفالة', project['warranty']),
              if (project.containsKey('payments')&& role == 'admin')
                _buildEditablePaymentCard(context, project['payments'],'دفعات'),
              if (project.containsKey('MaterialPrice'))
                _buildEditablePaymentCard(context,  project['MaterialPrice'],'اسعار المواد'),
              if (project.containsKey('MaintenanceInstallationWorks'))
                _buildEditablePaymentCard(context,  project['MaintenanceInstallationWorks'],'اعمال الصيانة والتركيب'),
              if (project.containsKey('PriceModels'))
                _buildEditablePaymentCard(context,  project['PriceModels'],'اسعار الوحدات والموديلات'),

            if (project.containsKey('whatsapp'))
              _buildEditableCardLink(context, FontAwesomeIcons.whatsapp, 'تواصل عبر واتساب', project['whatsapp']),
            if (project.containsKey('model'))
              _buildEditableCardLink(context, FontAwesomeIcons.info, 'موديل مكيف', project['model']),
            if (project.containsKey('acSpecs'))
              _buildEditablePaymentCard(context, project['acSpecs'],"مواصفات المكيف"),
           //   _buildEditableCardLink(context, FontAwesomeIcons.info, 'مواصفات المكيف', project['acSpecs']),
            if (project.containsKey('filters'))
              _buildEditablePaymentCard(context, project['filters'],"فلاتر"),
            if (project.containsKey('unitModels'))
              _buildEditablePaymentCard(context, project['unitModels'],"موديلات الوحدات"),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableCardDetail(BuildContext context, IconData icon, String label, String value) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: () => _showEditDialog(context, label, value),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontSize: 16, color: Colors.black),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(width: 8),
            Icon(icon, color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableCardLink(BuildContext context, IconData icon, String label, String url) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blueAccent),
              onPressed: () => _showEditDialog(context, label, url),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // منطق فتح الرابط
                },
                child: Text(
                  url,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
            SizedBox(width: 8),
            Icon(icon, color: Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableImageGalleryCard(BuildContext context, List<String> images) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () {
                    // منطق تعديل الصور
                  },
                ),
                Text(
                  'الصور:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(images[index], width: 100, height: 100, fit: BoxFit.cover),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditablePaymentCard(BuildContext context, List<dynamic> payments,title) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () {
                    // منطق تعديل الدفعات



                  },
                ),
                Text(
                  '$title:',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...payments.map((payment) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        payment,
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    const Icon(Icons.payment, color: Colors.orange),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, String field, String value) {
    TextEditingController controller = TextEditingController(text: value);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تعديل $field'),
          content: TextField(
            controller: controller,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'أدخل القيمة الجديدة',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // منطق حفظ القيمة المعدلة
              },
              child: Text('حفظ'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }
}
