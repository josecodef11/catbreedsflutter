import 'package:equatable/equatable.dart';
import '../models/cat_breed.dart';

abstract class CatBreedState extends Equatable {
  const CatBreedState();

  @override
  List<Object?> get props => [];
}

class CatBreedInitial extends CatBreedState {
  const CatBreedInitial();
}

class CatBreedLoading extends CatBreedState {
  const CatBreedLoading();
}

class CatBreedLoaded extends CatBreedState {
  final List<CatBreed> breeds;
  final List<CatBreed> filteredBreeds;
  final String? searchQuery;

  const CatBreedLoaded({
    required this.breeds,
    required this.filteredBreeds,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [breeds, filteredBreeds, searchQuery];

  CatBreedLoaded copyWith({
    List<CatBreed>? breeds,
    List<CatBreed>? filteredBreeds,
    String? searchQuery,
  }) {
    return CatBreedLoaded(
      breeds: breeds ?? this.breeds,
      filteredBreeds: filteredBreeds ?? this.filteredBreeds,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class CatBreedError extends CatBreedState {
  final String message;

  const CatBreedError(this.message);

  @override
  List<Object?> get props => [message];
}

class CatBreedDetailLoaded extends CatBreedState {
  final CatBreed breed;

  const CatBreedDetailLoaded(this.breed);

  @override
  List<Object?> get props => [breed];
}

class CatBreedDetailError extends CatBreedState {
  final String message;

  const CatBreedDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
