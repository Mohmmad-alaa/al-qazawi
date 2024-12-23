import 'dart:async';

import 'package:flutter/material.dart';

import '../services/firebase_service.dart';
import 'add_project.dart';
import 'dashboard.dart';
import 'information_cart.dart';

class ProjectsScreen extends StatefulWidget {
  String userId;
  String role;

  ProjectsScreen(this.userId, this.role);

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState(userId, role);
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> projects = [];

  void fetchProjects() async {
    try {
      final fetchedProjects = await _firebaseService.fetchProjects();
      setState(() {
        projects = fetchedProjects;
        print(projects);
        print("------------------------------------------");
      });
    } catch (e) {
      print('Error: $e');
      // يمكنك إضافة إشعار أو رسالة خطأ للمستخدم هنا
    }
  }

  final PageController _pageController = PageController();
  int _currentPage = 0;
  String images = 'assets/images/CH.jpg';

  @override
  void initState() {
    super.initState();

    fetchProjects();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String selectedType = 'عادي'; // القيمة الافتراضية
  int selectedYear = DateTime.now().year; // السنة المختارة تبدأ بالسنة الحالية
  TextEditingController searchController =
      TextEditingController(); // وحدة التحكم للبحث
  String? selectedCategory; // الفئة المختارة

  List<Map<String, String>> categories = [
    {'name': 'عادي'},
    {'name': 'VRF'},
  ];

  String userId;
  String role;

  _ProjectsScreenState(this.userId, this.role);

  void goToProjects(String category) {
    setState(() {
      selectedCategory = category;
      selectedType = category; // تغيير النوع بناءً على الفئة
    });
  }

  void changeYear(bool isNext) {
    setState(() {
      selectedYear += isNext ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(selectedCategory == null ? '' : 'مشاريع $selectedCategory'),
        leading: selectedCategory != null
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedCategory =
                        null; // إعادة الفئة إلى null للعودة إلى القائمة
                  });
                },
              )
            : null,
      ),
      body: selectedCategory == null
          ? _buildCategoryList()
          : _buildProjectsList(),
      bottomNavigationBar: role == 'admin'
          ? BottomNavigationBar(
              onTap: (index) {
                if (index == 0) {
                  // الانتقال إلى صفحة "إضافة"
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddProjectScreen(
                            userId, role)), // استبدل AddPage بصفحتك
                  );
                } else if (index == 1) {
                  // الانتقال إلى صفحة "الرئيسية"
                  setState(() {
                    selectedCategory = null;
                  });
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.add, size: 20),
                  label: 'إضافة',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, size: 20),
                  label: 'الرئيسية',
                ),
              ],
              selectedFontSize: 12,
              unselectedFontSize: 12,
            )
          : null,
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

  Widget _buildProjectsList() {
    // تصفية المشاريع بناءً على الفئة والسنة
    //List<Map<String, dynamic>> filteredProjects = projects; // عرض كل المشاريع

    List<Map<String, dynamic>> filteredProjects = projects.where((project) {
      return project['category'] == selectedType &&
          (selectedYear.toString().isEmpty ||
              project['created_at'] == selectedYear);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // قائمة السنوات
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                onPressed: () => changeYear(false), // تقليل السنة
              ),
              Text(
                '$selectedYear',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 20),
                onPressed: () => changeYear(true), // زيادة السنة
              ),
            ],
          ),
          const SizedBox(height: 8),
          // خانة البحث
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: searchController,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                labelText: 'ابحث عن مشروع...',
                labelStyle: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
                border: InputBorder.none,
                prefixIcon:
                    const Icon(Icons.search, color: Colors.blue, size: 20),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // عرض المشاريع
          Expanded(
            child: filteredProjects.isEmpty
                ? const Center(child: Text('لا توجد مشاريع لهذا الاختيار'))
                : GridView.builder(
              padding: const EdgeInsets.all(4),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: filteredProjects.length,
              itemBuilder: (context, index) {
                var project = filteredProjects[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ProjectDetailsScreen(project: project, role: role),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0); // يبدأ من الأسفل
                          const end = Offset.zero; // ينتهي في المركز
                          const curve = Curves.easeInOut; // منحنى الحركة

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100), // دائرة بالكامل
                    ),
                    child: Stack(
                      alignment: Alignment.center, // وضع المحتوى في المنتصف
                      children: [
                        // النص في منتصف الدائرة
                        Text(
                          project['project_name'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        // أيقونة التوجه
                        const Positioned(
                          bottom: 10, // مسافة من الأسفل
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.blue,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )



        ],
      ),
    );
  }
}
