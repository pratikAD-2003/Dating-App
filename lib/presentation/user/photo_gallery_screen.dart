import 'package:carousel_slider/carousel_slider.dart';
import 'package:dating_app/presentation/components/my_buttons.dart';
import 'package:dating_app/presentation/theme/my_colors.dart';
import 'package:flutter/material.dart';

class PhotoGalleryScreen extends StatefulWidget {
  const PhotoGalleryScreen({super.key});

  @override
  State<PhotoGalleryScreen> createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController(); // ✅ controller

  List<String> images = [
    "assets/images/m1.png",
    "assets/images/m2.jpg",
    "assets/images/m3.jpg",
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: Row(children: [MyBackButton()]),
            ),
            Expanded(
              child: Center(
                child: PhotoSliderBanner(
                  carouselController: _carouselController,
                  images: images,
                  onChange: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 120,
              child: Center(
                // ✅ centers content vertically
                child: ListView.builder(
                  itemCount: images.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ), // optional, for nice spacing
                  itemBuilder: (context, index) => Center(
                    child: PhotoGallerySmallImageCard(
                      image: images[index],
                      isSelected: index == currentIndex,
                      onClick: () {
                        setState(() {
                          currentIndex = index;
                          try {
                            _carouselController.animateToPage(
                              currentIndex,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } catch (e) {
                            debugPrint("Carousel not yet ready: $e");
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhotoGallerySmallImageCard extends StatelessWidget {
  const PhotoGallerySmallImageCard({
    super.key,
    required this.image,
    required this.isSelected,
    required this.onClick,
  });

  final String image;
  final bool isSelected;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onClick(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: isSelected ? 70 : 60,
              width: isSelected ? 70 : 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(image, fit: BoxFit.cover),
              ),
            ),

            if (!isSelected)
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: MyColors.constWhite.withOpacity(0.5),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PhotoSliderBanner extends StatefulWidget {
  final List<String> images;
  final Function(int currentIndex) onChange;
  final CarouselSliderController? carouselController;
  const PhotoSliderBanner({
    super.key,
    required this.images,
    required this.onChange,
    this.carouselController,
  });

  @override
  State<PhotoSliderBanner> createState() => _PhotoSliderBannerState();
}

class _PhotoSliderBannerState extends State<PhotoSliderBanner> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider(
          carouselController: widget.carouselController,
          items: widget.images
              .map(
                (item) => Material(
                  elevation: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(item),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.6,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
                widget.onChange(currentIndex);
              });
            },
          ),
        ),
      ],
    );
  }
}
