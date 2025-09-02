import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../providers/quote_provider.dart';
import '../utils/theme.dart';
import '../widgets/quote_card.dart';

class FavoritesQuotesScreen extends StatefulWidget {
  const FavoritesQuotesScreen({super.key});

  @override
  State<FavoritesQuotesScreen> createState() => _FavoritesQuotesScreenState();
}

class _FavoritesQuotesScreenState extends State<FavoritesQuotesScreen> {
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
    if (authProvider.user != null) {
      await quoteProvider.loadFavoriteQuotes(authProvider.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Quotes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.parchmentBackground,
              AppTheme.cardBackground,
            ],
          ),
        ),
        child: Consumer2<AuthProvider, QuoteProvider>(
          builder: (context, authProvider, quoteProvider, child) {
            if (quoteProvider.isLoadingFavorites) {
              return const Center(child: CircularProgressIndicator());
            }

            if (quoteProvider.favoriteQuotes.isEmpty) {
              return RefreshIndicator(
                onRefresh: _loadFavorites,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_border, size: 80, color: AppTheme.mutedText.withOpacity(0.5)),
                          const SizedBox(height: 16),
                          Text('No Favorite Quotes Yet',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.mutedText)),
                          const SizedBox(height: 8),
                          Text(
                            'Start adding quotes to your favorites\nfrom the Quotes tab!',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.mutedText.withOpacity(0.7)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppTheme.softYellow.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.softYellow.withOpacity(0.3)),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.lightbulb_outline, color: AppTheme.softYellow, size: 32),
                                const SizedBox(height: 12),
                                Text('How to Add Favorites',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(color: AppTheme.warmBrown, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(
                                  '1. Go to the Quotes tab\n2. Tap the heart icon on any quote\n3. Your favorites will appear here!',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.mutedText),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: const Duration(milliseconds: 500))
                              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _loadFavorites,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text('Your Favorites',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: AppTheme.warmBrown, fontWeight: FontWeight.bold)),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            AppTheme.gentlePink.withOpacity(0.1),
                            AppTheme.softYellow.withOpacity(0.1),
                          ]),
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.gentlePink.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.gentlePink.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.favorite, color: AppTheme.gentlePink, size: 24),
                          const SizedBox(width: 12),
                          Text(
                            '${quoteProvider.favoriteQuotes.length} Favorite Quote${quoteProvider.favoriteQuotes.length == 1 ? '' : 's'}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppTheme.warmBrown, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.gentlePink.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${((quoteProvider.favoriteQuotes.length / (quoteProvider.quotes.length > 0 ? quoteProvider.quotes.length : 1)) * 100).toInt()}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: AppTheme.gentlePink, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: const Duration(milliseconds: 300)).slideY(begin: 0.3, end: 0),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final quote = quoteProvider.favoriteQuotes[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: QuoteCard(
                              quote: quote,
                              onFavorite: () => quoteProvider.toggleFavorite(authProvider.user!.id, quote),
                              isFavorite: true,
                            ).animate().fadeIn(delay: Duration(milliseconds: 400 + (index * 100))).slideX(begin: 0.3, end: 0),
                          );
                        },
                        childCount: quoteProvider.favoriteQuotes.length,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
