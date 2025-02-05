import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/firebase_service.dart';
import '../widgets/ListManagmentScreen.dart';
import 'PdfManagerPage.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final String project;
  final String role;
  final String userId;
  final String projectUserId;
  const ProjectDetailsScreen({
    Key? key,
    required this.project,
    required this.role,
    required this.userId,
    required this.projectUserId,
  }) : super(key: key);

  @override
  _ProjectDetailsScreenState createState() =>
      _ProjectDetailsScreenState(projectN: project, role: role);
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  String projectN;
  final role;

  Map<String, dynamic>? userInfo;
  bool isLoading = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchUserData(widget.projectUserId);
  }

  Future<void> fetchUserData(String userId) async {
    // إنشاء كائن من UserService
    final userService = FirebaseService();

    // جلب بيانات المستخدم
    final data = await userService.getUserInfo(userId);

    // تحديث حالة الشاشة
    setState(() {
      userInfo = data;
      isLoading = false;
    });
  }

  _ProjectDetailsScreenState({required this.projectN, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('projects')
                .doc(projectN)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return const Text('اسم المشروع غير متوفر');
              }

              final project = snapshot.data!.data() as Map<String, dynamic>;
              return Text(
                project['project_name'] ?? 'اسم المشروع غير متوفر',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              );
            },
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('projects')
                .doc(projectN)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('لا توجد بيانات'));
              }

              final project = snapshot.data!.data() as Map<String, dynamic>;
              //fetchUserData(project['userId']);
              print(project);
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.count(
                  crossAxisCount: 2, // عدد الأعمدة
                  crossAxisSpacing: 12.0, // المسافة الأفقية بين العناصر
                  mainAxisSpacing: 12.0, // المسافة العمودية بين العناصر
                  children: [
                    _buildEditableCardDetail(context, Icons.category,
                        'نوع المشروع', project['category'], 'category'),
                    _buildEditableCardDetail(
                        context,
                        Icons.calendar_today,
                        'السنة',
                        project['created_at'].toString(),
                        "created_at"),
                    //showUserInfoDialog(context: context,userInfo: userInfo,onSave: (fetchUserData()){print("object");}),
                    _buildInfoDetail(context, Icons.info_outline,
                        'معلومات الزبون', project['userId'], 'userId'),
                   /* if (project.containsKey('infoCustomer'))
                      _buildEditableCardDetail(
                          context,
                          Icons.info,
                          'معلومات الزبون',
                          project['infoCustomer'],
                          'infoCustomer'),*/
                    if (project.containsKey('warranty'))
                      _buildEditableCardDetail(context, Icons.shield,
                          'الكفالة', project['warranty'], 'warranty'),
                    if (project.containsKey('completion'))
                      _buildEditableCardDetail(context, Icons.percent,
                          'نسبة الإنجاز', project['completion'], "completion"),
                    if (project.containsKey('features'))
                      _buildEditablePaymentCard(context, project['features'],
                          'الميزات', Icons.ac_unit, 'features', projectN),
                    if (project.containsKey('filterCleaning'))
                      _buildEditableCardDetail(
                          context,
                          Icons.cleaning_services,
                          'تنظيف الفلتر',
                          project['filterCleaning'],
                          'filterCleaning'),
                    if (project.containsKey('remoteUsage'))
                      _buildEditableCardDetail(
                          context,
                          Icons.settings_remote,
                          'استخدام الريموت',
                          project['remoteUsage'],
                          'remoteUsage'),
                    if (project.containsKey('contract') && role == 'admin')
                      _buildEditableCardDetail(context, Icons.description,
                          'اتفاقية العقد', project['contract'], 'contract'),
                    if (project.containsKey('unitModels'))
                      _buildEditablePaymentCard(
                          context,
                          project['unitModels'],
                          'الوحدات والموديلات',
                          Icons.ac_unit,
                          'unitModels',
                          projectN),
                    if (project.containsKey('Equipment'))
                      _buildEditablePaymentCard(
                          context,
                          project['Equipment'],
                          'المعدات اللازمة',
                          Icons.info,
                          'Equipment',
                          projectN),
                    if (project.containsKey('templates'))
                      _buildEditPdfDetail(context, Icons.picture_as_pdf,
                          'ملف PDF', project['templates'], 'templates'),
                    if (role == 'admin')

                    if (project.containsKey('payments') && role == 'admin')
                      _buildEditablePaymentCard(context, project['payments'],
                          'دفعات', Icons.ac_unit, 'payments', projectN),
                    if (project.containsKey('MaterialPrice') && role == 'admin')
                      _buildEditablePaymentCard(
                          context,
                          project['MaterialPrice'],
                          'اسعار المواد',
                          Icons.ac_unit,
                          'MaterialPrice',
                          projectN),
                    if (project.containsKey('MaintenanceInstallationWorks') &&
                        role == 'admin')
                      _buildEditablePaymentCard(
                          context,
                          project['MaintenanceInstallationWorks'],
                          'اعمال الصيانة والتركيب',
                          Icons.ac_unit,
                          'MaintenanceInstallationWorks',
                          projectN),
                    if (project.containsKey('PriceModels') && role == 'admin')
                      _buildEditablePaymentCard(
                          context,
                          project['PriceModels'],
                          'اسعار الوحدات والموديلات',
                          Icons.ac_unit,
                          'PriceModels',
                          projectN),
                    if (project.containsKey('whatsapp'))
                      _buildEditableCardDetail(
                          context,
                          FontAwesomeIcons.whatsapp,
                          'تواصل عبر واتساب',
                          project['whatsapp'],
                          'whatsapp'),
                    if (project.containsKey('model'))
                      _buildEditableCardDetail(context, FontAwesomeIcons.info,
                          'موديل مكيف', project['model'], 'model'),
                    if (project.containsKey('acSpecs'))
                      _buildEditablePaymentCard(
                          context,
                          project['acSpecs'],
                          "مواصفات المكيف",
                          Icons.ac_unit,
                          'acSpecs',
                          projectN),
                    /*if (project.containsKey('filters'))
                      _buildEditableCardDetail(context, Icons.info, "فلاتر",
                          project['filters'], 'filters'),*/
                  ],
                ),
              );
            }));
  }

  Widget _buildEditableCardDetail(BuildContext context, IconData icon,
      String label, String value, String f) {
    return InkWell(
      onTap: () {
        _showDetailDialog(context, label, value);
      },
      child: ClipOval(
        child: Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100), // الحواف الدائرية
          ),
          child: Container(
            width: 190,
            height: 190,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.blueAccent, size: 30),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () => _showEditDialog(context, f, value, label),
                ),
              ],
            ),
          ),
        ),
      ),
  );
}
Widget _buildEditPdfDetail(BuildContext context, IconData icon,
      String label, String value, String f) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PdfManagerPage()), // استبدل AddPage بصفحتك
        );
      },
      child: ClipOval(
        child: Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100), // الحواف الدائرية
          ),
          child: Container(
            width: 190,
            height: 190,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.blueAccent, size: 30),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildEditImageDetail(BuildContext context, IconData icon,
      String label, String value, String f) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PdfManagerPage()), // استبدل AddPage بصفحتك
        );
      },
      child: ClipOval(
        child: Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100), // الحواف الدائرية
          ),
          child: Container(
            width: 190,
            height: 190,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.blueAccent, size: 30),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _showDetailDialog(BuildContext context, String label, String value) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(label, textDirection: TextDirection.rtl),
          content: SingleChildScrollView(
            child: Text(
              value,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditablePaymentCard(BuildContext context, List<dynamic> payments,
      String titlee, IconData icon, String f, String id) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100), // الحواف الدائرية
      ),
      child: ClipOval(
        child: InkWell(
          // لجعل البطاقة قابلة للضغط
          onTap: () {
            //_showPaymentsDialog(context, titlee, payments);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListManagementScreen(
                  initialData: payments, // البيانات الأولية
                  documentId: id, // معرف الوثيقة
                  fieldName: f,
                  title: titlee, // اسم الحقل
                ),
              ),
            );
          },
          child: Container(
            width: 190,
            height: 190,
            color: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  icon,
                  color: Colors.blueAccent,
                  size: 35,
                ),
                Text(
                  '$titlee:', // عرض العنوان
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  textDirection: TextDirection.rtl,
                ),
                /* IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () {

                    //_showEditDialogList(context, f, payments);
                  },
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, String field, String value, String title) {
    TextEditingController controller = TextEditingController(text: value);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('تعديل $title'),
          content: TextField(
            controller: controller,
            textDirection: TextDirection.rtl,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'أدخل القيمة الجديدة',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {

                // منطق حفظ القيمة المعدلة (Firebase كمثال)
                try {
                  await FirebaseFirestore.instance
                      .collection('projects') // اسم المجموعة
                      .doc(projectN) // معرف المشروع
                      .update({field: controller.text}); // تحديث الحقل

                  // تحديث الواجهة
                  /*setState(() {
                    project[field] = controller.text; // تحديث الحقل محليًا
                  });*/
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$title تم تحديثه بنجاح')),
                  );
                 // Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('حدث خطأ: $e')),
                  );

                }
                Navigator.of(context).pop();
              },
              child: const Text('حفظ'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }
  Future<void> _saveUserDetails() async {
      // إذا كانت البيانات صحيحة


  }

  Widget _buildInfoDetail(BuildContext context, IconData icon,
      String label, String value, String f) {
    return InkWell(
      onTap: () {
       // showUserInfoDialog(context: context,userInfo: userInfo,onSave: (f){print("");});

        if (userInfo != null) {

          showUserInfoDialog(
            context: context,
            userInfo: userInfo!,
            onSave: (updatedUserInfo) {
              // Handle updated user info here
              print("Updated User Info: $updatedUserInfo");
            },
          );
        } else {
          print("User info is null");
        }
      },
      child: ClipOval(
        child: Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100), // الحواف الدائرية
          ),
          child: Container(
            width: 190,
            height: 190,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.blueAccent, size: 30),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 8),
              /*  IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () => _showEditDialog(context, f, value, label),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> showUserInfoDialog({
    required BuildContext context,
    required Map<String, dynamic> userInfo,
    required Function(Map<String, dynamic>) onSave,
  }) async {
    print(userInfo);
    print("ff ----------------------------------------------------");
    // إعداد المتحكمات
    final TextEditingController nameController = TextEditingController(text: userInfo['name']);
    final TextEditingController phoneController = TextEditingController(text: userInfo['phone']);
    final TextEditingController addressController = TextEditingController(text: userInfo['address']);
    String role = userInfo['role'];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('معلومات المستخدم'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الاسم
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'الاسم',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // رقم الهاتف
                Text("${userInfo['phone']}"),
                const SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'الموقع',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                print("************************");
                try {
                  await FirebaseFirestore.instance.collection('users').doc(widget.projectUserId).update({
                    'name': nameController.text,
                    'address': addressController.text,
                    //'updated_at': FieldValue.serverTimestamp(),
                  });
                  print("************************");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم حفظ البيانات بنجاح!')),
                  );

                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('حدث خطأ: ${e.toString()}')),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }


}
