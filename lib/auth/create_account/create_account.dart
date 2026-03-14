import 'package:bill_n_stock/auth/create_account/create_account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateAccountState(),
      child: const _CreateAccountView(),
    );
  }
}

class _CreateAccountView extends StatelessWidget {
  const _CreateAccountView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CreateAccountState>();
    state.setContext(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus(); // 👈 removes focus
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 64),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person_add_outlined,
                        size: 40,
                        color: Color(0xFF1976D2),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1565C0),
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          'Create an account to get started',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF546E7A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    authTextField(
                      hint: 'Username',
                      controller: state.usernameController,
                      icon: Icons.person_outline,
                    ),

                    const SizedBox(height: 6),

                    if (state.usernameError != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          state.usernameError!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                          ),
                        ),
                      )
                    else if (state.showUsernameAvailable)
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Username available',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      cursorColor: const Color(0xFF2196F3),
                      style: const TextStyle(color: Color(0xFF263238)),
                      controller: state.contactNumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // 🔥 IMPORTANT
                      ],
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Mobile Number',
                        hintStyle: const TextStyle(color: Color(0xFF78909C)),
                        filled: true,
                        fillColor: const Color(0xFFF5FBFF),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        prefixIcon: const Icon(
                          Icons.phone_outlined,
                          color: Color(0xFF1976D2),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF2196F3),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFBBDEFB),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    if (state.contactError != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          state.contactError!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                          ),
                        ),
                      )
                    else if (state.showContactAvailable)
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Mobile number available',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else if (state.contactNumberController.text.isNotEmpty &&
                        state.contactNumberController.text.length < 10)
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Enter 10-digit mobile number',
                          style: TextStyle(color: Colors.orange, fontSize: 12),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Password Field
                authTextField(
                  hint: 'Password',
                  controller: state.passwordController,
                  obscure: !state.showPassword,
                  icon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.showPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xFF1976D2),
                    ),
                    onPressed: state.togglePassword,
                  ),
                ),

                const SizedBox(height: 16),

                authTextField(
                  hint: 'Confirm Password',
                  controller: state.confirmPasswordController,
                  obscure: !state.showConfirmPassword,
                  icon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      state.showConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xFF1976D2),
                    ),
                    onPressed: state.toggleConfirmPassword,
                  ),
                ),

                // Password Requirements (Optional but helpful)
                Container(
                  margin: const EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    'Password must be at least 8 characters',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF546E7A).withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => state.createAccount(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFBBDEFB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      shadowColor: const Color(0xFF2196F3).withOpacity(0.3),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
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
                        'Already have an account? ',
                        style: TextStyle(color: Color(0xFF546E7A)),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Sign In',
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
    );
  }

  Widget authTextField({
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      cursorColor: const Color(0xFF2196F3),
      style: const TextStyle(color: Color(0xFF263238)),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF78909C)),
        filled: true,
        fillColor: const Color(0xFFF5FBFF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        prefixIcon: icon != null
            ? Icon(icon, color: const Color(0xFF1976D2), size: 22)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBBDEFB), width: 1),
        ),
      ),
    );
  }
}
