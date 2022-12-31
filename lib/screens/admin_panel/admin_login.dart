import 'package:fifa2022/config/constants.dart';
import 'package:fifa2022/screens/Auth/auth_widgets.dart';
import 'package:fifa2022/services/admin_service.dart';
import 'package:fifa2022/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormBuilderState>();
  final _userNameFieldKey = GlobalKey<FormBuilderFieldState>();
  final _passFieldKey = GlobalKey<FormBuilderFieldState>();
  late AnimationController animationController;
  @override
  void initState() {
    // TODO: implement initState


    super.initState();
    animationController=   AnimationController(vsync: this,
        duration: const Duration(seconds: 2))..repeat();


  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainRed,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_home.png",
            ),
            fit: BoxFit.cover
          )
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black.withOpacity(0.45),
                    offset: const Offset(0,3),
                    blurRadius: 35
                )
              ]
            ),
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Admin Login",style: TextStyle(
                      fontFamily: "kalam",
                      fontWeight: FontWeight.w600,
                      fontSize: 42,
                      color: mainRed
                    ),),
                    const SizedBox(height: 48,),
                    Material(
                      color: Colors.white,
                      child: InkWell(
                        focusColor: Colors.white,
                        onHover: (val){

                        },
                        onTap: (){},
                        child: Ink(
                          child: FormBuilderTextField(
                            key: _userNameFieldKey,
                            name: 'username',
                            cursorColor: mainRed,
                            cursorHeight: 20,
                            decoration:  InputDecoration(labelText: 'Username',
                            prefixIcon: const Icon(Icons.person, color: mainRed,),
                            labelStyle: TextStyle(color: Colors.grey.shade400,
                            fontWeight: FontWeight.w300),
                            floatingLabelStyle:const TextStyle(color: mainRed),
                            border:const UnderlineInputBorder(
                              borderSide: BorderSide(color: mainRed)
                            ),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: mainRed)
                              ),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16,),
                    Material(
                      color: Colors.white,
                      child: InkWell(
                        focusColor: Colors.white,
                        onHover: (val){

                        },
                        onTap: (){},
                        child: Ink(
                          child: FormBuilderTextField(
                            key: _passFieldKey,
                            name: 'password',
                            cursorColor: mainRed,
                            obscureText: true,
                            cursorHeight: 20,
                            decoration:  InputDecoration(labelText: 'Password',
                              prefixIcon: const Icon(Icons.password, color: mainRed,),
                              labelStyle: TextStyle(color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w300),
                              floatingLabelStyle:const TextStyle(color: mainRed),
                              border:const UnderlineInputBorder(
                                  borderSide: BorderSide(color: mainRed)
                              ),
                              focusedBorder:  const UnderlineInputBorder(
                                  borderSide: BorderSide(color: mainRed)
                              ),
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(6),
                            ]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 64,),

                   AuthButton(
                     width: 150,
                     onPressed: () async {
                       if (_formKey.currentState?.saveAndValidate() ?? false) {
                         debugPrint(_formKey.currentState?.value.toString());
                         debugPrint(_formKey.currentState?.value["username"]);
                         bool success=false;
                         String errorMsg="";
                         showAlertDialog(context, animationController);
                         try{
                           await AdminServices().loginAdmin(_formKey.currentState?.value["username"],
                               _formKey.currentState?.value["password"]);
                           success=true;
                         }
                         catch(e)
                         {
                           success=false;
                           errorMsg=e.toString();
                         }
                         Navigator.pop(context);
                         if(success)
                           {
                             showSuccessSnackBar(context, "Successfully logged in as admin!");
                             Navigator.popAndPushNamed(context, "admin/dashboard");
                           }
                         else{
                          showErrorSnackBar(context, errorMsg.toString());
                         }
                       } else {
                         debugPrint(_formKey.currentState?.value.toString());
                         debugPrint('validation failed');
                       }
                     },
                     text: "Login",
                     isSmallScreen: true,
                     screenHeight: MediaQuery.of(context).size.height,
                   )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
