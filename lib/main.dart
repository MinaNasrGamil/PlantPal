import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constants/enums.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/plant_repository.dart';
import 'firebase_options.dart';
import 'logic/bloc/app_bloc.dart';
import 'logic/cubit/navigation/navigation_cubit.dart';
import 'logic/cubit/plant/plant_cubit.dart';
import 'logic/cubit/reminder/reminder_cubit.dart';
import 'logic/cubit/userPost/post_cubit.dart';
import 'logic/notifications/notification_controller.dart';
import 'view/screens/add_post_screen.dart';
import 'view/screens/forget-paassword_screen.dart';
import 'view/screens/home_screen.dart';
import 'view/screens/login_screen.dart';
import 'view/screens/post_details_screen.dart';
import 'view/screens/profile_screen.dart';
import 'view/screens/register_screen.dart';
import 'view/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          locked: true,
        )
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
  bool isAllowedToSendNotifications =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotifications) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  final AuthRepository authRepository = AuthRepository();
  final PlantRepository plantRepository = PlantRepository();
  runApp(MyApp(
    authRepository: authRepository,
    plantRepository: plantRepository,
  ));
}

class MyApp extends StatefulWidget {
  final AuthRepository _authRepository;
  final PlantRepository _plantRepository;

  const MyApp(
      {Key? key,
      required AuthRepository authRepository,
      required PlantRepository plantRepository})
      : _authRepository = authRepository,
        _plantRepository = plantRepository,
        super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: widget._authRepository,
      child: RepositoryProvider.value(
        value: widget._plantRepository,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AppBloc>(
                create: (_) => AppBloc(authRepository: widget._authRepository)),
            BlocProvider<NavigationCubit>(create: (_) => NavigationCubit()),
            BlocProvider<PlantCubit>(
                create: (_) => PlantCubit(widget._plantRepository)),
            BlocProvider<ReminderCubit>(
                create: (_) => ReminderCubit(widget._plantRepository)),
            BlocProvider<PostCubit>(
              create: (_) => PostCubit(widget._plantRepository),
            )
          ],
          child: const AppView(),
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 136, 153, 59)),
        useMaterial3: true,
      ),
      onGenerateInitialRoutes: (String initialRoute) {
        return [
          MaterialPageRoute(
            builder: (context) {
              final authStatus =
                  context.select((AppBloc bloc) => bloc.state.status);
              if (authStatus == AppStatus.authenticated) {
                return const HomeScreen();
              } else {
                return LoginScreen();
              }
            },
          ),
        ];
      },
      routes: {
        '/': (context) => const SafeArea(child: HomeScreen()),
        '/signup': (context) => const RegisterScreen(),
        '/login': (context) => LoginScreen(),
        '/forgetpassword': (context) => const ForgetPaasswordScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/addpost': (context) => const AddPostScreen(),
        '/postdetails': (context) => PostDetailsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
