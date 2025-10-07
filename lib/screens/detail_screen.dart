import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cat_breed.dart';
import '../bloc/cat_breed_bloc.dart';
import '../bloc/cat_breed_state.dart';
import '../viewmodels/detail_viewmodel.dart';

class DetailScreen extends StatelessWidget {
  final CatBreed breed;

  const DetailScreen({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    final viewModel = DetailViewModel(
      catBreedBloc: context.read<CatBreedBloc>(),
      breed: breed,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          breed.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ),
      ),
      body: BlocBuilder<CatBreedBloc, CatBreedState>(
        builder: (context, state) {
          final currentBreed = viewModel.getBreedDetail(state);

          if (viewModel.isLoading(state)) {
            return Center(
              child: const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
              ),
            );
          }

          if (viewModel.hasError(state)) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    viewModel.getErrorMessage(state) ??
                        'Error loading breed details',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => viewModel.loadBreedDetail(),
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return _buildContent(context, currentBreed ?? breed);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, CatBreed breed) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height * 0.52,
          width: double.infinity,
          color: Colors.black.withValues(alpha: 0.05),
          child:
              breed.imageUrl != null
                  ? CachedNetworkImage(
                    imageUrl: breed.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => const Center(
                          child: Icon(Icons.pets, color: Colors.grey, size: 40),
                        ),
                    errorWidget:
                        (context, url, error) => const Center(
                          child: Icon(Icons.pets, color: Colors.grey, size: 40),
                        ),
                  )
                  : const Center(
                    child: Icon(Icons.pets, color: Colors.grey, size: 40),
                  ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (breed.description != null) ...[
                  Text(
                    breed.description!,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                if (breed.origin != null) ...[
                  _buildMinimalInfo('Origin', breed.origin!),
                  const SizedBox(height: 16),
                ],

                if (breed.intelligence != null) ...[
                  _buildMinimalInfo('Intelligence', '${breed.intelligence}/5'),
                  const SizedBox(height: 16),
                ],

                if (breed.adaptability != null) ...[
                  _buildMinimalInfo('Adaptability', '${breed.adaptability}/5'),
                  const SizedBox(height: 16),
                ],

                if (breed.lifeSpan != null) ...[
                  _buildMinimalInfo('Life Span', '${breed.lifeSpan} years'),
                  const SizedBox(height: 16),
                ],

                if (breed.temperament != null) ...[
                  _buildMinimalInfo('Temperament', breed.temperament!),
                  const SizedBox(height: 16),
                ],

                if (breed.weight != null) ...[
                  if (breed.weight!.imperial != null) ...[
                    _buildMinimalInfo(
                      'Weight (Imperial)',
                      breed.weight!.imperial!,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (breed.weight!.metric != null) ...[
                    _buildMinimalInfo('Weight (Metric)', breed.weight!.metric!),
                    const SizedBox(height: 16),
                  ],
                ],

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMinimalInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
