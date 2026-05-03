import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/shop/data/models/product_detail_model.dart';
import 'package:frontend/features/shop/presentation/widgets/product_image_carousel.dart';

void main() {
  testWidgets('ProductImageCarousel shows placeholder when images empty', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProductImageCarousel(images: []),
        ),
      ),
    );

    expect(find.byIcon(Icons.image_outlined), findsOneWidget);
  });

  testWidgets('ProductImageCarousel builds with one network image', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProductImageCarousel(
            images: [
              ProductImageModel(id: 1, imageUrl: 'https://example.com/one.jpg', isPrimary: true),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(PageView), findsOneWidget);
  });
}
