import '../bloc/cat_breed_bloc.dart';
import '../bloc/cat_breed_event.dart';
import '../bloc/cat_breed_state.dart';
import '../models/cat_breed.dart';

class DetailViewModel {
  final CatBreedBloc catBreedBloc;
  final CatBreed breed;

  DetailViewModel({required this.catBreedBloc, required this.breed});

  CatBreed? getBreedDetail(CatBreedState state) {
    if (state is CatBreedDetailLoaded) {
      return state.breed;
    }
    return breed;
  }

  bool isLoading(CatBreedState state) {
    return state is CatBreedLoading;
  }

  bool hasError(CatBreedState state) {
    return state is CatBreedDetailError;
  }

  String? getErrorMessage(CatBreedState state) {
    if (state is CatBreedDetailError) {
      return state.message;
    }
    return null;
  }

  void loadBreedDetail() {
    catBreedBloc.add(LoadCatBreedById(breed.id));
  }

  void openLink(String title, String url) {}
}
