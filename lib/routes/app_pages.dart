import 'package:get/get.dart';
import 'package:wealthnxai/presentation/modules/auth/page/change_password/binding/change_password_binding.dart';
import 'package:wealthnxai/presentation/modules/auth/page/change_password/page/change_password_page.dart';
import 'package:wealthnxai/presentation/modules/auth/page/forgot_password/binding/forgot_password_binding.dart';
import 'package:wealthnxai/presentation/modules/auth/page/forgot_password/page/forgot_password_page.dart';
import 'package:wealthnxai/presentation/modules/auth/page/login/binding/login_binding.dart';
import 'package:wealthnxai/presentation/modules/auth/page/login/page/login_page.dart';
import 'package:wealthnxai/presentation/modules/auth/page/otp_verification/binding/otp_verification_binding.dart';
import 'package:wealthnxai/presentation/modules/auth/page/otp_verification/page/otp_verification_page.dart';
import 'package:wealthnxai/presentation/modules/auth/page/signup/binding/signup_binding.dart';
import 'package:wealthnxai/presentation/modules/auth/page/signup/page/signup_page.dart';
import 'package:wealthnxai/presentation/modules/auth/page/social_password_setup/binding/social_password_setup_binding.dart';
import 'package:wealthnxai/presentation/modules/auth/page/social_password_setup/page/social_password_setup_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/dashboard_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/accounts/binding/account_binding.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/accounts/page/account_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/authentication/binding/authentication_binding.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/authentication/binding/email_password_authentication_binding.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/authentication/page/authentication_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/authentication/page/email_password_authentication/email_password_authentication_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/privacy_policy/privacy_policy.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/profile/binidng/user_profile_binding.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/profile/page/user_profile_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/support/binding/support_binding.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/support/page/discard_link/discord_link_community.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/drawer/page/support/page/support_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/home/page/home_screen.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/binding/transaction_binding.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/stats/page/transactions/page/trasaction_page.dart';
import 'package:wealthnxai/presentation/modules/intro/onboarding/binding/onboarding_binding.dart';
import 'package:wealthnxai/presentation/modules/intro/onboarding/page/onboarding_page.dart';
import 'package:wealthnxai/presentation/modules/intro/splash/binding/splash_binding.dart';
import 'package:wealthnxai/presentation/modules/intro/splash/page/splash_page.dart';

import '../presentation/modules/dashboard/binding/dashboard_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),

    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnBoardingPage(),
      binding: OnboardingBinding(),
    ),

    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: Routes.FORGET,
      page: () => const ForgotPasswordPage(),
      binding: ForgotPasswordBinding(),
    ),

    GetPage(
      name: Routes.SIGNUP,
      page: () => const SignupPage(),
      binding: SignupBinding(),
    ),

    GetPage(
      name: Routes.SOCIAL_PASSWORD_SETUP,
      page: () => SocialPasswordSetupPage(),
      binding: SocialPasswordSetupBinding(),
    ),

    GetPage(
      name: Routes.OTP_VERIFICATION,
      page: () => const OtpVerificationPage(),
      binding: OtpVerificationBinding(),
    ),

    GetPage(
      name: Routes.CHANGEPASSWORD,
      page: () => const ChangePasswordPage(),
      binding: ChangePasswordBinding(),
    ),

    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),

    GetPage(name: Routes.HOME, page: () => const HomePage()),

    GetPage(
      name: Routes.SUPPORT,
      page: () => SupportPage(),
      binding: SupportBinding(),
    ),

    GetPage(
      name: Routes.AUTHENTICATION,
      page: () => AuthenticationPage(),
      binding: AuthenticationBinding(),
    ),

    GetPage(
      name: Routes.EMAIL_PASSWORD_AUTH,
      page: () => const EmailAndPasswordAuthPage(),
      binding: EmailPasswordAuthenticationBinding(),
    ),

    GetPage(
      name: Routes.PROFILE,
      page: () => const UserProfilePage(),
      binding: UserProfileBinding(),
    ),

    GetPage(
      name: Routes.ACCOUNT,
      page: () => const AccountPage(),
      binding: AccountBinding(),
    ),

    GetPage(name: Routes.PRIVACY_POLICY, page: () => const PrivacyPolicy()),

    GetPage(name: Routes.COMMUNITY, page: () => const DiscordLinkCommunity()),
    GetPage(name: Routes.COMMUNITY, page: () => const DiscordLinkCommunity()),

    GetPage(
      name: Routes.TRANSACTIONS,
      page: () => const TransactionsPage(),
      binding: TransactionBinding(),
    ),

    // ========== WebView ==========
  ];

  // Private constructor to prevent instantiation
  AppPages._();
}
