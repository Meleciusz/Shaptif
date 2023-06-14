import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shaptif/HistoryDetails.dart';
import 'package:shaptif/db/finished_training.dart';
import 'package:shaptif/db/history.dart';

import 'db/database_manager.dart';
//TODO: Poprawne wyświetlanie historii (Nazwa / data reningu)
//TODO:Przejście do nowego ekrau i okodowanie go

class HistoryView extends StatefulWidget {
  final List<FinishedTraining> finishedTraining;
  final Map<DateTime, List<FinishedTraining>> filteredExercises;
  const HistoryView({Key? key , required this.finishedTraining , required this.filteredExercises}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HistoryViewState();
}

class HistoryViewState extends State<HistoryView> {
  TextEditingController editingController = TextEditingController();

  bool isLoading = false;
  int ?ID = null;
  int ?i= null;
  String ?selectedIconKey;
  late var items = <FinishedTraining>[];
  DateTime currentDate = DateTime.now();
  List<int> indexes = [];

  @override
  void initState() {
    super.initState();
    items = widget.finishedTraining;
  }





  Map<DateTime, IconData> getIconsMap(){
    Map<DateTime, IconData> iconsMap = {
      currentDate : Icons.calendar_today ,
      currentDate.subtract(Duration(days: 7)) : Icons.calendar_today_outlined ,
      currentDate.subtract(Duration(days: 31)) : Icons.calendar_month_rounded ,
      currentDate.subtract(Duration(days: 186)) : Icons.calendar_month_outlined ,
    };
    return iconsMap;
  }


  void filterSearchResults(value) {
    setState(() {
      items = widget.finishedTraining
          .where((item) => item.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value){
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular((25.0)))
                    )
                ),
              ),
            ),
            Expanded(
              child: isLoading ? notLoaded() : ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => HistoryDetails(
                                  ID: items[index].id,
                                  i: index
                              )));
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment:  MainAxisAlignment.center,
                          children: [
                            Text(items[index].finishedDateTime.toString().substring(0, 16),
                                style: TextStyle(
                                    fontFamily: 'Audiowide',
                                    fontSize: 17)),
                            SizedBox(height: 16),
                            Text(
                                items[index].name,
                                style: TextStyle(
                                    fontFamily: 'Audiowide',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25)),
                            SizedBox(height: 8),
                            Text(items[index].description,
                                style: TextStyle(
                                  //fontFamily: 'Audiowide',
                                    fontSize: 10)),

                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
        drawer: Drawer(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Filters',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                          Icons.filter_list
                      )
                    ],
                  )
              ),
              Divider(),
              ...getIconsMap().keys.map((key) {
                final IconData? iconData = getIconsMap()[key];
                final bool isSelected = (key == selectedIconKey);

                return ListTile(
                  leading: Icon(
                    iconData,
                    color: isSelected ? Colors.blue : null, // Koloruj klikniętą ikonę na niebiesko
                  ),
                  title: Text('$key'),
                  onTap: () {
                    setState(() {
                      //selectedIconKey = key; // Ustaw wybrany klucz ikony
                      indexes.clear();
                      items.clear();
                      List<MapEntry<DateTime, IconData>> lista = getIconsMap().entries.toList();
                      //int kaka = lista.indexWhere((element) => (element.key.day == key.day) && (element.key.month == key.month) && (element.key.year == key.year));
                      //int kaka = lista.indexWhere((element) => element.key.isAfter(key));
                      lista.asMap().forEach((index, entry) {
                        if(entry.key.isAfter(key)){
                          items.add(widget.filteredExercises.values.elementAt(index).elementAt(0));
                        }
                      }); //TODO: pozmieniaj daty na inne
                      //GOODDDD    items = filteredExercises.values.elementAt(kaka);
                    });
                  },
                );
              }).toList(),
            ],
          ),
        )
    );
  }

  Text notLoaded() {
    return const Text(
      "ładuje sie",
      style: TextStyle(
          fontFamily: 'Audiowide',
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20),
    );
  }
}
