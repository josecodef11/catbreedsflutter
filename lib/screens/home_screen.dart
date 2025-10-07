import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import '../models/cat_breed.dart';
import '../bloc/cat_breed_bloc.dart';
import '../bloc/cat_breed_state.dart';
import '../viewmodels/home_viewmodel.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel(catBreedBloc: context.read<CatBreedBloc>());
  }

  void _filterBreeds(String query) {
    _viewModel.searchBreeds(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildNativeAppBar(),
      body: BlocBuilder<CatBreedBloc, CatBreedState>(
        builder: (context, state) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: _buildNativeSearchField(),
              ),

              Expanded(child: _buildBody(state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(CatBreedState state) {
    if (_viewModel.isLoading(state)) {
      return Center(child: _buildNativeLoadingIndicator());
    }

    if (_viewModel.hasError(state)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _viewModel.getErrorMessage(state) ?? 'Error loading breeds',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 16),
            _buildNativeRetryButton(),
          ],
        ),
      );
    }

    final breeds = _viewModel.getBreeds(state);
    final searchQuery = _viewModel.getSearchQuery(state);

    if (breeds.isEmpty) {
      return Center(
        child: Text(
          searchQuery == null || searchQuery.isEmpty
              ? 'No breed found'
              : 'No results',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w300,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: breeds.length,
      itemBuilder: (context, index) {
        final breed = breeds[index];
        return _buildBreedCard(breed);
      },
    );
  }

  Widget _buildBreedCard(CatBreed breed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailScreen(breed: breed)),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      breed.name,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Text(
                    'More...',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Center(
                child: Container(
                  width: 180,
                  height: 190,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.withValues(alpha: 0.1),
                  ),
                  child:
                      breed.imageUrl != null
                          ? ClipRRect(
                            child: CachedNetworkImage(
                              imageUrl: breed.imageUrl!,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => const Center(
                                    child: Icon(
                                      Icons.pets,
                                      color: Colors.grey,
                                      size: 50,
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) => const Center(
                                    child: Icon(
                                      Icons.pets,
                                      color: Colors.grey,
                                      size: 50,
                                    ),
                                  ),
                            ),
                          )
                          : const Center(
                            child: Icon(
                              Icons.pets,
                              color: Colors.grey,
                              size: 50,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      breed.origin ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),

                  if (breed.intelligence != null)
                    Text(
                      'Intelligence: ${breed.intelligence}/5',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildNativeAppBar() {
    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        middle: const Text(
          'Catbreeds',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: CupertinoColors.label,
            fontSize: 20,
            letterSpacing: 1.0,
          ),
        ),
        backgroundColor: CupertinoColors.systemBackground,
        border: const Border(
          bottom: BorderSide(color: CupertinoColors.separator, width: 0.5),
        ),
      );
    } else {
      return AppBar(
        title: const Text(
          'Catbreeds',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ),
      );
    }
  }

  Widget _buildNativeSearchField() {
    if (Platform.isIOS) {
      return CupertinoSearchTextField(
        controller: _searchController,
        onChanged: _filterBreeds,
        placeholder: 'Search breeds',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: CupertinoColors.label,
        ),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: const Icon(
          CupertinoIcons.search,
          color: CupertinoColors.systemGrey,
          size: 20,
        ),
      );
    } else {
      return TextField(
        controller: _searchController,
        onChanged: _filterBreeds,
        decoration: const InputDecoration(
          hintText: 'Search breeds',
          hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
          prefixIcon: Icon(Icons.search, color: Colors.black, size: 20),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
      );
    }
  }

  Widget _buildNativeLoadingIndicator() {
    if (Platform.isIOS) {
      return const CupertinoActivityIndicator(
        radius: 15,
        color: CupertinoColors.systemGrey,
      );
    } else {
      return const SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
      );
    }
  }

  Widget _buildNativeRetryButton() {
    if (Platform.isIOS) {
      return CupertinoButton(
        onPressed: () => _viewModel.refreshBreeds(),
        child: const Text(
          'Retry',
          style: TextStyle(
            color: CupertinoColors.activeBlue,
            fontWeight: FontWeight.w300,
          ),
        ),
      );
    } else {
      return TextButton(
        onPressed: () => _viewModel.refreshBreeds(),
        child: const Text(
          'Retry',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
