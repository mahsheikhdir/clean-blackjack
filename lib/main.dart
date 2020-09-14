import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'blackjack.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  runApp(MaterialApp(
      theme: ThemeData.dark(),
      home: StartMenu(),
      debugShowCheckedModeBanner: false));
}

class BlackJackModel extends ChangeNotifier {
  DeckofCards currentDeck;

  List<PlayingCard> dealer = [];
  List<PlayingCard> player = [];

  BlackJackModel() {
    newGame();
  }

  void newGame() {
    print("New Gmae");
    currentDeck = new DeckofCards();
    currentDeck.shuffle();

    dealer.clear();
    player.clear();

    dealer.add(currentDeck.deal());
    dealer.add(currentDeck.deal());

    player.add(currentDeck.deal());
    player.add(currentDeck.deal());

    print("Inside model" + dealer.toString() + player.toString());

    notifyListeners();
  }

  void printState() {
    print("Dealer: " + handValue(dealer).toString() + " " + dealer.toString());
    print("Player: " + handValue(player).toString() + " " + player.toString());
  }

  int handValue(List<PlayingCard> hand) {
    int value = 0;
    int numOfAces = 0;

    for (PlayingCard pc in hand) {
      if (pc.num == 1) {
        numOfAces += 1;
      } else if (pc.num >= 10) {
        value += 10;
      } else {
        value += pc.num;
      }
    }

    if (numOfAces == 1) {
      if ((value + 11) <= 21) {
        return value + 11;
      } else {
        return value + 1;
      }
    } else if (numOfAces > 1) {
      return value += numOfAces;
    }

    return value;
  }

  void initialDeal() {
    player.add(currentDeck.deal());
    player.add(currentDeck.deal());

    dealer.add(currentDeck.deal());
    dealer.add(currentDeck.deal());
  }

  void hit(String p) {
    if (p == "Player") {
      player.add(currentDeck.deal());
    }

    if (p == "Dealer") {
      dealer.add(currentDeck.deal());
    }

    notifyListeners();
  }

  void stand() {
    while (handValue(dealer) < 17) {
      hit("Dealer");
    }

    notifyListeners();
  }
}

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  bool gameEnd = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<BlackJackModel>(
        builder: (context, bj, _) => GestureDetector(
              onTap: () {
                if (gameEnd) {
                  setState(() => gameEnd = false);
                  bj.newGame();
                  print("new game");
                } else {
                  bj.hit("Player");
                  if (bj.handValue(bj.player) >= 21) {
                    setState(() => gameEnd = true);
                  }
                  print("Player Hit" + bj.handValue(bj.player).toString());
                }
              },
              onDoubleTap: () {
                bj.stand();
                setState(() => gameEnd = true);
                print("stand");
              },
              child: Scaffold(
                body: Stack(
                  children: [
                    Hand(hand: bj.player, isPlayer: true),
                    Hand(hand: bj.dealer, isPlayer: false),
                    Positioned(
                      right: 10,
                      top: 100,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        width: 100,
                        height: 100,
                        child: Text(
                          bj.handValue(bj.dealer).toString(),
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 100,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        width: 100,
                        height: 100,
                        child: Text(
                          bj.handValue(bj.player).toString(),
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}

class Hand extends StatefulWidget {
  final List<PlayingCard> hand;
  final bool isPlayer;

  Hand({Key key, @required this.hand, @required this.isPlayer})
      : super(key: key);

  @override
  _HandState createState() => _HandState();
}

class _HandState extends State<Hand> {
  List<PlayingCard> hand;
  double change = 0.0;
  double top;
  double bot;

  @override
  void initState() {
    super.initState();
    // print(this.hand);
    setState(() {
      print(widget.hand);
      hand = widget.hand;
      if (widget.isPlayer) {
        top = null;
        bot = 0;
      } else {
        top = 0;
        bot = null;
      }

    });
  }

  @override
  void didUpdateWidget(covariant Hand oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() => change = 0);
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> cards = [];

    for(PlayingCard c in widget.hand) {
      cards.add(Positioned(
                    top: top,
                    bottom: bot,
                    left: change,
                    child: MenuCard(pc: c, position: 0,)));

      change += 30;
    }

    return Stack(
        children: cards,
    );
  }
}

class RegularCard extends StatefulWidget {
  final SvgPicture sp;

   RegularCard({Key key, @required this.sp})
      : super(key: key);


  @override
  _RegularCardState createState() => _RegularCardState();
}

class _RegularCardState extends State<RegularCard> {
  SvgPicture sp;
  double opacityLevel;

  @override
  void initState() {
    super.initState();
    setState(() {
      sp = widget.sp;
      opacityLevel = 0.0; }
      );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {setState(() => opacityLevel = 1.0)},
      child: AnimatedOpacity(
      duration: Duration(seconds: 2),
      opacity: opacityLevel,
      child: Container(
      height: 300,
      child: sp
    ),));
  }
}

class StartMenu extends StatefulWidget {
  @override
  _StartMenuState createState() => _StartMenuState();
}

class _StartMenuState extends State<StartMenu> {
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    setState(() => {opacity = 1.0});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: Duration(seconds: 1),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                  child: Stack(
                children: [
                  MenuCard(pc: PlayingCard(1, 'Clubs'), position: 0),
                  MenuCard(pc: PlayingCard(11, 'Spades'), position: 30),
                ],
              )),
            ),
            Center(
              child: Text(
                'Clean BlackJack',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
              ),
            ),
            Center(
                child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: OutlineButton(
                borderSide: BorderSide(width: 2.0),
                child: Text('Play'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChangeNotifierProvider<BlackJackModel>(
                                create: (context) => BlackJackModel(),
                                child: Game(),
                              )));
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                padding: EdgeInsets.fromLTRB(100.0, 0.0, 100.0, 0.0),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class MenuCard extends StatefulWidget {
  final PlayingCard pc;
  final double position;

  MenuCard({Key key, @required this.pc, @required this.position})
      : super(key: key);

  @override
  _MenuCardState createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  double angle = -math.pi / 2;
  double position;
  PlayingCard pc;

  @override
  void initState() {
    super.initState();
    setState(() {
      pc = widget.pc;
      position = widget.position;
    });
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.elasticOut)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _animationController.stop();
            } else if (status == AnimationStatus.dismissed) {
              _animationController.stop();
            }
          });
    _animationController.forward();
  }
  
  @override
  void didUpdateWidget(covariant MenuCard oldWidget) {
    // TODO: implement didUpdateWidget
    print('MenuState' + pc.toString());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _animationController.value = 0;
          _animationController.forward();
        });
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => Transform(
          transform: Matrix4.identity()
            ..translate(position, -position)
            ..scale(_animation.value)
            ..rotateZ(-angle)
            ..rotateZ(_animation.value * angle),
          child: Container(
            height: 300,
            child: widget.pc.card(),
          ),
        ),
      ),
    );
  }
}
