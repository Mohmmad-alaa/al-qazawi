import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class ProductsAndOffersByCategoryScreen extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> categories = {
    'ثلاجات تجارية': [
      {'name': 'ثلاجة 1', 'price': 1500.0, 'image': 'https://via.placeholder.com/150'},
      {'name': 'ثلاجة 2', 'price': 2000.0, 'image': 'https://via.placeholder.com/150'},
    ],
    'مكيفات عادية': [
      {'name': 'مكيف 1', 'price': 3000.0, 'image': 'https://via.placeholder.com/150'},
      {'name': 'مكيف 2', 'price': 2500.0, 'image': 'https://via.placeholder.com/150'},
    ],
    'مكيفات VRF': [
      {'name': 'مكيف VRF 1', 'price': 5000.0, 'image': 'https://via.placeholder.com/150'},
      {'name': 'مكيف VRF 2', 'price': 6000.0, 'image': 'https://via.placeholder.com/150'},
    ],
    'فلاتر': [
      {'name': 'فلتر 1', 'price': 400.0, 'image': 'https://via.placeholder.com/150'},
      {'name': 'فلتر 2', 'price': 600.0, 'image': 'https://via.placeholder.com/150'},
    ],
  };

  final List<String> offers = [
    'https://via.placeholder.com/400x200?text=عرض+1',
    'https://via.placeholder.com/400x200?text=عرض+2',
    'https://via.placeholder.com/400x200?text=عرض+3',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.keys.length, // عدد الفئات
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المنتجات والعروض'),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            tabs: categories.keys.map((category) => Tab(text: category)).toList(),
          ),
        ),
        body: TabBarView(
          children: categories.keys.map((category) {
            final products = categories[category]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العروض
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'العروض المميزة',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                CarouselSlider(
                  items: offers.map((offer) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(offer),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                ),
                const SizedBox(height: 16),

                // المنتجات
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'المنتجات',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                child: Image.network(
                                  product['image'],
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${product['price']} شيكل',
                                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(80, 36),
                                    ),
                                    child: const Text('التفاصيل'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            if (index == 1) {
              // الانتقال إلى صفحة "إضافة"
              Null;
            } else if (index == 0) {
              // الانتقال إلى صفحة "الرئيسية"

              Navigator.pop(context);
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 20),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer, size: 20),
              label: 'العروضات',
            ),
          ],
          selectedFontSize: 12,
          unselectedFontSize: 12,
        ),
      ),
    );
  }
}

