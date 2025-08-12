import 'package:ecommerce_app/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app/src/common_widgets/custom_text_button.dart';
import 'package:ecommerce_app/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app/src/features/authentication/data/auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/more_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class AuthRobot {
  final WidgetTester tester;

  AuthRobot(this.tester);

  Future<void> pumpEmailPasswordSignInContents({
    required AuthRepository authRepository,
    required EmailPasswordSignInFormType formType,
    VoidCallback? onSignIn,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(authRepository)],
        child: MaterialApp(
          home: Scaffold(
            body: EmailPasswordSignInContents(
              formType: formType,
              onSignedIn: onSignIn,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pumpAccountScreen({AuthRepository? authRepository}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [if (authRepository != null) authRepositoryProvider.overrideWithValue(authRepository)],
        child: MaterialApp(
          home: AccountScreen(),
        ),
      ),
    );
  }

  Future<void> tapLogoutButton() async {
    final logoutButton = find.text('Logout');
    expect(logoutButton, findsOneWidget);

    await tester.tap(logoutButton);
    await tester.pump();
  }

  void expectLogoutDialogFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsOneWidget);
  }

  Future<void> tapCancelButton() async {
    final cancelButton = find.text('Cancel');
    expect(cancelButton, findsOneWidget);

    await tester.tap(cancelButton);
    await tester.pump();
  }

  void expectLogoutDialogNotFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsNothing);
  }

  Future<void> tapDialogLogoutButton() async {
    final logoutButton = find.byKey(kDialogDefaultKey);
    expect(logoutButton, findsOneWidget);

    await tester.tap(logoutButton);
    await tester.pump();
  }

  void expectErrorDialogFound() {
    final dialogTitle = find.text('Error');
    expect(dialogTitle, findsOneWidget);
  }

  void expectErrorDialogNotFound() {
    final dialogTitle = find.text('Error');
    expect(dialogTitle, findsNothing);
  }

  void expectCircularProgressIndicator() {
    final indicator = find.byType(CircularProgressIndicator);
    expect(indicator, findsOneWidget);
  }

  Future<void> tapEmailPasswordSubmitButton() async {
    final primaryButton = find.byType(PrimaryButton);
    await tester.tap(primaryButton);
    await tester.pumpAndSettle();
  }

  Future<void> enterEmail(String email) async {
    final emailField = find.byKey(EmailPasswordSignInScreen.emailKey);
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, email);
  }

  Future<void> enterPassword(String password) async {
    final passwordField = find.byKey(EmailPasswordSignInScreen.passwordKey);
    expect(passwordField, findsOneWidget);
    await tester.enterText(passwordField, password);
  }

  Future<void> enterAndSubmitEmailAndPassword() async {
    await enterEmail("email@test.com");
    await enterPassword("password1234");
    await tapEmailPasswordSubmitButton();
  }

  Future<void> openEmailAndPasswordSignInScreen() async {
    final signInButton = find.byKey(MoreMenuButton.signInKey);
    expect(signInButton, findsOneWidget);
    await tester.tap(signInButton);
    await tester.pumpAndSettle();
  }

  Future<void> openAccountScreen() async {
    final accountButton = find.byKey(MoreMenuButton.accountKey);
    expect(accountButton, findsOneWidget);
    await tester.tap(accountButton);
    await tester.pumpAndSettle();
  }

  void expectEmailAndPasswordFieldsFound() {
    final emailField = find.byKey(EmailPasswordSignInScreen.emailKey);
    expect(emailField, findsOneWidget);
    final passwordField = find.byKey(EmailPasswordSignInScreen.passwordKey);
    expect(passwordField, findsOneWidget);
  }

  Future<void> tapFormToggleButton() async {
    final toggleButton = find.byType(CustomTextButton);
    expect(toggleButton, findsOneWidget);
    await tester.tap(toggleButton);
    await tester.pumpAndSettle();
  }
}
