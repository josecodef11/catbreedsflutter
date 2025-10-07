import '../bloc/cat_breed_bloc.dart';
import '../bloc/cat_breed_event.dart';

class SplashViewModel {
  final CatBreedBloc catBreedBloc;

  SplashViewModel({required this.catBreedBloc});

  void initialize() {
    catBreedBloc.add(const LoadCatBreeds());
  }
}
