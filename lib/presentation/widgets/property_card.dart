import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tarih ve sayı formatlama için
import '../../../data/models/property_model.dart';

class PropertyCard extends StatelessWidget {
  final PropertyModel property;
  final VoidCallback onTap;

  const PropertyCard({
    super.key,
    required this.property,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'tr_TR', symbol: '₺', decimalDigits: 0);
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias, // Resmin kenarlarını yuvarlatmak için
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Resim Alanı
            SizedBox(
              height: 180,
              width: double.infinity,
              child: (property.imageUrls != null && property.imageUrls!.isNotEmpty)
                  ? Image.network(
                      property.imageUrls!.first, // İlk resmi göster
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Icon(Icons.broken_image, size: 50, color: Colors.grey[600]),
                        );
                      },
                    )
                  : Container( // Resim yoksa placeholder
                      color: Colors.grey[300],
                      child: Icon(Icons.apartment, size: 80, color: Colors.grey[500]),
                    ),
            ),
            // Bilgi Alanı
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    property.title,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 16, color: theme.textTheme.bodySmall?.color),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.address,
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        currencyFormatter.format(property.pricePerMonth),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          if (property.averageRating != null && property.averageRating! > 0) ...[
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              property.averageRating!.toStringAsFixed(1),
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            if (property.reviewCount != null && property.reviewCount! > 0)
                              Text(
                                ' (${property.reviewCount} yorum)',
                                style: theme.textTheme.bodySmall,
                              ),
                            const SizedBox(width: 8),
                          ],
                          Icon(Icons.king_bed_outlined, size: 16, color: theme.textTheme.bodySmall?.color),
                          const SizedBox(width: 2),
                          Text('${property.bedrooms}', style: theme.textTheme.bodySmall),
                          const SizedBox(width: 8),
                          Icon(Icons.bathtub_outlined, size: 16, color: theme.textTheme.bodySmall?.color),
                          const SizedBox(width: 2),
                          Text('${property.bathrooms}', style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}