import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/quote_model.dart';
import '../utils/theme.dart';

class QuoteCard extends StatelessWidget {
  final QuoteModel quote;
  final VoidCallback onFavorite;
  final bool isFavorite;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.onFavorite,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.warmBrown.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: AppTheme.softYellow.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quote text
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.format_quote,
                    color: AppTheme.softYellow.withOpacity(0.6),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      quote.text,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.mutedText,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Author and actions row
              Row(
                children: [
                  // Author
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: AppTheme.mutedText.withOpacity(0.6),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          quote.author,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.mutedText.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Action buttons
                  Row(
                    children: [
                      // Copy button
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: '${quote.text} - ${quote.author}'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Quote copied to clipboard! ✨'),
                              backgroundColor: AppTheme.sageGreen,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.copy_outlined,
                          color: AppTheme.softBlue,
                          size: 20,
                        ),
                        tooltip: 'Copy quote',
                      ),
                      
                      // Favorite button
                      IconButton(
                        onPressed: onFavorite,
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? AppTheme.gentlePink : AppTheme.mutedText.withOpacity(0.6),
                          size: 20,
                        ),
                        tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
                      ),
                    ],
                  ),
                ],
              ),
              
              // Category tag (if available)
              if (quote.category != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.sageGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.sageGreen.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    quote.category!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.sageGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0));
  }
}
