import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:bill_n_stock/auth/login/login_state.dart';
import 'package:bill_n_stock/auth/create_account/create_account.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginState(),
      child: Consumer<LoginState>(
        builder: (context, state, _) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 80),

                        // Logo/Icon Section with light blue accent
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFE3F2FD,
                            ), // Light blue background
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.lock_outline,
                            size: 40,
                            color: Color(0xFF1976D2), // Darker blue for icon
                          ),
                        ),

                        const Text(
                          'Welcome Back 👋',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1565C0), // Dark blue for title
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Sign in to continue',
                          style: TextStyle(
                            color: Color(
                              0xFF546E7A,
                            ), // Grayish blue for subtitle
                          ),
                        ),

                        const SizedBox(height: 40),
                        authTextField(
                          hint: 'Enter your username',

                          controller: state.usernameController,
                        ),

                        const SizedBox(height: 16),

                        authTextField(
                          hint: 'Enter your Password',
                          controller: state.passwordController,
                          obscure: !state.showPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              state.showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color(0xFF1976D2),
                            ),
                            onPressed: state.togglePasswordVisibility,
                          ),
                        ),

                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: state.isLoading
                                ? null
                                : () => state.signIn(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF2196F3,
                              ), // Blue button
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: const Color(
                                0xFFBBDEFB,
                              ), // Light blue when disabled
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              shadowColor: const Color(
                                0xFF2196F3,
                              ).withOpacity(0.3),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                        // Create Account Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF2196F3).withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Color(0xFF546E7A)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CreateAccountPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Color(0xFF1976D2),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget authTextField({
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      cursorColor: const Color(0xFF2196F3), // Blue cursor
      style: const TextStyle(
        color: Color(0xFF263238), // Dark text color
      ),
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffixIcon,
        hintStyle: const TextStyle(
          color: Color(0xFF78909C),
        ), // Light blue-gray hint
        filled: true,
        fillColor: const Color(0xFFF5FBFF), // Very light blue background
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF2196F3), // Blue border when focused
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFBBDEFB), // Light blue border
            width: 1,
          ),
        ),
        prefixIcon: hint.toLowerCase().contains('username')
            ? const Icon(
                Icons.account_circle_outlined,
                color: Color(0xFF1976D2),
              )
            : hint.toLowerCase().contains('password')
            ? const Icon(Icons.lock_outline, color: Color(0xFF1976D2))
            : null,
      ),
    );
  }
}
