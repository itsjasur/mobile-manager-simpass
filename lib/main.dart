import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/auth.dart';
import 'package:mobile_manager_simpass/pages/applications.dart';
import 'package:mobile_manager_simpass/pages/download_forms.dart';
import 'package:mobile_manager_simpass/pages/form_details.dart';
import 'package:mobile_manager_simpass/pages/partner_reques_results.dart';
import 'package:mobile_manager_simpass/pages/partner_request.dart';
import 'package:mobile_manager_simpass/pages/plans.dart';
import 'package:mobile_manager_simpass/pages/home.dart';
import 'package:mobile_manager_simpass/pages/login.dart';
import 'package:mobile_manager_simpass/models/authentication.dart';
import 'package:mobile_manager_simpass/pages/profile.dart';
import 'package:mobile_manager_simpass/pages/rental_forms.dart';
import 'package:mobile_manager_simpass/pages/secondary_signup.dart';
import 'package:mobile_manager_simpass/pages/signup.dart';

import 'package:mobile_manager_simpass/theme.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        initialRoute: '/home',
        // initialRoute: '/login',
        // initialRoute: '/secondary-signup',
        // initialRoute: '/applications',
        // initialRoute: '/plans',
        // initialRoute: '/download-forms',
        // initialRoute: '/form-details',
        // initialRoute: '/partner-request',
        // initialRoute: '/partner-request-results',
        routes: {
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignupPage(),
          // '/secondary-signup': (context) => const SecondarySignup(name: 'name', phoneNumber: '01012312312', receiptId: '34523423432', certType: 'KAKAO', birthday: '19950534', employeeCode: 'asd'),

          //protected
          // '/form-details': (context) => const FormDetailsPage(planId: 4, searchText: ''),
          '/home': (context) => const AuthGuard(child: HomePage()),
          '/profile': (context) => const AuthGuard(child: ProfilePafe()),
          '/plans': (context) => const AuthGuard(child: PlansPage()),
          '/rental-forms': (context) => const AuthGuard(child: RentalFormsPage()),
          '/applications': (context) => const AuthGuard(child: ApplicationsPage()),
          '/download-forms': (context) => const AuthGuard(child: DownloadFormsPage()),

          '/partner-request': (context) => const AuthGuard(child: PartnerRequestPage()),
          '/partner-request-results': (context) => const AuthGuard(child: PartnerRequestResultsPage()),
        },
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
