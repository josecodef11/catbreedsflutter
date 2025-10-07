import '../bloc/cat_breed_bloc.dart';
import '../bloc/cat_breed_event.dart';
import '../bloc/cat_breed_state.dart';
import '../models/cat_breed.dart';

class HomeViewModel {
  final CatBreedBloc catBreedBloc;

  HomeViewModel({required this.catBreedBloc});

  List<CatBreed> getBreeds(CatBreedState state) {
    if (state is CatBreedLoaded) {
      return state.filteredBreeds;
    }
    return [];
  }

  bool isLoading(CatBreedState state) {
    return state is CatBreedLoading;
  }

  bool hasError(CatBreedState state) {
    return state is CatBreedError;
  }

  String? getErrorMessage(CatBreedState state) {
    if (state is CatBreedError) {
      return state.message;
    }
    return null;
  }

  String? getSearchQuery(CatBreedState state) {
    if (state is CatBreedLoaded) {
      return state.searchQuery;
    }
    return null;
  }

  void searchBreeds(String query) {
    if (query.isEmpty) {
      catBreedBloc.add(const ClearSearch());
    } else {
      catBreedBloc.add(SearchCatBreeds(query));
    }
  }

  void clearSearch() {
    catBreedBloc.add(const ClearSearch());
  }

  void refreshBreeds() {
    catBreedBloc.add(const LoadCatBreeds());
  }
}
