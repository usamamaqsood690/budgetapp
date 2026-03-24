import 'package:flutter/material.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/auth/page/login/page/login_page.dart';
import 'package:wealthnxai/presentation/modules/dashboard/page/dashboard_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  bool get _isFormValid =>
      _nameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _passwordController.text.length >= 6 &&
      _passwordController.text == _confirmPasswordController.text &&
      _agreeToTerms;

  String? get _passwordMatchError =>
      _confirmPasswordController.text.isNotEmpty &&
              _passwordController.text != _confirmPasswordController.text
          ? 'Passwords do not match'
          : null;

  Future<void> _signUp() async {
    if (!_isFormValid) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF8),
      body: Column(
        children: [
          // 1. Teal top section
          _SignUpTopSection(),

          // 2. Form
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingSymmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.addHeight(28),

                  const Text(
                    'Create account ✨',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  AppSpacing.addHeight(6),
                  Text(
                    'Fill in the details below to get started',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                  AppSpacing.addHeight(28),

                  // Full Name
                  _FieldLabel(label: 'FULL NAME'),
                  AppSpacing.addHeight(8),
                  _AuthTextField(
                    controller: _nameController,
                    hint: 'Enter your full name',
                    icon: Icons.person_outline_rounded,
                    onChanged: (_) => setState(() {}),
                  ),
                  AppSpacing.addHeight(18),

                  // Email
                  _FieldLabel(label: 'EMAIL ADDRESS'),
                  AppSpacing.addHeight(8),
                  _AuthTextField(
                    controller: _emailController,
                    hint: 'Enter your email',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => setState(() {}),
                  ),
                  AppSpacing.addHeight(18),

                  // Password
                  _FieldLabel(label: 'PASSWORD'),
                  AppSpacing.addHeight(8),
                  _AuthTextField(
                    controller: _passwordController,
                    hint: 'Min. 6 characters',
                    icon: Icons.lock_outline_rounded,
                    obscure: _obscurePassword,
                    onChanged: (_) => setState(() {}),
                    suffix: GestureDetector(
                      onTap:
                          () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),

                  // Password strength indicator
                  if (_passwordController.text.isNotEmpty) ...[
                    AppSpacing.addHeight(8),
                    _PasswordStrengthBar(password: _passwordController.text),
                  ],
                  AppSpacing.addHeight(18),

                  // Confirm Password
                  _FieldLabel(label: 'CONFIRM PASSWORD'),
                  AppSpacing.addHeight(8),
                  _AuthTextField(
                    controller: _confirmPasswordController,
                    hint: 'Re-enter your password',
                    icon: Icons.lock_outline_rounded,
                    obscure: _obscureConfirm,
                    onChanged: (_) => setState(() {}),
                    suffix: GestureDetector(
                      onTap:
                          () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                      child: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    errorText: _passwordMatchError,
                  ),
                  AppSpacing.addHeight(20),

                  // Terms checkbox
                  GestureDetector(
                    onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color:
                                _agreeToTerms
                                    ? const Color(0xFF3DAA8E)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color:
                                  _agreeToTerms
                                      ? const Color(0xFF3DAA8E)
                                      : Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          child:
                              _agreeToTerms
                                  ? const Icon(
                                    Icons.check_rounded,
                                    size: 13,
                                    color: Colors.white,
                                  )
                                  : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                                height: 1.4,
                              ),
                              children: const [
                                TextSpan(text: 'I agree to the '),
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: TextStyle(
                                    color: Color(0xFF3DAA8E),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: Color(0xFF3DAA8E),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.addHeight(32),

                  // Sign Up button
                  _AuthButton(
                    label: _isLoading ? '' : 'Create Account',
                    isEnabled: _isFormValid && !_isLoading,
                    onTap: _signUp,
                    isLoading: _isLoading,
                  ),
                  AppSpacing.addHeight(24),

                  // Divider
                  _OrDivider(),
                  AppSpacing.addHeight(24),

                  // Social sign up
                  _SocialLoginRow(),
                  AppSpacing.addHeight(32),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      GestureDetector(
                        onTap:
                            () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3DAA8E),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.addHeight(24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Top Section ──────────────────────────────────────────────────────────────

class _SignUpTopSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3DAA8E), Color(0xFF2D8C74)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.addHeight(14),
          const Text(
            'BudgetAI',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          Text(
            'Create your free account',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.80),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Password Strength Bar ────────────────────────────────────────────────────

class _PasswordStrengthBar extends StatelessWidget {
  final String password;
  const _PasswordStrengthBar({required this.password});

  int get _strength {
    int score = 0;
    if (password.length >= 6) score++;
    if (password.length >= 10) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#\$%^&*]'))) score++;
    return score;
  }

  Color get _color {
    if (_strength <= 1) return const Color(0xFFE53935);
    if (_strength <= 3) return const Color(0xFFF9A825);
    return const Color(0xFF3DAA8E);
  }

  String get _label {
    if (_strength <= 1) return 'Weak';
    if (_strength <= 3) return 'Medium';
    return 'Strong';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _strength / 5,
              minHeight: 5,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(_color),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          _label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: _color,
          ),
        ),
      ],
    );
  }
}

// ─── Shared Widgets (reused from login_page.dart) ─────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Color(0xFF888888),
        letterSpacing: 1.0,
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;
  final String? errorText;

  const _AuthTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType,
    this.onChanged,
    this.suffix,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1A1A2E),
      ),
      decoration: InputDecoration(
        hintText: hint,
        errorText: errorText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade400,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(icon, size: 20, color: Colors.grey.shade400),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color:
                errorText != null
                    ? const Color(0xFFE53935)
                    : Colors.grey.shade300,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3DAA8E), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE53935), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String label;
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback? onTap;

  const _AuthButton({
    required this.label,
    required this.isEnabled,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          gradient:
              isEnabled
                  ? const LinearGradient(
                    colors: [Color(0xFF3DAA8E), Color(0xFF2D8C74)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color: isEnabled ? null : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(30),
          boxShadow:
              isEnabled
                  ? [
                    BoxShadow(
                      color: const Color(0xFF3DAA8E).withOpacity(0.40),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                  : [],
        ),
        child:
            isLoading
                ? const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
                : Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isEnabled ? Colors.white : Colors.grey.shade500,
                    letterSpacing: 0.3,
                  ),
                ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade400,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
      ],
    );
  }
}

class _SocialLoginRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SocialButton(
            label: 'Google',
            icon: Icons.g_mobiledata_rounded,
            iconColor: const Color(0xFFE53935),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _SocialButton(
            label: 'Apple',
            icon: Icons.apple_rounded,
            iconColor: const Color(0xFF1A1A2E),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
