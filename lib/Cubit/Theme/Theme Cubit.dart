
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Theme States.dart';

class ThemeCubit extends Cubit<AppStates>
{
  ThemeCubit():super(AppInitialState());
  static ThemeCubit get(context) => BlocProvider.of(context);
  bool themebool = false;
  void changeThemeMode()
  {
    themebool = !themebool;
      emit(ChangeThemeModeStateChange());
  }
}