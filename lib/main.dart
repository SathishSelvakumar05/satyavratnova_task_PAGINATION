
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/feed_cubit.dart';
import 'repository/product_repository.dart';
import 'screens/feed_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Feed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        cardTheme: const CardThemeData(
          elevation: 2,
          shadowColor: Colors.black12,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF6C63FF),
          ),
        ),
        fontFamily: 'Roboto',
      ),
      home: RepositoryProvider(
        create: (_) => ProductRepository(),
        child: BlocProvider(
          create: (ctx) => FeedCubit(
            repository: ctx.read<ProductRepository>(),
          ),
          child: const FeedScreen(),
        ),
      ),
    );
  }
}
