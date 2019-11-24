import 'package:flutter/material.dart';

class PlayPage extends StatefulWidget {
  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {

  List<List<String>> arrangement = [
    ["kirin_enemy","lion_enemy","elephant_enemy"],
    ["","chick_enemy",""],
    ["","chick_ally",""],
    ["elephant_ally","lion_ally","kirin_ally"]
  ];

  List<String> allyCapturedPiece = [];
  List<String> enemyCapturedPiece = [];

  List<List<bool>> overlay;

  initState() {
    super.initState();
    clearOverlays();
  }

  PieceInfo _selected;

  bool _isAllyTurn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Align(
            alignment: Alignment.center,
            child: AspectRatio(
              aspectRatio: 3 / 5,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.cyan,
                  child: SizedBox.expand(
                      child: Stack(
                          children: arrangement.indexedMap((i, list) {
                            return list.indexedMap((j, String item) {
                              return positionedCard(i, j, item);
                            }).where((s) => s != null);
                          }).expand((s) => s).toList()..addAll(
                              overlay.indexedMap((i, list) {
                                return list.indexedMap((j, bool item) {
                                  return item ? positionedOverlay(i, j) : null;
                                }).where((s) => s != null);
                              }).expand((s) => s).toList()
                          )..add(allyHand())..add(enemyHand())
                      )
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }

  Widget positionedCard(int row, int column, String title) {
    if(row > 4 || column > 2) return Text("error");
    if(title.isEmpty) return null;

    return new Positioned.fill(
        child: new LayoutBuilder(
          builder: (context, constraints) {
            return new Padding(
              padding: new EdgeInsets.only(
                top: constraints.biggest.height * (row + 0.5) / 5, bottom: constraints.biggest.height * (3.5 - row) / 5,
                left: constraints.biggest.width * column / 3, right: constraints.biggest.width * (2-column) / 3,
              ),
              child: Card(
                child: InkWell(
                    onTap: _isAllyTurn == title.contains("ally")
                        ? () {
                      _selected = PieceInfo(title, row, column);
                      setState(() {
                        setOverlays(row, column, title);
                      });
                    }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: piece2LargeImage(title),
                    )
                ),
                color: cardColor(title),
              ),
            );
          },
        )
    );
  }

  void setOverlays(int row, int column, String title) {
    clearOverlays();
    if(row == null) {
      var rowStart = 0;
      var rowEnd = 3;

      if(title == "chick_ally")
        rowStart = 1;
      if(title == "chick_enemy")
        rowEnd = 2;

      for(int i = rowStart; i <= rowEnd; i++) {
        for(int j = 0; j <= 2; j++) {
          setOverlayTo(i, j, null);
        }
      }
      return;
    }

    if(title.contains("lion")) { //ライオン
      setOverlayTo(row - 1, column - 1, title);
      setOverlayTo(row - 1, column, title);
      setOverlayTo(row - 1, column + 1, title);
      setOverlayTo(row, column - 1, title);
      setOverlayTo(row, column + 1, title);
      setOverlayTo(row + 1, column - 1, title);
      setOverlayTo(row + 1, column, title);
      setOverlayTo(row + 1, column + 1, title);
    }
    else if(title.contains("elephant")) { //ゾウ
      setOverlayTo(row - 1, column - 1, title);
      setOverlayTo(row - 1, column + 1, title);
      setOverlayTo(row + 1, column - 1, title);
      setOverlayTo(row + 1, column + 1, title);
    }
    else if(title.contains("kirin")) { //キリン
      setOverlayTo(row - 1, column, title);
      setOverlayTo(row, column - 1, title);
      setOverlayTo(row, column + 1, title);
      setOverlayTo(row + 1, column, title);
    }
    else if(title == "chicken_ally") { //味方チキン
      setOverlayTo(row - 1, column - 1, title);
      setOverlayTo(row - 1, column, title);
      setOverlayTo(row - 1, column + 1, title);
      setOverlayTo(row, column - 1, title);
      setOverlayTo(row, column + 1, title);
      setOverlayTo(row + 1, column, title);
    }
    else if(title == "chicken_enemy") { //敵チキン
      setOverlayTo(row - 1, column, title);
      setOverlayTo(row, column - 1, title);
      setOverlayTo(row, column + 1, title);
      setOverlayTo(row + 1, column - 1, title);
      setOverlayTo(row + 1, column, title);
      setOverlayTo(row + 1, column + 1, title);
    }
    else if(title == "chick_ally") { //味方ヒヨコ
      setOverlayTo(row - 1, column, title);
    }
    else if(title == "chick_enemy") { //敵ヒヨコ
      setOverlayTo(row + 1, column, title);
    }
    else {
      print("unknown Name $title");
    }
  }

  void clearOverlays() {
    overlay = [
      [false,false,false],
      [false,false,false],
      [false,false,false],
      [false,false,false],
    ];
  }

  void setOverlayTo(int row, int column, String title) {
    if(row < 0 || row > 3 || column < 0 || column > 2) return;
    if(title == null) {
      if(arrangement[row][column].isEmpty) {
        overlay[row][column] = true;
      }
      return;
    }
    final isAlly = title.contains("ally");

    if(arrangement[row][column].isEmpty || arrangement[row][column].contains("ally") != isAlly) {
      print("setOverlay to $row:$column");
      overlay[row][column] = true;
    }
  }

  Widget positionedOverlay(int row, int column) {
    if(row > 3 || column > 2) return Text("error");

    return new Positioned.fill(
        child: new LayoutBuilder(
          builder: (context, constraints) {
            return new Padding(
                padding: new EdgeInsets.only(
                  top: constraints.biggest.height * (row + 0.5) / 5, bottom: constraints.biggest.height * (3.5 - row) / 5,
                  left: constraints.biggest.width * column / 3, right: constraints.biggest.width * (2-column) / 3,
                ),
                child: SizedBox.expand(
                  child: InkWell(
                    onTap: () {
                      print("$row:$column");

                      setState(() {
                        if(arrangement[row][column] != "") {
                          final isAlly = _selected.title.contains("ally");
                          if(arrangement[row][column].contains("lion")) {
                            showResult(isAlly, context);
                          }

                          if(isAlly)
                            allyCapturedPiece.add(arrangement[row][column].replaceAll("enemy", "ally").replaceAll("chicken", "chick"));
                          else
                            enemyCapturedPiece.add(arrangement[row][column].replaceAll("ally", "enemy").replaceAll("chicken", "chick"));
                        }

                        if(_selected.title == "lion_ally" && row == 0) {
                          if(judgeNyugyoku(true, column))
                            showResult(true, context);
                        }
                        else if(_selected.title == "lion_enemy" && row == 3) {
                          if(judgeNyugyoku(false, column))
                            showResult(false, context);
                        }

                        //移動元の削除
                        if(_selected.isAllyCapturedPiece == true) {
                          allyCapturedPiece.remove(_selected.title);
                        }
                        else if(_selected.isAllyCapturedPiece == false) {
                          enemyCapturedPiece.remove(_selected.title);
                        }
                        else {
                          arrangement[_selected.row][_selected.column] = "";
                        }

                        //移動先の登録
                        if(_selected.title == "chick_ally" && row == 0) {
                          arrangement[row][column] = "chicken_ally";
                        }
                        else if(_selected.title == "chick_enemy" && row == 3) {
                          arrangement[row][column] = "chicken_enemy";
                        }
                        else {
                          arrangement[row][column] = _selected.title;
                        }


                        _isAllyTurn = _selected.title.contains("enemy");


                        _selected = null;
                        clearOverlays();
                      });
                    },
                    child: Container(
                      color: Color(0x400000ff),
                    ),
                  ),
                )
            );
          },
        )
    );
  }

  Widget allyHand() {
    return new Positioned.fill(
        child: new LayoutBuilder(
          builder: (context, constraints) {
            return new Padding(
                padding: new EdgeInsets.only(
                  top: constraints.biggest.height * 4.5 / 5,
                ),
                child: SizedBox.expand(
                    child: Row(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 1 / 2,
                          child: Card(
                            color: _isAllyTurn ? Colors.red : Colors.white,
                          ),
                        ),
                        Expanded(
                            child: Row(
                              children: allyCapturedPiece.map((piece) {
                                return SizedBox(
                                  height: double.infinity,
                                  child: Card(
                                    child: InkWell(
                                        onTap: _isAllyTurn
                                            ? () {
                                          _selected = PieceInfo(piece, null, null, isAllyCapturedPiece: true);
                                          setState(() {
                                            setOverlays(null, null, piece);
                                          });
                                        }
                                            : null,
                                        child: piece2SmallImage(piece)
                                    ),
                                    color: cardColor(piece),
                                  ),
                                );
                              }).toList(),
                            )
                        )
                      ],
                    )
                )
            );
          },
        )
    );
  }

  Widget enemyHand() {
    return new Positioned.fill(
        child: new LayoutBuilder(
          builder: (context, constraints) {
            return new Padding(
                padding: new EdgeInsets.only(
                  bottom: constraints.biggest.height * 4.5 / 5,
                ),
                child: SizedBox.expand(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Row(
                              children: enemyCapturedPiece.map((piece) {
                                return SizedBox(
                                    height: double.infinity,
                                    child: Card(
                                      child: InkWell(
                                          onTap: !_isAllyTurn
                                              ? () {
                                            _selected = PieceInfo(piece, null, null, isAllyCapturedPiece: false);
                                            setState(() {
                                              setOverlays(null, null, piece);
                                            });
                                          }
                                              : null,
                                          child: piece2SmallImage(piece)
                                      ),
                                      color: cardColor(piece),
                                    )
                                );
                              }).toList(),
                            )
                        ),
                        AspectRatio(
                          aspectRatio: 1 / 2,
                          child: Card(
                            color: _isAllyTurn ? Colors.white : Colors.red,
                          ),
                        ),
                      ],
                    )
                )
            );
          },
        )
    );
  }

  void showResult(bool win, context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("結果"),
          content: win
              ? Text("あなたの勝ち❗")
              : Text("あなたの負け..."),
          actions: <Widget>[
            FlatButton(
              child: Text("Back"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("終わる"),
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            )
          ],
        )
    );
  }

  bool judgeNyugyoku(bool isAlly, int column) {
    if(isAlly) {
      return !checkIsPiece(0, column - 1, ["lion_enemy", "kirin_enemy"])
          && !checkIsPiece(0, column + 1, ["lion_enemy", "kirin_enemy"])
          && !checkIsPiece(1, column, ["lion_enemy", "kirin_enemy"])
          && !checkIsPiece(1, column - 1, ["lion_enemy", "elephant_enemy"])
          && !checkIsPiece(1, column + 1, ["lion_enemy", "elephant_enemy"]);
    }
    else {
      return !checkIsPiece(3, column - 1, ["lion_ally", "kirin_ally"])
          && !checkIsPiece(3, column + 1, ["lion_ally", "kirin_ally"])
          && !checkIsPiece(2, column, ["lion_ally", "kirin_ally"])
          && !checkIsPiece(2, column - 1, ["lion_ally", "elephant_ally"])
          && !checkIsPiece(2, column + 1, ["lion_ally", "elephant_ally"]);
    }
  }

  bool checkIsPiece(int row, int column, List<String> titles) {
    if(row < 0 || row > 3 || column < 0 || column > 2) return false;

    return titles.any((t) => t == arrangement[row][column]);
  }
}

extension Indexmapper<T> on List<T> {
  List<E> indexedMap<E>(E function(int index, T item)) {
    List<E> res = [];
    for(int i = 0; i < this.length; i++) {
      res.add(function(i, this[i]));
    }
    return res;
  }
}

class PieceInfo {
  String title;
  int row;
  int column;
  bool isAllyCapturedPiece;

  PieceInfo(this.title, this.row, this.column, {this.isAllyCapturedPiece});
}

Widget piece2LargeImage(String title) {
  switch(title) {
    case "lion_ally":
      return Image.asset("image/lion_large.png");
    case "lion_enemy":
      return RotatedBox(quarterTurns: 2, child: Image.asset("image/lion_large.png"),);
    case "kirin_ally":
      return Image.asset("image/kirin_large.png");
    case "kirin_enemy":
      return RotatedBox(quarterTurns: 2, child: Image.asset("image/kirin_large.png"),);
    case "elephant_ally":
      return Image.asset("image/elephant_large.png");
    case "elephant_enemy":
      return RotatedBox(quarterTurns: 2, child: Image.asset("image/elephant_large.png"),);
    case "chick_ally":
      return Image.asset("image/chick_large.png");
    case "chick_enemy":
      return RotatedBox(quarterTurns: 2, child: Image.asset("image/chick_large.png"),);
    case "chicken_ally":
      return Image.asset("image/chicken_large.png");
    case "chicken_enemy":
      return RotatedBox(quarterTurns: 2, child: Image.asset("image/chicken_large.png"),);
  }
  return Text("error");
}

Widget piece2SmallImage(String title) {
  switch(title) {
    case "lion_ally":
      return Image.asset("image/lion_small.png");
    case "lion_enemy":
      return RotatedBox(quarterTurns: 2, child: Image.asset("image/lion_small.png"),);
    case "kirin_ally":
      return Image.asset("image/kirin_small.png");
    case "kirin_enemy":
      return RotatedBox(quarterTurns: 2, child: Image.asset("image/kirin_small.png"),);
    case "elephant_ally":
      return Image.asset("image/elephant_small.png");
    case "elephant_enemy":
      return RotatedBox(quarterTurns: 2, child: Image.asset("image/elephant_small.png"),);
    case "chick_ally":
      return Image.asset("image/chick_small.png");
    case "chick_enemy":
      return RotatedBox(quarterTurns: 2, child: Image.asset("image/chick_small.png"),);
    case "chicken_ally":
      return Image.asset("image/chicken_small.png");
    case "chicken_enemy":
      return RotatedBox(quarterTurns: 2, child: Image.asset("image/chicken_small.png"),);
  }
  return Text("error");
}

Color cardColor(String title) {
  if(title.contains("lion"))
    return Color(0xffF48FB1);
  else if(title.contains("kirin") || title.contains("elephant"))
    return Color(0xffB39DDB);
  else
    return Color(0xffC5E1A5);
}