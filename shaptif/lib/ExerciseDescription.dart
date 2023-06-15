import 'package:flutter/material.dart';
import 'package:shaptif/db/database_manager.dart';
import 'package:shaptif/db/exercise.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Description extends StatefulWidget {
  final Exercise exercise;
  final List<Exercise> exercises;

  const Description({Key? key, required this.exercise, required this.exercises})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => DescriptionViewState();
}

class DescriptionViewState extends State<Description> {
  late Map<String, bool> images;
  bool canBeDeleted = false;
  bool isLoading = false;
  bool _showQRCode = false;

  @override
  void initState() {
    super.initState();
    getCanBeDeleted();
    images = widget.exercise.imageHashToMap();
  }

  Future getCanBeDeleted() async {
    setState(() => isLoading = true);
    canBeDeleted = await widget.exercise.canBeDeleted();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          centerTitle: true,
          title: Text(
            widget.exercise.name, //Maksimum 20 znaków
            style: const TextStyle(
                fontFamily: 'Audiowide',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 26),
          ),
          backgroundColor: const Color.fromARGB(255, 28, 27, 27),
          // shape: const RoundedRectangleBorder(
          //     borderRadius: BorderRadius.only(
          //         bottomRight: Radius.circular(20),
          //         bottomLeft: Radius.circular(20)),
          //     side: BorderSide(
          //       width: 1,
          //       color: Colors.black,
          //       //style: BorderStyle.none
          //     )),
          automaticallyImplyLeading: false,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    for (var key in images.keys)
                      ColorFiltered(
                        colorFilter: images[key]!
                            ? const ColorFilter.mode(Colors.red, BlendMode.srcATop)
                            : const ColorFilter.mode(
                            Colors.transparent, BlendMode.srcATop),
                        child: Image.asset(
                          "images/body_parts/" + key + ".png",
                          fit: BoxFit.contain,
                          height: 250,
                        ),
                      ),
                  ],
                ),
              ),
              if (!isLoading && canBeDeleted)
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Usuwanie ćwiczenia"),
                          content: Text("Czy na pewno chcesz usunąć ćwiczenie?"),
                          actions: <Widget>[
                            TextButton(
                              child: Text("Anuluj"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                                deleteExercise();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              if (!isLoading && !widget.exercise.isEmbedded)
                IconButton(
                  icon: Icon(Icons.mobile_screen_share),
                  onPressed: () {
                    setState(() {
                      _showQRCode = !_showQRCode;
                    });
                  },
                ),
              if (_showQRCode)
                QrImage(
                  data: widget.exercise.toQR(),
                  version: QrVersions.auto,
                  size: 150,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              SizedBox(
                height: 32,
              ),
              Divider(),
              const SizedBox(height: 24.0),
              Text(
                'Main body part : ',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.left,
              ),
             // const SizedBox(height: 24.0),
              Text(
                widget.exercise.bodyPartString!,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 24.0),
              Text(
                'Description :',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.left,
              ),
              //const SizedBox(height: 8.0),
              Text(
                widget.exercise.description,
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "ReturnButton",
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: const Color.fromARGB(255, 166, 16, 16),
        shape: const CircleBorder(),
        child: const Icon(Icons.keyboard_backspace),
      ),
    );
  }

  Future deleteExercise() async {
    setState(() => isLoading = true);
    await DatabaseManger.instance.delete(widget.exercise);

    widget.exercises.removeWhere((element) => element == widget.exercise);

    Navigator.of(context).pop();
  }
}
