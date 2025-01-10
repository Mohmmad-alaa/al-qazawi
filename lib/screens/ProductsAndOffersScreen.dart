import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductsAndOffersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {'name': 'منتج 1', 'price': 1500.0, 'image': 'https://via.placeholder.com/150'},
    {'name': 'منتج 2', 'price': 750.0, 'image': 'https://via.placeholder.com/150'},
    {'name': 'منتج 3', 'price': 1000.0, 'image': 'https://via.placeholder.com/150'},
    {'name': 'منتج 4', 'price': 1200.0, 'image': 'https://via.placeholder.com/150'},
    {'name': 'منتج 5', 'price': 2000.0, 'image': 'https://via.placeholder.com/150'},
  ];

  final List<String> offers = [
    'https://via.placeholder.com/400x200?text=عرض+1',
    'https://via.placeholder.com/400x200?text=عرض+2',
    'https://via.placeholder.com/400x200?text=عرض+3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المنتجات والعروض'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العروض
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                    margin: EdgeInsets.symmetric(horizontal: 8),
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
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
          ),
          SizedBox(height: 16),

          // المنتجات
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'المنتجات',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
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
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${product['price']} شيكل',
                              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text('التفاصيل'),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(80, 36),
                                  ),
                                ),
                              ],
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
      ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            if (index == 1) {
              // الانتقال إلى صفحة "إضافة"
              null;
            } else if (index == 0) {
              // الانتقال إلى صفحة "الرئيسية"

              Navigator.pop(
                context);

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
        )
    );
  }
}
