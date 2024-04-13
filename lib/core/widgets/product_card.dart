import 'package:flutter/material.dart';

import '../../models/product/product_model.dart';
import '../../views/product/view/product_view.dart';
import 'rating_view.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductView(product: product)),
        )
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: product.image != null 
                ? Image.network(
                  product.image!,
                  alignment: Alignment.topCenter, 
                  fit: BoxFit.cover
                )
                : const Placeholder(),
            ),
            const SizedBox(height: 8),
            SizedBox(
              child: Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ),
            Text("\$${product.price.toStringAsFixed(2)}",
              maxLines: 1,
              overflow: TextOverflow.clip,
              softWrap: false,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Theme.of(context).primaryColor,
              ),
            ),
            RatingView(
              value: product.ratingRate ?? 0,
              reviewsCount: product.ratingCount ?? 0
            ),
          ]
        ),
      ),
    );
  }
}