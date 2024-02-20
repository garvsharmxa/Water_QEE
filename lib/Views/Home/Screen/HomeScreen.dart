import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCalculation = 'Chlorophyll'; // Default value
  DateTime selectedStartDate = DateTime(2020, 10, 1);
  DateTime selectedEndDate = DateTime.now();

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedStartDate != null && pickedStartDate != selectedStartDate) {
      setState(() {
        selectedStartDate = pickedStartDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedEndDate = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedEndDate != null && pickedEndDate != selectedEndDate) {
      setState(() {
        selectedEndDate = pickedEndDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Quality Monitoring'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Select start date'),
            _buildDateButton(selectedStartDate, _selectStartDate),
            SizedBox(height: 20),
            _buildHeader('Select end date'),
            _buildDateButton(selectedEndDate, _selectEndDate),
            _buildHeader('Region Of Interest'),
            _buildButtonsRow(),
            SizedBox(height: 20),
            _buildHeader('Calculation to be performed'),
            _buildDropdownButton(),
            SizedBox(height: 20),
            _buildElevatedButton('Submit', Colors.blue),
            SizedBox(height: 10),
            _buildElevatedButton('Clear Map', Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 18),
    );
  }

  Widget _buildDateButton(DateTime date, Function(BuildContext) onTap) {
    return InkWell(
      onTap: () {
        onTap(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3), // changes the position of shadow
            ),
          ],
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlue],
          ),
        ),
        child: Text(
          '${date.toLocal()}'.split(' ')[0],
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      children: [
        _buildButton('Rectangle', Colors.green),
        SizedBox(width: 10),
        _buildButton('Polygon', Colors.orange),
      ],
    );
  }

  Widget _buildButton(String text, Color color) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3), // changes the position of shadow
            ),
          ],
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.8)],
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownButton() {
    return DropdownButton<String>(
      value: selectedCalculation,
      onChanged: (value) {
        setState(() {
          selectedCalculation = value!;
        });
      },
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      elevation: 5, // Add elevation for a 3D effect
      icon: Icon(
        Icons.arrow_drop_down,
        size: 30,
        color: Colors.blue, // Customize the dropdown arrow color
      ),
      items: ['Chlorophyll', 'Turbidity', 'TSS', 'Sentinel 2 RGB']
          .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ),
      )
          .toList(),
    );
  }

  Widget _buildElevatedButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {
        // Implement the submit or clear map button logic here
      },
      style: ElevatedButton.styleFrom(
        elevation: 5, // Add elevation for a 3D effect
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: color, // Customize the button color
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
