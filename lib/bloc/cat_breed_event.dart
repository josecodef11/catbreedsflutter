import 'package:equatable/equatable.dart';

abstract class CatBreedEvent extends Equatable {
  const CatBreedEvent();

  @override
  List<Object?> get props => [];
}

class LoadCatBreeds extends CatBreedEvent {
  const LoadCatBreeds();
}

class SearchCatBreeds extends CatBreedEvent {
  final String query;

  const SearchCatBreeds(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearch extends CatBreedEvent {
  const ClearSearch();
}

class LoadCatBreedById extends CatBreedEvent {
  final String breedId;

  const LoadCatBreedById(this.breedId);

  @override
  List<Object?> get props => [breedId];
}
