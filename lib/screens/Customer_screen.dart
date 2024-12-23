import 'package:alqhazawi/widgets/DetailIcon.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/firebase_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/Progress.dart';
import 'ProductsAndOffersScreen.dart';

class MultiStepCategoryScreenn extends StatefulWidget {
  String userId;
  String role;

  MultiStepCategoryScreenn(this.userId, this.role);

  @override
  _MultiStepCategoryScreenState createState() =>
      _MultiStepCategoryScreenState(userId);
}

class _MultiStepCategoryScreenState extends State<MultiStepCategoryScreenn> {
  final _firebaseService = FirebaseService();
  int currentStep = 0;
  String selectedCategory = '';
  Map<String, dynamic> selectedProject = {};
  String images = 'assets/images/CH.jpg';

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'VRF',
      'icon': Icons.ac_unit,
      'projects': [
        {
          'name': 'مشروع VRF 1',
          'startDate': '2024-01-01',
          'completionSteps': [
            'مرحلة التصميم',
            'مرحلة التركيب',
            'اختبار الأنظمة',
            'التسليم النهائي',
          ],
          'images': [
            'https://via.placeholder.com/200',
            'https://via.placeholder.com/200'
          ],
          'contract': 'اتفاقية VRF 1',
          'payments': ['دفعة أولى', 'دفعة نهائية'],
          'templates': 'نماذج VRF 1',
          'whatsapp': '05689223344',
          'warranty': 'كفالة VRF 1 لمدة سنتين',
          'model': 'Samsung AR12TSHZAWK',
        },
        {
          'name': 'مشروع VRF 1',
          'startDate': '2024-01-01',
          'completionSteps': [
            'مرحلة التصميم',
            'مرحلة التركيب',
            'اختبار الأنظمة',
            'التسليم النهائي',
          ],
          'images': [
            'https://via.placeholder.com/200',
            'https://via.placeholder.com/200'
          ],
          'contract': 'اتفاقية VRF 1',
          'payments': ['دفعة أولى', 'دفعة نهائية'],
          'templates': 'نماذج VRF 1',
          'whatsapp': '05689223344',
          'warranty': 'كفالة VRF 1 لمدة سنتين',
          'model': 'Samsung AR12TSHZAWK',
        },
        {
          'name': 'مشروع VRF 1',
          'startDate': '2024-01-01',
          'completionSteps': [
            'مرحلة التصميم',
            'مرحلة التركيب',
            'اختبار الأنظمة',
            'التسليم النهائي',
          ],
          'images': [
            'https://via.placeholder.com/200',
            'https://via.placeholder.com/200'
          ],
          'contract': 'اتفاقية VRF 1',
          'payments': ['دفعة أولى', 'دفعة نهائية'],
          'templates': 'نماذج VRF 1',
          'whatsapp': '05689223344',
          'warranty': 'كفالة VRF 1 لمدة سنتين',
          'model': 'Samsung AR12TSHZAWK',
        },
        {
          'name': 'مشروع VRF 1',
          'startDate': '2024-01-01',
          'completionSteps': [
            'مرحلة التصميم',
            'مرحلة التركيب',
            'اختبار الأنظمة',
            'التسليم النهائي',
          ],
          'images': [
            'https://via.placeholder.com/200',
            'https://via.placeholder.com/200'
          ],
          'contract': 'اتفاقية VRF 1',
          'payments': ['دفعة أولى', 'دفعة نهائية'],
          'templates': 'نماذج VRF 1',
          'whatsapp': '05689223344',
          'warranty': 'كفالة VRF 1 لمدة سنتين',
          'model': 'Samsung AR12TSHZAWK',
        },
      ],
    },
    {
      'name': 'عادي',
      'icon': Icons.air,
      'projects': [
        {
          'name': 'مشروع عادي 1',
          'startDate': '2024-03-01',
          'features': 'ميزات المكيف: تشغيل صامت، كفاءة عالية.',
          'filterCleaning': 'https://youtu.be/example-cleaning',
          'remoteUsage': 'https://youtu.be/example-remote',
          'warranty': 'كفالة لمدة عام.',
          'model': 'Samsung AR12TSHZAWK',
          'contract': 'اتفاقية عادي 1',
          'payments': ['100', '200'],
        },
        {
          'name': 'مشروع عادي 1',
          'startDate': '2024-03-01',
          'features': 'ميزات المكيف: تشغيل صامت، كفاءة عالية.',
          'filterCleaning': 'https://youtu.be/example-cleaning',
          'remoteUsage': 'https://youtu.be/example-remote',
          'warranty': 'كفالة لمدة عام.',
          'model': 'Samsung AR12TSHZAWK',
          'contract': 'اتفاقية عادي 1',
          'payments': ['100', '200'],
        },
        {
          'name': 'مشروع عادي 1',
          'startDate': '2024-03-01',
          'features': 'ميزات المكيف: تشغيل صامت، كفاءة عالية.',
          'filterCleaning': 'https://youtu.be/example-cleaning',
          'remoteUsage': 'https://youtu.be/example-remote',
          'warranty': 'كفالة لمدة عام.',
          'model': 'Samsung AR12TSHZAWK',
          'contract': 'اتفاقية عادي 1',
          'payments': ['100', '200'],
        },
        {
          'name': 'مشروع عادي 1',
          'startDate': '2024-03-01',
          'features': 'ميزات المكيف: تشغيل صامت، كفاءة عالية.',
          'filterCleaning': 'https://youtu.be/example-cleaning',
          'remoteUsage': 'https://youtu.be/example-remote',
          'warranty': 'كفالة لمدة عام.',
          'model': 'Samsung AR12TSHZAWK',
          'contract': 'اتفاقية عادي 1',
          'payments': ['100', '200'],
        },
      ],
    },
  ];
  String id;

  _MultiStepCategoryScreenState(this.id);

  void goToProjects(String category) {
    setState(() {
      currentStep = 1;
      selectedCategory = category;
    });
  }

  void goToProjectDetails(Map<String, dynamic> project) {
    setState(() {
      currentStep = 2;
      selectedProject = project;
    });
  }

  void goBack() {
    setState(() {
      if (currentStep > 0) {
        currentStep--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
          appBar: AppBar(
            leading: currentStep > 0
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: goBack,
                  )
                : null,
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: currentStep == 0
                ? _buildCategoryList()
                : currentStep == 1
                    ? _buildProjectList()
                    : _buildProjectDetails(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              if (index == 0) {
                // الانتقال إلى صفحة "إضافة"
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProductsAndOffersScreen()), // استبدل `AddPage` بصفحتك
                );
              } else if (index == 1) {
                // الانتقال إلى صفحة "الرئيسية"

                setState(() {
                  currentStep = 0;
                });
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.local_offer, size: 20),
                label: 'العروضات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 20),
                label: 'الرئيسية',
              ),
            ],
            selectedFontSize: 12,
            unselectedFontSize: 12,
          )),
    );
  }

  Widget _buildCategoryList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
              image: DecorationImage(
                image: AssetImage(images),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        // الجزء الخاص بالصورة الكبيرة في الأعلى

        const SizedBox(height: 150),
        // الجزء الخاص بالقائمة
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 3 / 4, // نسبة العرض إلى الارتفاع
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () => goToProjects(category['name']!),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  elevation: 0,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3, // تخصيص 3 أجزاء من الارتفاع للصورة
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            image: DecorationImage(
                              image: category['name']! == 'VRF'
                                  ? AssetImage('assets/images/CH.jpg')
                                  : AssetImage('assets/images/normal.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1, // تخصيص جزء واحد من الارتفاع للنص
                        child: Center(
                          child: Text(
                            category['name']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProjectList() {
    final category =
    categories.firstWhere((cat) => cat['name'] == selectedCategory);
    final projects = category['projects'];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return StatefulBuilder(
          builder: (context, setState) {
            bool isPressed = false;

            return GestureDetector(
              onTapDown: (_) => setState(() => isPressed = true),
              onTapUp: (_) {
                setState(() => isPressed = false);
                goToProjectDetails(project);
              },
              onTapCancel: () => setState(() => isPressed = false),
              child: AnimatedScale(
                scale: isPressed ? 0.95 : 1.0, // تصغير عند الضغط
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Card(
                  shape: const CircleBorder(), // شكل دائري بالكامل
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          project['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'تاريخ البدء: ${project['startDate']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


  //final String phoneNumber = '+972568683466'; // رقم الهاتف مع رمز البلد إذا لزم الأمر

  Future<void> _openWhatsApp() async {
    try {
      if (await canLaunchUrl(Uri.parse("https://wa.me/+972568683466"))) {
        await launchUrl(Uri.parse("https://wa.me/+972568683466"),
            mode: LaunchMode.externalApplication);
      } else {
        // Inform the user that WhatsApp cannot be launched
        print(
            "Cannot launch WhatsApp. Suggest alternative methods or display an error message.");
      }
    } catch (e) {
      // Handle other potential exceptions during launching
      print("Error launching URL: $e");
    }
  }

  Widget _buildProjectDetails() {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      children: [
        _buildDetailIcon(
          icon: FontAwesomeIcons.whatsapp,
          label: 'واتساب',
          onTap: () => _openWhatsApp(),
        ),


        if (selectedCategory == 'VRF') ...[
          DetailIcon(
            icon: Icons.info, // الأيقونة التي تريدها
            label: 'معلومات الزبون', // النص الذي تريد عرضه
            onTap: () => _showDetailsDialog(
              'معلومات الزبون',
              selectedProject['model'] ?? 'لا يوجد معلومات متوفرة',
            ),
          ),
          ProgressIcon(
            icon: Icons.check_circle,
            label: "إنجاز المشروع",
            onTap: () => _showDetailsDialog(
              'خطوات المشروع',
              (selectedProject['completionSteps'] as List<dynamic>?)
                      ?.join('\n') ??
                  'لا توجد خطوات متوفرة',
            ),
            progress: 0.5, // نسبة الإنجاز
          ),
          DetailIcon(
            icon: Icons.info, // الأيقونة التي تريدها
            label: 'موديلات الوحدات المطلوبة', // النص الذي تريد عرضه
            onTap: () => _showDetailsDialog(
              'موديلات الوحدات المطلوبة',
              selectedProject['model'] ?? 'لا يوجد معلومات متوفرة',
            ),
          ),
          DetailIcon(
            icon: Icons.info, // الأيقونة التي تريدها
            label: 'المعدات اللازمة', // النص الذي تريد عرضه
            onTap: () => _showDetailsDialog(
              'المعدات اللازمة',
              selectedProject['model'] ?? 'لا يوجد معلومات متوفرة',
            ),
          ),
          _buildDetailIcon(
            icon: Icons.image,
            label: 'الصور',
            onTap: () => _showImagesDialog(selectedProject['images'] ?? []),
          ),
          _buildDetailIcon(
            icon: Icons.insert_drive_file,
            label: 'ملفات',
            onTap: () => _showDetailsDialog(
              'ملفات',
              selectedProject['templates'] ?? 'لا توجد ملفات متوفرة',
            ),
          ),
        ] else if (selectedCategory == 'عادي') ...[
          _buildDetailIcon(
            icon: Icons.verified,
            label: 'الكفالة',
            onTap: () => _showDetailsDialog(
              'الكفالة',
              selectedProject['warranty'] ?? 'لا توجد كفالة متوفرة',
            ),
          ),
          DetailIcon(
            icon: Icons.info, // الأيقونة التي تريدها
            label: 'موديل المكيف', // النص الذي تريد عرضه
            onTap: () => _showDetailsDialog(
              'موديل المكيف',
              selectedProject['model'] ?? 'لا يوجد موديل متوفر',
            ),
          ),
          _buildDetailIcon(
            icon: FontAwesomeIcons.microchip,
            label: 'ميزات المكيف',
            onTap: () => _showDetailsDialog(
              'ميزات المكيف',
              selectedProject['features'] ?? 'لا توجد ميزات متوفرة',
            ),
          ),
          _buildDetailIcon(
            icon: FontAwesomeIcons.brush,
            label: 'تنظيف الفلتر',
            onTap: () => _showDetailsDialog(
              'تنظيف الفلتر',
              selectedProject['filterCleaning'] ??
                  'لا توجد معلومات تنظيف الفلتر',
            ),
          ),
          _buildDetailIcon(
            icon: Icons.settings_remote,
            label: 'استخدام الريموت',
            onTap: () => _showDetailsDialog(
              'استخدام عن بعد',
              selectedProject['remoteUsage'] ??
                  'لا توجد معلومات استخدام عن بعد',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailIcon(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _showDetailsDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
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

  void _showImagesDialog(List<String> images) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('الصور', textAlign: TextAlign.center),
          content: images.isNotEmpty
              ? ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Image.network(
                          images[index],
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text('خطأ في تحميل الصورة'),
                            );
                          },
                        ),
                      );
                    },
                  ),
                )
              : const Center(child: Text('لا توجد صور متاحة')),
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
}
