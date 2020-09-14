import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';

class PlayingCard {
  int num;
  String suit;
  SvgPicture pic;

  PlayingCard(this.num, this.suit) {
    Map map = {1 : 'A', 2: '2', 3: '3', 4 : '4', 5: '5', 6: '6' , 7: '7', 8: '8', 9: '9', 10: '10', 11: 'J', 12: 'Q', 13: 'K'};
    String path = 'assets/cards/' +  map[num] + this.suit[0] + '.svg';
    pic = SvgPicture.asset(path);
  }

  SvgPicture card() {
    // Map map = {1 : 'ace', 2: 'two', 3: 'three', 4 : 'four', 5: 'five', 6: 'six' , 7: 'seven', 8: 'eight', 9: 'nine', 10: 'ten', 11: 'jack', 12: 'queen', 13: 'king'};
    // String path = 'assets/cards/' + this.suit.toLowerCase() + '-' + map[num] + '.svg';
    // SvgPicture res = SvgPicture.asset(path);
    // return res;

    // Map map = {1 : 'A', 2: '2', 3: '3', 4 : '4', 5: '5', 6: '6' , 7: '7', 8: '8', 9: '9', 10: '10', 11: 'J', 12: 'Q', 13: 'K'};
    // String path = 'assets/cards/' +  map[num] + this.suit[0] + '.svg';
    // SvgPicture res = SvgPicture.asset(path);
    return this.pic;
  }

  String toString() {
    String n = num.toString();

    if (num == 1) {
      n = 'Ace';
    }
    if (num == 11) {
      n = 'Jack';
    }
    if (num == 12) {
      n = 'Queen';
    }
    if (num == 13) {
      n = 'King';
    }

    return n + ' of ' + suit;
  }
}

class DeckofCards {
  List<PlayingCard> deck = [];

  DeckofCards() {
    var suits = ['Clubs', 'Hearts', 'Diamonds', 'Spades'];

    for (int k = 0; k < 4; k++) {
      for (int i = 0; i < 13; i++) {
//         deck[(k * 13) + i] = new PlayingCard(i + 1, suits[k]);
        deck.add(new PlayingCard(i + 1, suits[k]));
      }
    }
  }

  PlayingCard deal() {
    return deck.removeAt(0);
  }

  void shuffle() {
    var rng = new Random();

    for (int i = 0; i < 1000; i++) {
      var r1 = rng.nextInt(deck.length);
      var r2 = rng.nextInt(deck.length);

      var temp = deck[r1];
      deck[r1] = deck[r2];
      deck[r2] = temp;
    }
  }
}

class BlackJack {
  List<PlayingCard> dealer = [];
  List<PlayingCard> player = [];
  DeckofCards deck;
  int playerCash = 1000;
  int playerBet = 0;

  BlackJack(this.playerCash) {
    DeckofCards newDeck = new DeckofCards();
    deck = newDeck;
    newDeck.shuffle();
  }

  void newGame() {
    dealer.clear();
    player.clear();

    DeckofCards newDeck = new DeckofCards();
    deck = newDeck;
    newDeck.shuffle();
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

  void bet(int betAmount) {
    playerBet = betAmount;
  }

  void initialDeal() {
    player.add(deck.deal());
    player.add(deck.deal());

    dealer.add(deck.deal());
    dealer.add(deck.deal());
  }

  void hit() {
    player.add(deck.deal());
  }
}

void main() {
  print('BlackJack !!!');

  BlackJack bj = new BlackJack(1000);

//   int value = bj.handValue([new PlayingCard(1, "Clubs"), new PlayingCard(13, "Diamonds")]);

  for (int i = 0; i < 10; i++) {
    print("BlackJack Game:");
    bj.initialDeal();
    bj.printState();

    while (bj.handValue(bj.player) <= 21) {
      print("Hit");
      bj.hit();
      bj.printState();
    }
    
    bj.newGame();
  }
}
