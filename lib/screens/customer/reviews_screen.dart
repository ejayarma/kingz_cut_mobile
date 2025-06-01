import 'package:flutter/material.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  String _selectedRatingType = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Reviews'),
        actions: [
          TextButton.icon(
            icon: Icon(
              Icons.add_circle_rounded,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: _showReviewBottomSheet,
            label: Text(
              'Add Review',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildRatingChip('All'),
                  const SizedBox(width: 8),
                  _buildRatingChip('5'),
                  const SizedBox(width: 8),
                  _buildRatingChip('4'),
                  const SizedBox(width: 8),
                  _buildRatingChip('3'),
                  const SizedBox(width: 8),
                  _buildRatingChip('2'),
                  const SizedBox(width: 8),
                  _buildRatingChip('1'),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildReviewCard(5),
                _buildReviewCard(3),
                _buildReviewCard(1),
                _buildReviewCard(5),
                _buildReviewCard(5),
                _buildReviewCard(5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Navigate to next screen with selected stylist
  void _showReviewBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16).copyWith(top: 0),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(
                          'assets/images/stylists/john_will.png',
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'John Will',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),
                    Text(
                      "Kindly give your review after your experience with this hair stylist",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star_border,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: "Enter your detailed reviews here.",
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 56,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: Text("Submit Review"),
                      ),
                    ),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close_rounded),
                ),
              ),
            ],
          ),
        );
      },
    );
    // print('Selected stylist: ${stylist['name']}');
  }

  Widget _buildRatingChip(String rating) {
    return FilterChip(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 0,
        ),
      ),
      selectedColor: Theme.of(context).colorScheme.primary,
      labelPadding: EdgeInsets.zero,
      checkmarkColor:
          _selectedRatingType == rating
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
      label: Row(
        children: [
          Text(
            "$rating ★",
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color:
                  _selectedRatingType == rating
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      selected: _selectedRatingType == rating,
      onSelected: (_) {
        setState(() {
          _selectedRatingType = rating;
        });
      },
      backgroundColor: Theme.of(context).colorScheme.surface,
      side: BorderSide(
        color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
      ),
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
    );
  }

  Widget _buildReviewCard(int rating) {
    String reviewText =
        rating == 5
            ? "Service was good. He's really good."
            : rating == 3
            ? "Service was okay"
            : "He was rude to me. Poor service.";

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: const AssetImage(
                    'assets/images/stylists/john_will.png',
                  ),
                  radius: 24,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'John Will',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '32 minutes ago',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        reviewText,
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
