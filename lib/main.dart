import 'package:cooky/core/services/cart/abstract_cart_service.dart';
import 'package:cooky/core/services/cart/cart_service.dart';
import 'package:cooky/core/services/favorites/favorites.dart';
import 'package:cooky/core/services/meal_db/abstract_meal_db_service.dart';
import 'package:cooky/core/services/meal_db/meal_db_service.dart';
import 'package:cooky/features/cart/bloc/bloc.dart';
import 'package:cooky/features/favorites/bloc/bloc.dart';
import 'package:cooky/features/recipes_home/bloc/recipes/recipes_bloc.dart';
import 'package:cooky/router/router.dart';
import 'package:cooky/theme/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'theme/themes.dart';

final talker = TalkerFlutter.init();
final getIt = GetIt.instance;

void _registerServices() {
  final dio = Dio();
  dio.options.connectTimeout = const Duration(seconds: 10);
  dio.options.receiveTimeout = const Duration(seconds: 5);
  dio.interceptors.add(TalkerDioLogger(talker: talker));

  getIt.registerLazySingleton<AbstractMealDbService>(() {
    return MealDbService(dio: dio);
  });

  getIt.registerLazySingleton<AbstractFavoritesService>(() {
    return FavoritesService();
  });

  getIt.registerLazySingleton<AbstractCartService>(() {
    return CartService();
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  _registerServices();

  // Инициализация Hive
  await Hive.initFlutter();

  // Инициализация сервисов
  await getIt<AbstractFavoritesService>().init();
  await getIt<AbstractCartService>().init();

  Bloc.observer = TalkerBlocObserver(talker: talker);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RecipesBloc()),
        BlocProvider(
          create: (context) => FavoritesBloc(getIt<AbstractFavoritesService>()),
        ),
        BlocProvider(
          create: (context) => CartBloc(getIt<AbstractCartService>()),
        ),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: AppColors.fieldBackground,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: MaterialApp.router(
          routerConfig: router,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
        ),
      ),
    );
  }
}
