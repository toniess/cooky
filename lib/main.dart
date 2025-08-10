import 'package:cooky/core/services/meal_db_service.dart';
import 'package:cooky/core/utils/dio.dart';
import 'package:cooky/features/recipes_home/bloc/recipes/recipes_bloc.dart';
import 'package:cooky/router/router.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'theme/themes.dart';

final talker = TalkerFlutter.init();
final getIt = GetIt.instance;

void _registerServices() {
  getIt.registerLazySingleton<Dio>(() => DioRegistrant.register(talker));
  getIt.registerLazySingleton<MealDbService>(
    () => MealDbService(dio: getIt.get<Dio>()),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  _registerServices();
  Bloc.observer = TalkerBlocObserver(talker: talker);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => RecipesBloc())],
      child: MaterialApp.router(
        routerConfig: router,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
      ),
    );
  }
}
