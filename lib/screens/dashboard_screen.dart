import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../providers/habit_provider.dart';
import '../providers/quote_provider.dart';
import '../providers/connectivity_provider.dart';
import '../utils/theme.dart';
import '../models/habit_model.dart';
import '../widgets/habit_card.dart';
import '../widgets/quote_card.dart';
import '../widgets/progress_chart.dart';
import '../widgets/offline_banner.dart';
import 'profile_screen.dart';
import 'habit_form_screen.dart';
import 'favorites_quotes_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final quoteProvider = Provider.of<QuoteProvider>(context, listen: false);
    final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);

    if (authProvider.user != null) {
      await Future.wait([
        habitProvider.loadHabits(),
        quoteProvider.fetchQuotes(),
        quoteProvider.loadFavoriteQuotes(authProvider.user!.id),
        connectivityProvider.checkConnectivity(),
      ]);
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Offline Banner
          const OfflineBanner(),
          
          // Main Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                _buildHomeTab(),
                _buildHabitsTab(),
                _buildQuotesTab(),
                _buildProfileTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: AppTheme.warmBrown.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppTheme.warmBrown,
          unselectedItemColor: AppTheme.mutedText.withOpacity(0.6),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              activeIcon: Icon(Icons.check_circle),
              label: 'Habits',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.format_quote_outlined),
              activeIcon: Icon(Icons.format_quote),
              label: 'Quotes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const HabitFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  /// ========================= Home Tab =========================
  Widget _buildHomeTab() {
    return Consumer4<AuthProvider, HabitProvider, QuoteProvider, ConnectivityProvider>(
      builder: (context, authProvider, habitProvider, quoteProvider, connectivityProvider, child) {
        return RefreshIndicator(
          onRefresh: () async {
            // Show a beautiful loading animation
            await Future.delayed(const Duration(milliseconds: 800));
            await _loadData();
            
            // Show success message if online
            if (connectivityProvider.isOnline) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.refresh, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      const Text('Data refreshed successfully! ✨'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          color: AppTheme.warmBrown,
          backgroundColor: AppTheme.cardBackground,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildWelcomeHeader(authProvider),
                const SizedBox(height: 24),
                if (habitProvider.habits.isNotEmpty) _buildProgressOverview(habitProvider),
                const SizedBox(height: 24),
                _buildTodaysHabits(authProvider, habitProvider),
                const SizedBox(height: 24),
                _buildDailyQuote(authProvider, quoteProvider),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeHeader(AuthProvider authProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.sageGreen.withOpacity(0.1),
            AppTheme.softBlue.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppTheme.warmBrown,
            child: Text(
              authProvider.user?.displayName.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, ${authProvider.user?.displayName ?? 'Friend'}! 🌸',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.warmBrown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ready to continue your magical journey?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.mutedText,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 300)).slideY(begin: 0.3, end: 0);
  }

  Widget _buildProgressOverview(HabitProvider habitProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress ✨',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppTheme.warmBrown,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(delay: const Duration(milliseconds: 500)).slideX(begin: 0.3, end: 0),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
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
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildProgressStat('Total Habits', '${habitProvider.habits.length}', Icons.check_circle, AppTheme.sageGreen),
                  _buildProgressStat('Today\'s Tasks', '${habitProvider.todaysHabits.length}', Icons.today, AppTheme.softBlue),
                  _buildProgressStat('Completion Rate', '${(habitProvider.getCompletionRate() * 100).toInt()}%', Icons.trending_up, AppTheme.accentOrange),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: ProgressChart(habits: habitProvider.habits),
              ),
            ],
          ),
        ).animate().fadeIn(delay: const Duration(milliseconds: 700)).scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0)),
      ],
    );
  }

  Widget _buildProgressStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.bold)),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.mutedText), textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildTodaysHabits(AuthProvider authProvider, HabitProvider habitProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Today\'s Habits 🌟', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.warmBrown, fontWeight: FontWeight.bold))
            .animate().fadeIn(delay: const Duration(milliseconds: 900)).slideX(begin: 0.3, end: 0),
        const SizedBox(height: 16),
        if (habitProvider.todaysHabits.isEmpty)
          _buildEmptyHabits(authProvider)
        else
          ...habitProvider.todaysHabits.take(3).map((habit) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: HabitCard(
              habit: habit,
              onToggle: () => habitProvider.toggleHabitCompletion(habit.id),
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 1100)).slideX(begin: 0.3, end: 0)),
      ],
    );
  }

  Widget _buildEmptyHabits(AuthProvider authProvider) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.warmBrown.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.add_task, size: 60, color: AppTheme.mutedText.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text('No habits for today', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.mutedText)),
          const SizedBox(height: 8),
          Text('Create your first habit to get started!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.mutedText.withOpacity(0.7)), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HabitFormScreen())),
            icon: const Icon(Icons.add),
            label: const Text('Create Habit'),
          ),
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 1100)).scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0));
  }

  Widget _buildDailyQuote(AuthProvider authProvider, QuoteProvider quoteProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Daily Inspiration 🌿', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.warmBrown, fontWeight: FontWeight.bold))
            .animate().fadeIn(delay: const Duration(milliseconds: 1300)).slideX(begin: 0.3, end: 0),
        const SizedBox(height: 16),
        if (quoteProvider.quotes.isNotEmpty)
          QuoteCard(
            quote: quoteProvider.quotes.first,
            onFavorite: () => quoteProvider.toggleFavorite(authProvider.user!.id, quoteProvider.quotes.first),
            isFavorite: quoteProvider.isFavorite(quoteProvider.quotes.first.text),
          ).animate().fadeIn(delay: const Duration(milliseconds: 1500)).scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0)),
      ],
    );
  }

  /// ========================= Habits Tab =========================
  Widget _buildHabitsTab() {
    return Consumer2<AuthProvider, HabitProvider>(
      builder: (context, authProvider, habitProvider, child) {
        return RefreshIndicator(
          onRefresh: _loadData,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('My Habits', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.warmBrown, fontWeight: FontWeight.bold)),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.sageGreen.withOpacity(0.1), AppTheme.softBlue.withOpacity(0.1)],
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(icon: const Icon(Icons.filter_list), onPressed: () => _showCategoryFilter(habitProvider)),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: habitProvider.isLoading
                    ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
                    : habitProvider.habits.isEmpty
                    ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_task, size: 80, color: AppTheme.mutedText.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        Text('No habits yet', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.mutedText)),
                        const SizedBox(height: 8),
                        Text('Create your first habit to start tracking!',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.mutedText.withOpacity(0.7)), textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                )
                    : SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final habit = habitProvider.habits[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: HabitCard(
                          habit: habit,
                          onToggle: () => habitProvider.toggleHabitCompletion(habit.id),
                          showActions: true,
                          onEdit: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => HabitFormScreen(habit: habit))),
                          onDelete: () => _showDeleteDialog(habit, habitProvider, authProvider),
                        ),
                      );
                    },
                    childCount: habitProvider.habits.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ========================= Quotes Tab =========================
  Widget _buildQuotesTab() {
    return Consumer3<AuthProvider, QuoteProvider, ConnectivityProvider>(
      builder: (context, authProvider, quoteProvider, connectivityProvider, child) {
        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 700));
            await quoteProvider.fetchQuotes();
            await quoteProvider.loadFavoriteQuotes(authProvider.user!.id);
            
            if (connectivityProvider.isOnline) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.format_quote, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      const Text('New quotes loaded! 🌿'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          color: AppTheme.warmBrown,
          backgroundColor: AppTheme.cardBackground,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('Daily Quotes', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.warmBrown, fontWeight: FontWeight.bold)),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppTheme.softYellow.withOpacity(0.1), AppTheme.gentlePink.withOpacity(0.1)]),
                    ),
                  ),
                ),
                actions: [
                  IconButton(icon: const Icon(Icons.favorite), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FavoritesQuotesScreen()))),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: quoteProvider.isLoading
                    ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
                    : SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final quote = quoteProvider.quotes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: QuoteCard(
                          quote: quote,
                          onFavorite: () => quoteProvider.toggleFavorite(authProvider.user!.id, quote),
                          isFavorite: quoteProvider.isFavorite(quote.text),
                        ),
                      );
                    },
                    childCount: quoteProvider.quotes.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ========================= Profile Tab =========================
  Widget _buildProfileTab() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                ProfileScreen(user: authProvider.user!),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ========================= Helpers =========================
  void _showCategoryFilter(HabitProvider habitProvider) {
    final categories = ['All', 'Health', 'Study', 'Fitness', 'Productivity', 'Mental Health', 'Others'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.mutedText.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Filter by Category',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.warmBrown,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = habitProvider.selectedCategory == (category == 'All' ? null : category);

                  return ListTile(
                    title: Text(category),
                    leading: Icon(
                      isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: isSelected ? AppTheme.warmBrown : AppTheme.mutedText.withOpacity(0.6),
                    ),
                    onTap: () {
                      habitProvider.setSelectedCategory(category == 'All' ? null : category);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(HabitModel habit, HabitProvider habitProvider, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content: Text('Are you sure you want to delete "${habit.title}"? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              habitProvider.deleteHabit(habit.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
