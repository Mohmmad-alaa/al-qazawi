import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddProjectScreen extends StatefulWidget {
  String userId;
  String role;

  AddProjectScreen(this.userId, this.role);

  @override
  _AddProjectScreenState createState() => _AddProjectScreenState(userId, role);
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  String? selectedCategory;

  String? selectedCustomerUserId; // لتخزين userId الخاص بالعميل
  String? selectedCustomerPhone;


  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  /*List<Map<String, String>> categories = [
    {'name': 'عادي'},
    {'name': 'VRF'},
  ];*/
  final List<String> categories = ['عادي', 'VRF'];
  String userId;
  String role;

  _AddProjectScreenState(this.userId, this.role);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('إضافة مشروع'),
        centerTitle: true,
      ),
      body: selectedCategory == null
          ? _buildCategoryList() // عرض قائمة الفئات
          : _buildDataEntryForm(), // عرض نموذج البيانات
    );
  }

  Widget _buildCategoryList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // الجزء الخاص بالصورة
        Container(
          margin: const EdgeInsets.all(16), // لإضافة مسافة حول الصورة
          height: MediaQuery.of(context).size.height *
              0.25, // ارتفاع ديناميكي 25% من الشاشة
          width: MediaQuery.of(context).size.width, // عرض الشاشة بالكامل
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), // لتنعيم الزوايا
            image: const DecorationImage(
              image: AssetImage('assets/images/CH.jpg'), // مسار الصورة
              fit: BoxFit.contain, // تغطية كامل الإطار
            ),
          ),
        ),
        const SizedBox(height: 150),
        // الجزء الخاص بالقائمة
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = category; // حفظ الفئة المختارة
                  });
                },
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
                              image: category == 'VRF'
                                  ? AssetImage('assets/images/CH.jpg')
                                  : AssetImage('assets/images/normal.jpg'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1, // تخصيص جزء واحد من الارتفاع للنص
                        child: Center(
                          child: Text(
                            category,
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

  Widget _buildDataEntryForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إضافة مشروع (${selectedCategory!})',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          if (selectedCategory == 'عادي') ...[
            _buildTextField('اسم المشروع', _projectNameController, Icons.assignment),
            //_buildTextField('أرقام التواصل', _contactNumberController, Icons.phone),
            _buildCustomerSelector(),
          //  _buildTextField('السنة', _dateController, Icons.date_range),
          ] else if (selectedCategory == 'VRF') ...[
            _buildTextField('اسم المشروع', _projectNameController, Icons.assignment),
           // _buildTextField('أرقام التواصل', _contactNumberController, Icons.phone),
            _buildCustomerSelector(),
         //   _buildTextField('السنة', _dateController, Icons.date_range),
           // _buildPdfUploader(),
          ],
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  selectedCategory = null;
                });
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text('تغيير الفئة',style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: _saveData,
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text('حفظ البيانات',style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: Colors.blue),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerSelector() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'اختيار العميل:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final customers = snapshot.data!.docs;

                return DropdownButton<String>(
                  isExpanded: true,
                  value: selectedCustomerPhone,
                  items: customers.map((doc) {
                    final phone = doc['phone'] as String;
                    final userId = doc.id;
                    return DropdownMenuItem<String>(
                      value: phone,
                      child: Text(phone),
                      onTap: () {
                        setState(() {
                          selectedCustomerUserId = userId; // تخزين userId المختار
                        });
                      },
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCustomerPhone = value;
                    });
                  },
                  hint: const Text('اختر رقم العميل'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveData() async {
    if (_projectNameController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('يرجى إدخال اسم المشروع')));
      return;
    }
    if (selectedCustomerPhone == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('يرجى اختيار العميل')));
      return;
    }

    try {

      // Create the map
      final projectData = {
        'infoCustomer':'',
        'userId': selectedCustomerUserId, // ربط المشروع بمعرف المستخدم
        'category': selectedCategory,
        'project_name': _projectNameController.text,
        'contact_number':_contactNumberController.text,
        'customer_phone': selectedCustomerPhone, // إضافة رقم العميل
        'created_at': DateTime.now().year,
      };

// Add conditional data
      if (selectedCategory == 'عادي') {
        projectData.addAll({
          'whatsapp': '',
          'payments': [''],
          'features': [''],
          'filterCleaning': '',
          'remoteUsage': '',
          'warranty': '',
          'model': '',
          'acSpecs': [''],
          'filters': '',
          'PriceModels': [''],
          'MaterialPrice': [''],
          'MaintenanceInstallationWorks': [''],
        });
      }
      if (selectedCategory == 'VRF') {
        projectData.addAll({
          'completion': '1',
          'images': [
            ""
          ],

          'unitModels': [''],
          'Equipment': [''],
          'contract': '',
          'payments': [''],
          'templates': '',
          'whatsapp': '',
          'warranty': '',
          'PriceModels': [''],
          'MaterialPrice':[''],
          'MaintenanceInstallationWorks':['']
        });
      }

// Add to Firestore
      await _firestore.collection('projects').add(projectData);


      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('تم حفظ البيانات بنجاح')));
      setState(() {
        selectedCategory = null;
        _projectNameController.clear();
        _startDateController.clear();
        _contactNumberController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('حدث خطأ أثناء الحفظ: $e')));
    }
  }
}
