import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:t8a/features/user_auth/presentation/widget/form_container_widget.dart';
import 'package:t8a/global/common/toast.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _WasteNameController = TextEditingController();
  final TextEditingController _WasteSourceController = TextEditingController();
  final TextEditingController _WasteVolume = TextEditingController();
  final TextEditingController _Wastedesc = TextEditingController();
  final TextEditingController _searchController =
      TextEditingController(); // Search controller
  WasteModel? selectedWasteModel;

  List<WasteModel> _wasteData = []; // List to store all waste data
  List<WasteModel> _filteredWaste = []; // List to store filtered waste data

  @override
  void initState() {
    super.initState();
    _readData(); // Fetch initial data
  }

  @override
  void dispose() {
    _WasteNameController.dispose();
    _WasteSourceController.dispose();
    _WasteVolume.dispose();
    _Wastedesc.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(196, 212, 218, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(196, 212, 218, 1),
        title: GestureDetector(
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Log Out",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: 1000,
          height: 800,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(35, 72, 72, 1),
                offset: Offset(0, 0),
                blurRadius: 15.0,
              )
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "input/edit waste data",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _WasteNameController,
                        decoration: new InputDecoration(
                            labelText: "Waste Name (max 20 characters)"),
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _WasteSourceController,
                        decoration: new InputDecoration(
                            labelText: "Waste Source (max 50 characters)"),
                        inputFormatters: [LengthLimitingTextInputFormatter(50)],
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _WasteVolume,
                        decoration: new InputDecoration(
                            labelText: "Waste Volume (value in kgs)"),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      SizedBox(height: 15),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _Wastedesc,
                        decoration: new InputDecoration(
                            labelText:
                                "Waste Description (max 100 characters)"),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(100)
                        ],
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: "Search by Waste Name",
                          prefixIcon: Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.grey.shade200, // Light gray color
                          contentPadding: EdgeInsets.all(10), // Adjust content padding if needed
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0), // Set border radius to 5px
                            borderSide: BorderSide(color: Colors.transparent), // Remove border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.transparent), // Remove border
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never
                        ),
                        onChanged: (value) => _searchWaste(value),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _createData(
                                WasteModel(
                                  wastename: _WasteNameController.text,
                                  wastesource: _WasteSourceController.text,
                                  wastevolume: int.parse(_WasteVolume.text),
                                  wastedesc: _Wastedesc.text,
                                ),
                              );
                              showToast(message: "Data Created");
                              clearFields();
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                            child: Text("Create Data"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (selectedWasteModel != null) {
                                _updateData(selectedWasteModel!);
                                showToast(message: "Data Edited");
                                clearFields();
                              } else {
                                showToast(
                                    message: "Please select a waste to edit");
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)))),
                            child: Text("Edit Data"),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: downloadWasteData,
                        child: Text("Copy Data"),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)))),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 50,
              ),
              Container(
                width: 2,
                height: double.infinity,
                color: Colors.grey,
              ),
              SizedBox(
                width: 50,
              ),
              Expanded(
                flex: 2, // Make the list section wider
                child: StreamBuilder<List<WasteModel>>(
                  stream: _readData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.data!.isEmpty) {
                      return Center(child: Text("No Data"));
                    }

                    // Check if there's a search term
                    if (_searchController.text.isNotEmpty) {
                      return ListView.builder(
                        itemCount: _filteredWaste.length,
                        itemBuilder: (context, index) {
                          final waste = _filteredWaste[index];
                          return ListTile(
                            leading: GestureDetector(
                              child: Icon(Icons.delete),
                              onTap: () {
                                _deleteData(waste.id!);
                                showToast(message: "Data Deleted");
                              },
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                // Update selectedWasteModel and pre-fill fields
                                setState(() {
                                  selectedWasteModel = waste;
                                  _WasteNameController.text =
                                      waste.wastename ?? "";
                                  _WasteSourceController.text =
                                      waste.wastesource ?? "";
                                  _WasteVolume.text =
                                      waste.wastevolume?.toString() ?? "";
                                  _Wastedesc.text = waste.wastedesc ?? "";
                                });
                              },
                              child: Icon(Icons.edit),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(waste.wastename ?? "No Name"),
                                Text(waste.wastesource ?? "No Source"),
                                Text(
                                    "Waste Volume: ${waste.wastevolume ?? 0} Kg"),
                                Text(waste.wastedesc ?? "No Description"),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      final users = snapshot.data;
                      return ListView.builder(
                        itemCount: users!.length,
                        itemBuilder: (context, index) {
                          final waste = users[index];
                          return ListTile(
                            leading: GestureDetector(
                              child: Icon(Icons.delete),
                              onTap: () {
                                _deleteData(waste.id!);
                                showToast(message: "Data Deleted");
                              },
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                // Update selectedWasteModel and pre-fill fields
                                setState(() {
                                  selectedWasteModel = waste;
                                  _WasteNameController.text =
                                      waste.wastename ?? "";
                                  _WasteSourceController.text =
                                      waste.wastesource ?? "";
                                  _WasteVolume.text =
                                      waste.wastevolume?.toString() ?? "";
                                  _Wastedesc.text = waste.wastedesc ?? "";
                                });
                              },
                              child: Icon(Icons.edit),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(waste.wastename ?? "No Name"),
                                Text(waste.wastesource ?? "No Source"),
                                Text(
                                    "Waste Volume: ${waste.wastevolume ?? 0} Kg"),
                                Text(waste.wastedesc ?? "No Description"),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<List<WasteModel>> _readData() async* {
    final wasteCollection = FirebaseFirestore.instance.collection("waste");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await wasteCollection.get();
    _wasteData = querySnapshot.docs
        .map((waste) => WasteModel.fromSnapshot(waste))
        .toList();
    yield _wasteData; // Emit the initial data
  }

  void _searchWaste(String searchTerm) {
    _filteredWaste = _wasteData
        .where((waste) =>
            waste.wastename!.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
    setState(() {}); // Update UI to reflect changes
  }

  void _createData(WasteModel wasteModel) {
    final wasteCollection = FirebaseFirestore.instance.collection("waste");
    String id = wasteCollection.doc().id;

    final newData = WasteModel(
      wastename: wasteModel.wastename,
      wastesource: wasteModel.wastesource,
      wastevolume: wasteModel.wastevolume,
      wastedesc: wasteModel.wastedesc,
      id: id,
    ).toJson();

    wasteCollection.doc(id).set(newData);
  }

  void _updateData(WasteModel wasteModel) {
    final wasteCollection = FirebaseFirestore.instance.collection("waste");

    final newData = WasteModel(
      wastename: _WasteNameController.text,
      wastesource: _WasteSourceController.text,
      wastevolume: int.parse(_WasteVolume.text),
      wastedesc: _Wastedesc.text,
      id: wasteModel.id,
    ).toJson();

    wasteCollection.doc(wasteModel.id).update(newData);
  }

  void _deleteData(String id) {
    final wasteCollection = FirebaseFirestore.instance.collection("waste");
    wasteCollection.doc(id).delete();
  }

  void clearFields() {
    _WasteNameController.clear();
    _WasteSourceController.clear();
    _WasteVolume.clear();
    _Wastedesc.clear();
    selectedWasteModel = null;
  }

  Future<void> downloadWasteData() async {
    try {
      final wasteCollection = FirebaseFirestore.instance.collection("waste");
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await wasteCollection.get();

      // Prepare CSV data
      List<Map<String, dynamic>> wasteData = [];
      for (var doc in querySnapshot.docs) {
        wasteData.add(doc.data());
      }

      // Convert data to CSV string
      String csvData = ListToCsvConverter().convert(wasteData);

      // Copy to clipboard
      Clipboard.setData(ClipboardData(text: csvData));
      showToast(message: "Waste data copied to clipboard!");
    } catch (e) {
      showToast(message: "Error downloading data: $e");
    }
  }
}

class WasteModel {
  final String? wastename;
  final String? wastesource;
  final int? wastevolume;
  final String? wastedesc;
  final String? id;

  WasteModel({
    this.wastename,
    this.wastesource,
    this.wastevolume,
    this.wastedesc,
    this.id,
  });

  static WasteModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return WasteModel(
      wastename: snapshot['wastename'],
      wastesource: snapshot['wastesource'],
      wastevolume: snapshot['wastevolume'],
      wastedesc: snapshot['wastedesc'],
      id: snapshot['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "wastename": wastename,
      "wastesource": wastesource,
      "wastevolume": wastevolume,
      "wastedesc": wastedesc,
      "id": id,
    };
  }
}

class ListToCsvConverter {
  String convert(List<Map<String, dynamic>> data) {
    List<String> headers = data.isNotEmpty ? data[0].keys.toList() : [];
    String csv = headers.join(",") + "\n";

    for (var row in data) {
      List<String> rowValues = headers.map((header) {
        return '"${row[header] ?? ""}"';
      }).toList();
      csv += rowValues.join(",") + "\n";
    }

    return csv;
  }
}
