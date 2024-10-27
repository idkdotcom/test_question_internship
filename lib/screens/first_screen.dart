import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suitmedia_test/providers/user_provider.dart';
import 'package:suitmedia_test/screens/second_screen.dart';
import 'package:suitmedia_test/widgets/first_screen_button.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final _form = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  var _enteredPalindrome;

  @override
    void dispose() {
      _nameController.dispose();
      super.dispose();
    }

    bool validateForm() {
      final isValid = _form.currentState?.validate() ?? false;

      if (!isValid) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Please fill out Name and Palindrome",
            ),
          ),
        );
        return false;
      }

      _form.currentState!.save();
      return true;
    }

    String reverseText(String text) {
      final cleanedText = text.trim().toLowerCase();
      final reversedText = cleanedText.split('').reversed.join('');
      return reversedText;
    }

    bool checkPalindrome() {
      if(!validateForm()){
        return false;
      }
      final reversedText = reverseText(_enteredPalindrome);
      if (reversedText == _enteredPalindrome) {
        return true;
      }
      return false;
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 116,
                  height: 116,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.4),
                    child: const Icon(
                      Icons.person_add_alt_1_sharp,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 310,
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              label: Container(
                                alignment: const Alignment(-0.9, 0),
                                child: const Text("Name"),
                              ),
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                              helperText: ' ',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            keyboardType: TextInputType.name,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Name cannot be empty.";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 310,
                          child: TextFormField(
                            decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              label: Container(
                                alignment: const Alignment(-0.9, 0),
                                child: const Text("Palindrome"),
                              ),
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            keyboardType: TextInputType.name,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Palindrome cannot be empty.";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPalindrome = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                FirstScreenButton(
                    text: "CHECK",
                    onPressed: () {
                      if(validateForm()){
                        context.read<UserProvider>().setUserName(_nameController.text);
                      }
                      ScaffoldMessenger.of(context).clearSnackBars;
                      checkPalindrome()
                          ? ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("isPalindrome"),
                              ),
                            )
                          : ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("not palindrome"),
                              ),
                            );
                    }),
                const SizedBox(
                  height: 20,
                ),
                FirstScreenButton(
                  text: "NEXT",
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SecondScreen())
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
