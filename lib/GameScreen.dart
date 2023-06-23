import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'itemModel.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final player = AudioPlayer();
  late List<ItemModel> items;
  late List<ItemModel> items2;
  late int score;
  late bool gameOver;

  initGame() {
    gameOver = false;
    score = 0;
    items = [
      ItemModel(value: 'crying', name: 'Crying', img: 'assets/Game/crying.png'),
      ItemModel(value: 'sad', name: 'Sad', img: 'assets/Game/sad.png'),
      ItemModel(value: 'happy', name: 'Happy', img: 'assets/Game/happy.png'),
      ItemModel(value: 'Laugh', name: 'Laughing', img: 'assets/Game/Laugh.png'),
      ItemModel(value: 'love', name: 'Lovely', img: 'assets/Game/love.png'),
      ItemModel(value: 'sleepy', name: 'Sleepy', img: 'assets/Game/sleepy.png'),
      ItemModel(value: 'Fear', name: 'Fear', img: 'assets/Game/Fear.png'),
      ItemModel(value: 'angry', name: 'Angry', img: 'assets/Game/angry.png'),
    ];
    items2 = List<ItemModel>.from(items);

    items.shuffle();
    items2.shuffle();
  }

  @override
  void initState() {
    super.initState();
    initGame();
  }

  @override
  Widget build(BuildContext context) {
    if (items.length == 0) gameOver = true;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'Game',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                          text: 'Score : ',
                          style: TextStyle(
                            fontSize: 25.0,
                          )),
                      TextSpan(
                          text: '$score',
                          style: const TextStyle(
                              fontSize: 30.0,
                              color: Colors.teal,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              if (!gameOver)
                Row(
                  children: [
                    Spacer(),
                    Column(
                      children: items.map((item) {
                        return Container(
                          margin: EdgeInsets.all(5),
                          child: Draggable<ItemModel>(
                            data: item,
                            childWhenDragging: CircleAvatar(
                              backgroundColor: Colors.grey[500],
                              backgroundImage: AssetImage(item.img),
                              radius: 50,
                            ),
                            feedback: CircleAvatar(
                              backgroundColor: Colors.grey[500],
                              backgroundImage: AssetImage(item.img),
                              radius: 30,
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[500],
                              backgroundImage: AssetImage(item.img),
                              radius: 30,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Spacer(flex: 2),
                    Column(
                      children: items2.map((item) {
                        return DragTarget<ItemModel>(
                          onAccept: (receivedItem) {
                            if (item.value == receivedItem.value) {
                              setState(() {
                                items.remove(receivedItem);
                                items2.remove(item);
                              });
                              score += 10;
                              item.accepting = false;

                              player.play(AssetSource('Game/true.wav'));
                            } else {
                              setState(() {
                                score -= 10;
                                item.accepting = false;
                                player.play(AssetSource('Game/wrong.wav'));
                              });
                            }
                          },
                          onWillAccept: (receivedItem) {
                            setState(() {
                              item.accepting = true;
                            });
                            return true;
                          },
                          onLeave: (receivedItem) {
                            setState(() {
                              item.accepting = false;
                            });
                          },
                          builder: (context, acceptedItems, rejectedItems) =>
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: item.accepting
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                  ),
                                  alignment: Alignment.center,
                                  height:
                                      MediaQuery.of(context).size.width / 6.5,
                                  width: MediaQuery.of(context).size.width / 3,
                                  margin: EdgeInsets.all(8),
                                  child: Text(
                                    item.name,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  )),
                        );
                      }).toList(),
                    ),
                    Spacer(),
                  ],
                ),
              if (gameOver)
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Game Over',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          result(),
                          style: const TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              if (gameOver)
                Container(
                  height: MediaQuery.of(context).size.width / 10,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          initGame();
                        });
                      },
                      child: const Text(
                        'New Game',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                )
            ],
          ),
        ),
      ),
    );
  }

  //Functions:

  String result() {
    if (score == 80) {
      player.play(AssetSource('Game/yay.wav'));
      return 'Awesome!';
    } else {
      player.play(AssetSource('Game/fail.wav'));
      return 'You can do better!';
    }
  }
}
