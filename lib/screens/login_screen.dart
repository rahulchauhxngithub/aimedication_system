import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import '../main.dart'; // Import your main.dart to access MedicationDashboard

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    AuthService authService = AuthService();
    var user = await authService.signInWithEmailPassword(email, password);

    setState(() {
      isLoading = false;
    });

    if (user != null) {
      print("✅ Login successful: ${user.email}");
      // Navigate to the MedicationDashboard and remove all previous routes
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MedicationDashboard())
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed. Please check your credentials."))
      );
      print("❌ Login failed");
    }
  }

  void loginWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    AuthService authService = AuthService();
    var user = await authService.signInWithGoogle();

    setState(() {
      isLoading = false;
    });

    if (user != null) {
      print("✅ Google Sign-In successful: ${user.email}");
      // Navigate to MedicationDashboard and remove all previous routes
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MedicationDashboard())
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Google Sign-In failed. Please try again."))
      );
      print("❌ Google Sign-In failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email)
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock)
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            isLoading
                ? CircularProgressIndicator()
                : Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: login,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text("Login", style: TextStyle(fontSize: 16)),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.login),
                    onPressed: loginWithGoogle,
                    label: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text("Login with Google", style: TextStyle(fontSize: 16)),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen())
              ),
              child: Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}