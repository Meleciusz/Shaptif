import 'package:flutter/material.dart';
import 'package:shaptif/db/training.dart';

class TrainingDetailsView extends StatefulWidget {
  final Training training;

  TrainingDetailsView({required this.training});

  @override
  _TrainingDetailsViewState createState() => _TrainingDetailsViewState();
}

class _TrainingDetailsViewState extends State<TrainingDetailsView> {
  bool isActive = false;

  @override
  void initState() {
    super.initState();
  }

  void _handleSetActive(bool active) {
    setState(() {
      isActive = active;
    });
    // zapisanie informacji o tym, że trening jest aktywny w bazie lub innym źródle danych
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.training.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.training.name,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              widget.training.description,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Aktywny:',
                  style: TextStyle(fontSize: 16.0),
                ),
                Switch(
                  value: isActive,
                  onChanged: _handleSetActive,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'AddTrainingButton',
            onPressed: () {
              // otwarcie nowego ekranu do dodawania nowego treningu
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 16.0),
          FloatingActionButton(
            heroTag: 'GoBackToTrainingList',
            onPressed: () {
              Navigator.pop(context, [isActive, widget.training.id!]);
            },
            child: Icon(Icons.arrow_back),
          ),
        ],
      ),
    );
  }
}


