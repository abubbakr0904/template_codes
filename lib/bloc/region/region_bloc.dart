import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_codes/bloc/region/region_event.dart';
import 'package:template_codes/bloc/region/region_state.dart';
import 'package:template_codes/data/local/places_data.dart';
import '../../data/model/forms_status/forms_satatus.dart';
import '../../data/model/region_model.dart';
import '../../data/network_responce/network_responce.dart';

class RegionBloc extends Bloc<RegionEvent, RegionState> {
  RegionBloc(this._placesDatabase)
      : super(
    const RegionState(
      formsStatus: FormsStatus.pure,
      errorText: '',
      statusMessage: '',
      currentRegions: [],
      regions: [],
    ),
  ) {
    on<RegionCallEvent>(_regionCallEvent);
    on<SearchRegionCallEvent>(_searchRegionCallEvent);
  }

  final PlacesDatabase _placesDatabase;

  void _searchRegionCallEvent(SearchRegionCallEvent event, emit) {
    if (event.searchTitle.isNotEmpty) {
      emit(
        state.copyWith(
            currentRegions: state.regions.where((element) {
              try {
                return element.name
                    .substring(0, event.searchTitle.length)
                    .toLowerCase() ==
                    event.searchTitle.toLowerCase();
              } catch (_) {
                return false;
              }
            }).toList()),
      );
    } else {
      emit(state.copyWith(currentRegions: state.regions));
    }
  }

  Future<void> _regionCallEvent(RegionCallEvent event, emit) async {
    emit(state.copyWith(formsStatus: FormsStatus.loading));
    NetworkResponse networkResponse = NetworkResponse();
    List<RegionModel> regions;

    networkResponse = await _placesDatabase.getAllDistricts();
    if (networkResponse.errorText.isEmpty) {
      regions = networkResponse.data;
      networkResponse = await _placesDatabase.getAllQuarters();

      if (networkResponse.errorText.isEmpty) {
        regions.addAll(networkResponse.data);
        networkResponse = await _placesDatabase.getAllRegions();

        if (networkResponse.errorText.isEmpty) {
          regions.addAll(networkResponse.data);
          emit(
            state.copyWith(
              formsStatus: FormsStatus.success,
              currentRegions: regions,
              regions: regions,
            ),
          );
        } else {
          _error(networkResponse.errorText, emit);
        }
      } else {
        _error(networkResponse.errorText, emit);
      }
    } else {
      _error(networkResponse.errorText, emit);
    }
  }

  _error(String errorTitle, emit) {
    emit(
      state.copyWith(
        formsStatus: FormsStatus.error,
        errorText: errorTitle,
      ),
    );
  }
}