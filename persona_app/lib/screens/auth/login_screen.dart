import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/datasource/local/auth_local_datasource.dart';
import '../../data/datasource/local/prediction_local_datasource.dart';
import '../../data/datasource/remote/auth_remote_datasource.dart';
import '../../data/datasource/remote/prediction_remote_datasource.dart';
import '../../data/models/user_choice_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/prediction_repository.dart';
import '../../router/app_router.dart';
import '../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepository = AuthRepository(
    AuthRemoteDataSource(),
    AuthLocalDatasource(),
  );

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go(RouteConstants.uploadRoute);
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  _buildLogo(),
                  const SizedBox(height: 20),
                  _buildTitle(),
                  const SizedBox(height: 30),
                  _buildUsernameField(),
                  const SizedBox(height: 16),
                  _buildPasswordField(),
                  const SizedBox(height: 16),
                  _buildRememberMeSwitch(),
                  const SizedBox(height: 30),
                  _buildLoginButton(),
                  const SizedBox(height: 20),
                  _buildSignUpPrompt(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Image.asset(
        'assets/images/Frame-2.png',
        width: 120,
        height: 120,
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Sign in',
      style: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      decoration: const InputDecoration(
        hintText: 'Insert Username',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: FormValidators.validateUsername,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: 'Insert Password',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      validator: FormValidators.validatePassword,
      textInputAction: TextInputAction.done,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildRememberMeSwitch() {
    return Row(
      children: [
        Switch(
          value: _rememberMe,
          onChanged: (value) {
            setState(() => _rememberMe = value);
          },
        ),
        const Text(
          'Remember Me',
          style: TextStyle(
            color: Color(0xFF110C26),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text(
              'SIGN IN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
    );
  }

  Widget _buildSignUpPrompt() {
    return GestureDetector(
      onTap: () => context.go(RouteConstants.signupRoute),
      child: const Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Dont have an account?',
              style: TextStyle(
                color: Color(0xFF110C26),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: 'Sign up',
              style: TextStyle(
                color: Color(0xFFFFA1BF),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authRepository.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      await _handleUserSelection();
      context.go(RouteConstants.historyRoute);
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog('Login Failed', e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleUserSelection() async {
    final args = GoRouterState.of(context).extra as Map<String, dynamic>?;
    if (args?['userSelection'] == null) return;

    final userSelection = args!['userSelection'] as UserSelection;
    final predictionRepository = PredictionRepository(
      PredictionLocalDataSource(),
      PredictionRemoteDataSource(),
    );

    await predictionRepository.saveUserSelection(userSelection);
    if (!mounted) return;
    _showSuccessDialog('Selection saved successfully');
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}