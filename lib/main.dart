
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:satyavratnova_task2/screens/splash_screen.dart';
import 'bloc/feed_cubit.dart';
import 'repository/product_repository.dart';
import 'screens/feed_screen.dart';
void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductRepository>(
          create: (_) => ProductRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<FeedCubit>(
            create: (context) => FeedCubit(
              repository: context.read<ProductRepository>(),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BharatNova',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2B3A8C),
          brightness: Brightness.light,
        ),
        fontFamily: 'sans-serif',
        scaffoldBackgroundColor: const Color(0xFFF5F6F7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
