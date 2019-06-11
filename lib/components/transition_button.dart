import 'package:app/components/messages.dart';
import 'package:flutter/material.dart';

class TransitionButton extends StatefulWidget {
  /// A Personal Button that reproduces a 'dribble' animation when the [onPressed] complete with success.
  ///
  ///It calls the [MensagemDeErro] show method to print the exception on the botton screen when [onPressed] complete with error.
  ///
  /// Must be placed as the last child of a [Stack] element to avoid layout issues.
  ///
  /// Only one [TransitionButton] can be used per page.
  ///
  /// See [https://blog.geekyants.com/flutter-login-animation-ab3e6ed4bd19] for details about construction.
  ///
  /// Use together with [FadeInTransitionRoute]
  TransitionButton(
      {@required this.onPressed,
      @required this.text,
      @required this.color,
      @required this.route,
      this.margin = const EdgeInsets.only(bottom: 10.0),
      this.canGoBack = true});

  ///Function that was call before the transition to another page happens.
  ///
  ///if you only require the animation itselt, fill with [null] value.
  final Function onPressed;
  final String text;
  final Color color;
  final String route;
  final bool canGoBack;
  final EdgeInsets margin;

  @override
  TransitionButtonState createState() => TransitionButtonState();
}

class TransitionButtonState extends State<TransitionButton>
    with TickerProviderStateMixin {
  ///Controls the reveal animation of the button when the screen builds.
  AnimationController _inicialController;

  ///Controls the squeeze animation of the button when the [onPressed] is triggered.
  ///Reverse the normal width of the button when the [onPressed] complete with error.
  AnimationController _loadingController;

  ///Controls the grow animation of the button when the [onPressed] complete with success.
  AnimationController _transitioningController;

  ///Hold the States of animation.
  ButtonStatus _status;

  @override
  void initState() {
    super.initState();

    this._inicialController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    this._transitioningController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750));
    this._loadingController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750));

    this._status = ButtonStatus.Inicial;
    this._inicialController.forward();

    this._inicialController.addListener(() {
      if (this._inicialController.isCompleted) {
        setState(() {
          this._status = ButtonStatus.Normal;
        });
      }
    });
  }

  Future<void> _handleFunction() async {
    setState(() {
      this._status = ButtonStatus.Loading;
    });

    await this._loadingController.forward();

    if (widget.onPressed == null) {
      setState(() {
        this._status = ButtonStatus.Transiting;
      });

      await this._transitioningController.forward();
      if (widget.canGoBack)
        await Navigator.pushNamed(context, widget.route);
      else
        await Navigator.pushReplacementNamed(context, widget.route);
      this._transitioningController.reverse();
    } else {
      widget.onPressed().then((_) async {
        setState(() {
          this._status = ButtonStatus.Transiting;
        });

        await this._transitioningController.forward();

        if (widget.canGoBack)
          await Navigator.pushNamed(context, widget.route);
        else
          await Navigator.pushReplacementNamed(context, widget.route);

        this._transitioningController.reverse();
      }).catchError((error) async {
        await this._loadingController.reverse();
        setState(() {
          this._status = ButtonStatus.Normal;
        });
        showErrorMessage(error.message, context);
      });
    }
  }

  @override
  void dispose() {
    this._inicialController?.dispose();
    //this._transitioningController?.dispose();
    this._loadingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget retorno = TransitionButtonInicialAnimation(
        controller: this._inicialController.view,
        color: widget.color,
        margin: widget.margin);
    switch (this._status) {
      case ButtonStatus.Inicial:
        retorno = TransitionButtonInicialAnimation(
            controller: this._inicialController.view,
            color: widget.color,
            margin: widget.margin);
        break;

      case ButtonStatus.Normal:
        retorno = Container(
          margin: widget.margin,
          width: 320.0,
          height: 50,
          child: RaisedButton(
            onPressed: this._handleFunction,
            color: widget.color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            child: Text(
              widget.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.3,
              ),
            ),
          ),
        );
        break;

      case ButtonStatus.Loading:
        retorno = TransitionButtonLoadingAnimation(
            controller: this._loadingController.view,
            color: widget.color,
            margin: widget.margin);
        break;

      case ButtonStatus.Transiting:
        retorno = TransitionButtonTransitioningAnimation(
            controller: this._transitioningController,
            color: widget.color,
            margin: widget.margin);
        break;
    }

    return retorno;
  }
}

class TransitionButtonInicialAnimation extends StatelessWidget {
  TransitionButtonInicialAnimation({this.controller, this.color, this.margin})
      : opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.999, curve: Curves.ease),
          ),
        ),
        width = Tween<double>(begin: 0.0, end: 320.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.999, curve: Curves.ease),
          ),
        );

  final Animation controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Color color;
  final EdgeInsets margin;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      margin: this.margin,
      width: this.width.value,
      height: 50,
      child: Opacity(
        opacity: this.opacity.value,
        child: RaisedButton(
          onPressed: () {},
          color: this.color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        builder: this._buildAnimation, animation: this.controller);
  }
}

class TransitionButtonLoadingAnimation extends StatelessWidget {
  TransitionButtonLoadingAnimation({this.controller, this.color, this.margin})
      : width = Tween<double>(begin: 320.0, end: 70.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.999, curve: Curves.ease),
          ),
        );

  final Animation controller;
  final Animation<double> width;
  final Color color;
  final EdgeInsets margin;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      margin: this.margin,
      width: this.width.value,
      height: 50,
      child: RaisedButton(
        onPressed: () {},
        color: this.color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        builder: this._buildAnimation, animation: this.controller);
  }
}

class TransitionButtonTransitioningAnimation extends StatelessWidget {
  TransitionButtonTransitioningAnimation(
      {this.controller, this.color, this.margin})
      : width = Tween<double>(begin: 320.0, end: 1000.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.500, curve: Curves.ease),
          ),
        ),
        height = Tween<double>(begin: 50.0, end: 1000.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.500, curve: Curves.ease),
          ),
        ),
        marginAnimation = Tween<EdgeInsets>(
          begin: margin,
          end: EdgeInsets.all(0.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.250, curve: Curves.ease),
          ),
        ),
        borderRadius = Tween<BorderRadius>(
          begin: BorderRadius.all(Radius.circular(30.0)),
          end: BorderRadius.all(Radius.zero),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.500, curve: Curves.ease),
          ),
        );

  final Animation controller;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> marginAnimation;
  final Animation<BorderRadius> borderRadius;
  final Color color;
  final EdgeInsets margin;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      margin: this.marginAnimation.value,
      width: this.width.value,
      height: this.height.value,
      child: RaisedButton(
        onPressed: () {},
        color: this.color,
        shape: RoundedRectangleBorder(borderRadius: this.borderRadius.value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        builder: this._buildAnimation, animation: this.controller);
  }
}

enum ButtonStatus { Inicial, Normal, Loading, Transiting }
