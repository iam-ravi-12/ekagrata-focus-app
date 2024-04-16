import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:email_validator/email_validator.dart';

import '../navbar/customnavbar.dart';
import '../services/functions/authFunctions.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String fullname = '';
  bool login = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ======== Full Name ========
              login
                  ? Container()
                  : TextFormField(
                      key: ValueKey('fullname'),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(100),
                          ),
                        ),
                        hintText: 'Enter Full Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Full Name';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          fullname = value!;
                        });
                      },
                    ),

              // ======== Email ========
              TextFormField(
                key: ValueKey('email'),
                decoration: InputDecoration(
                  border: login
                      ? const OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(100),
                          ),
                        )
                      : OutlineInputBorder(),
                  hintText: 'Enter Email',
                ),
                validator: (value) {
                  if (value!.isEmpty || !EmailValidator.validate(value)) {
                    return 'Please Enter valid Email';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  setState(() {
                    email = value!;
                  });
                },
              ),
              // ======== Password ========
              TextFormField(
                key: const ValueKey('password'),
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                  hintText: 'Enter Password',
                ),
                validator: (value) {
                  if (value!.length < 6) {
                    return 'Please Enter Password of min length 6';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  setState(() {
                    password = value!;
                  });
                },
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        bool? success = false;
                        if (login) {
                          print(login);
                          // Check if user exists and password is correct
                          success = await AuthServices.signinUser(
                              email, password, context);
                        } else {
                          print("singup");
                          success = await AuthServices.signupUser(
                              email, password, fullname, context);
                        }
                        if (success == true) {
                          await Future.delayed(
                              const Duration(milliseconds: 100));
                          // Navigate to CustomNavBar if credentials are correct
                          Get.off(() => CustomNavBar());
                        }
                        // login
                        //     ? AuthServices.signinUser(email, password, context)
                        //     : AuthServices.signupUser(
                        //         email, password, fullname, context);
                      }
                    },
                    child: Text(login ? 'Login' : 'Signup')),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      login = !login;
                    });
                  },
                  child: Text(login
                      ? "Don't have an account? Signup"
                      : "Already have an account? Login"))
            ],
          ),
        ),
      ),
    );
  }
}

// import '/flutter_flow/flutter_flow_icon_button.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';



// class NewPageWidget extends StatefulWidget {
//   const NewPageWidget({super.key});

//   @override
//   State<NewPageWidget> createState() => _NewPageWidgetState();
// }

// class _NewPageWidgetState extends State<NewPageWidget> {
//   late NewPageModel _model;

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => NewPageModel());

//     _model.textController ??= TextEditingController();
//     _model.value ??= FocusNode();

//     _model.textController ??= TextEditingController();
//     _model.value ??= FocusNode();
//   }

//   @override
//   void dispose() {
//     _model.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _model.unfocusNode.canRequestFocus
//           ? FocusScope.of(context).requestFocus(_model.unfocusNode)
//           : FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         key: scaffoldKey,
//         // backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
//         body: SafeArea(
//           top: true,
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 16),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Elevated(
//                       buttonSize: 45,
//                       icon: Icon(
//                         Icons.arrow_back_ios_rounded,
//                         // color: FlutterFlowTheme.of(context).primaryText,
//                         size: 22,
//                       ),
//                       onPressed: () {
//                         print('IconButton pressed ...');
//                       },
//                     ),
//                     const Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
//                       child: Text(
//                         'Login or Sign Up',
//                         // style: FlutterFlowTheme.of(context)
//                         //     .headlineMedium
//                         //     .override(
//                         //       fontFamily: 'Outfit',
//                         //       color: FlutterFlowTheme.of(context).primaryText,
//                         //       letterSpacing: 0,
//                         //     ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
//                       child: TextFormField(
//                         controller: _model.textController,
//                         focusNode: _model.value,
//                         autofocus: false,
//                         obscureText: false,
//                         decoration: InputDecoration(
//                           labelText: 'Email',
//                           hintText: 'Enter your email',
//                           // hintStyle:
//                           //     FlutterFlowTheme.of(context).bodyLarge.override(
//                           //           fontFamily: 'Plus Jakarta Sans',
//                           //           letterSpacing: 0,
//                           //         ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               // color: FlutterFlowTheme.of(context).primary,
//                               width: 2,
//                             ),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Color(0x00000000),
//                               width: 2,
//                             ),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Color(0x00000000),
//                               width: 2,
//                             ),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           focusedErrorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Color(0x00000000),
//                               width: 2,
//                             ),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         // style: FlutterFlowTheme.of(context).bodyMedium.override(
//                         //       fontFamily: 'Plus Jakarta Sans',
//                         //       letterSpacing: 0,
//                         //     ),
//                         validator:
//                             _model.textControllerValidator.asValidator(context),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
//                       child: TextFormField(
//                         controller: _model.textController,
//                         focusNode: _model.value,
//                         autofocus: false,
//                         obscureText: !_model.passwordVisibility,
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           hintText: 'Enter your password',
//                           // hintStyle:
//                           //     FlutterFlowTheme.of(context).bodyLarge.override(
//                           //           fontFamily: 'Plus Jakarta Sans',
//                           //           letterSpacing: 0,
//                           //         ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               // color: FlutterFlowTheme.of(context).primary,
//                               width: 2,
//                             ),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Color(0x00000000),
//                               width: 2,
//                             ),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Color(0x00000000),
//                               width: 2,
//                             ),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           focusedErrorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Color(0x00000000),
//                               width: 2,
//                             ),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           suffixIcon: InkWell(
//                             onTap: () => setState(
//                               () => _model.passwordVisibility =
//                                   !_model.passwordVisibility,
//                             ),
//                             focusNode: FocusNode(skipTraversal: true),
//                             child: Icon(
//                               _model.passwordVisibility
//                                   ? Icons.visibility_outlined
//                                   : Icons.visibility_off_outlined,
//                               // color: FlutterFlowTheme.of(context).secondaryText,
//                               size: 22,
//                             ),
//                           ),
//                         ),
//                         // style: FlutterFlowTheme.of(context).bodyMedium.override(
//                         //       fontFamily: 'Plus Jakarta Sans',
//                         //       letterSpacing: 0,
//                         //     ),
//                         validator:
//                             _model.textControllerValidator.asValidator(context),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
//                       child: FFButtonWidget(
//                         onPressed: () {
//                           print('Button pressed ...');
//                         },
//                         text: 'Login',
//                         options: FFButtonOptions(
//                           width: double.infinity,
//                           height: 55,
//                           padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                           iconPadding:
//                               EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                           // color: FlutterFlowTheme.of(context).primary,
//                           // textStyle:
//                           //     FlutterFlowTheme.of(context).titleMedium.override(
//                           //           fontFamily: 'Plus Jakarta Sans',
//                           //           color: Colors.white,
//                           //           letterSpacing: 0,
//                           //         ),
//                           elevation: 2,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
//                       child: Text(
//                         'or',
//                         // style: FlutterFlowTheme.of(context).bodyMedium.override(
//                         //       fontFamily: 'Plus Jakarta Sans',
//                         //       letterSpacing: 0,
//                         //     ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
//                       child: FFButtonWidget(
//                         onPressed: () {
//                           print('Button pressed ...');
//                         },
//                         text: 'Sign Up',
//                         options: FFButtonOptions(
//                           width: double.infinity,
//                           height: 55,
//                           padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                           iconPadding:
//                               EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                           color:
//                               FlutterFlowTheme.of(context).secondaryBackground,
//                           textStyle: FlutterFlowTheme.of(context)
//                               .titleMedium
//                               .override(
//                                 fontFamily: 'Plus Jakarta Sans',
//                                 // color: FlutterFlowTheme.of(context).primaryText,
//                                 letterSpacing: 0,
//                               ),
//                           elevation: 2,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
