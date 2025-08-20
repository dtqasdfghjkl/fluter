// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
import 'package:flutter_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter_app/init_dependencies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    // Khởi tạo service locator trước khi test
    await initDependencies(isTest: true);
  });
  testWidgets('Test default screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
          BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
          BlocProvider(create: (_) => serviceLocator<BlogBloc>()),
        ],
        child: const MyApp(),
      ),
    );

    // // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);

    expect(find.text('Sign in.'), findsOneWidget);
    // expect(find.text('Blog'), findsOneWidget);
  });
}
