import 'dart:async';
import 'dart:developer';
import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/core/ui/helpers/messages.dart';
import 'package:dw_barbershop/src/features/splash/splash_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  double _scale = 10.0;
  double _animationOpacityLogo = 0.0;

  double get _logoAnimationWidth => 100 * _scale;
  double get _logoAnimationHeight => 120 * _scale;

  var isAnimation = true;
  Timer? redirectTimer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _animationOpacityLogo = 1.0;
        _scale = 1;
      });
    });

    super.initState();
  }

  void _redirect(String routeName) {
    if (isAnimation) {
      redirectTimer?.cancel();
      redirectTimer = Timer(const Duration(milliseconds: 300), () {
        _redirect(routeName);
      });
    } else {
      redirectTimer?.cancel();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(routeName, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashVmProvider, (_, state) {
      state.whenOrNull(
        error: (error, stackTrace) {
          log('Erro ao validar o login', error: error, stackTrace: stackTrace);
          Messages.showError('Erro ao validar o login', context);
          _redirect('/auth/login');
        },
        data: (data) {
          switch (data) {
            case SplashState.loggedAdm:
              _redirect('/home/adm');
              break;
            case SplashState.loggedEmployee:
              _redirect('/home/employee');
              break;
            case _:
              _redirect('/auth/login');
              break;
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstants.backgroundChair),
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            duration: const Duration(seconds: 3),
            curve: Curves.easeIn,
            opacity: _animationOpacityLogo,
            onEnd: () {
              setState(() {
                isAnimation = false;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(seconds: 3),
              curve: Curves.linearToEaseOut,
              width: _logoAnimationWidth,
              height: _logoAnimationHeight,
              child: Image.asset(
                ImageConstants.imageLogo,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
