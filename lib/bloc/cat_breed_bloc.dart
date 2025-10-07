import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/cat_api_service.dart';
import 'cat_breed_event.dart';
import 'cat_breed_state.dart';

class CatBreedBloc extends Bloc<CatBreedEvent, CatBreedState> {
  CatBreedBloc() : super(const CatBreedInitial()) {
    on<LoadCatBreeds>(_onLoadCatBreeds);
    on<SearchCatBreeds>(_onSearchCatBreeds);
    on<ClearSearch>(_onClearSearch);
    on<LoadCatBreedById>(_onLoadCatBreedById);
  }

  Future<void> _onLoadCatBreeds(
    LoadCatBreeds event,
    Emitter<CatBreedState> emit,
  ) async {
    emit(const CatBreedLoading());

    try {
      final breeds = await CatApiService.getBreeds();
      emit(CatBreedLoaded(breeds: breeds, filteredBreeds: breeds));
    } catch (e) {
      emit(CatBreedError('Failed to load cat breeds: $e'));
    }
  }

  void _onSearchCatBreeds(SearchCatBreeds event, Emitter<CatBreedState> emit) {
    if (state is CatBreedLoaded) {
      final currentState = state as CatBreedLoaded;

      if (event.query.isEmpty) {
        emit(
          currentState.copyWith(
            filteredBreeds: currentState.breeds,
            searchQuery: null,
          ),
        );
      } else {
        final filteredBreeds =
            currentState.breeds
                .where(
                  (breed) => breed.name.toLowerCase().contains(
                    event.query.toLowerCase(),
                  ),
                )
                .toList();

        emit(
          currentState.copyWith(
            filteredBreeds: filteredBreeds,
            searchQuery: event.query,
          ),
        );
      }
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<CatBreedState> emit) {
    if (state is CatBreedLoaded) {
      final currentState = state as CatBreedLoaded;
      emit(
        currentState.copyWith(
          filteredBreeds: currentState.breeds,
          searchQuery: null,
        ),
      );
    }
  }

  Future<void> _onLoadCatBreedById(
    LoadCatBreedById event,
    Emitter<CatBreedState> emit,
  ) async {
    try {
      final breed = await CatApiService.getBreedById(event.breedId);
      if (breed != null) {
        emit(CatBreedDetailLoaded(breed));
      } else {
        emit(const CatBreedDetailError('Breed not found'));
      }
    } catch (e) {
      emit(CatBreedDetailError('Failed to load breed: $e'));
    }
  }
}
