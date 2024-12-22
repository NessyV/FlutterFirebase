import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t8a/features/user_auth/presentation/widget/form_container_widget.dart';
import 'package:t8a/global/common/toast.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _WasteNameController = TextEditingController();
  TextEditingController _WasteSourceController = TextEditingController();
  TextEditingController _WasteVolume = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _WasteNameController.dispose();
    _WasteSourceController.dispose();
    _WasteVolume.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      body: Center(
        child: Container(
          width: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Welcome", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),),
              SizedBox(height: 10,),
              Text("Waste Name"),
              SizedBox(height: 10,),
              FormContainerWidget(
                controller: _WasteNameController,
                hintText: "Waste Name",
                isPasswordField: false,
              ),
              SizedBox(height: 15,),
              Text("Waste Source"),
              SizedBox(height: 10,),
              FormContainerWidget(
                controller: _WasteSourceController,
                hintText: "Waste Source",
                isPasswordField: false,
              ),
              SizedBox(height: 15,),
              Text("Waste Volume"),
              SizedBox(height: 10,),
              FormContainerWidget(
                controller: _WasteVolume,
                hintText: "Waste Volume",
                isPasswordField: false,
              ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: (){
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        color:  Colors.blue,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                        child: Text("Log Out", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))
                ),
              ),
              SizedBox(height: 15,),
              GestureDetector(
                onTap: () {
                  _createData(WasteModel(
                      wastename: _WasteNameController.text,
                      wastesource: _WasteSourceController.text,
                      wastevolume: int.parse(_WasteVolume.text),
                  ));
                  showToast(message: "Data Created");
                },
                child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        color:  Colors.blue,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                        child: Text("Create Data", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))
                ),
              ),
              SizedBox(height: 15,),
              StreamBuilder<List<WasteModel>>(
                stream: _readData(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);
                  }if(snapshot.data!.isEmpty){
                    return Center(child: Text("No Data"));
                  }
                  final users = snapshot.data;
                  return Padding(padding: EdgeInsets.all(8),
                    child: Column(
                      children: users!.map((waste){
                        return ListTile(
                          leading: GestureDetector(
                            child: Icon(Icons.delete),
                            onTap: (){
                              _deleteData(waste.id!);
                              showToast(message: "Data Deleted");
                            },
                          ),
                          trailing: GestureDetector(
                            onTap: (){
                              _updateData(
                                WasteModel(
                                    id: waste.id,
                                    wastename: _WasteNameController.text,
                                    wastesource: _WasteSourceController.text,
                                    wastevolume: int.parse(_WasteVolume.text)
                                )
                              );
                              showToast(message: "Data Editd");
                            },
                            child: Icon(Icons.update),
                          ),
                          title: Text(waste.wastename!),
                          subtitle: Text("Waste Volume : ${waste.wastevolume} Kg")
                        );
                      }).toList()
                    ),
                  );
                }
              )
            ],
          ),
        ),
      )
    );
  }

  Stream<List<WasteModel>> _readData(){
    final wasteCollection = FirebaseFirestore.instance.collection("waste");

    return wasteCollection.snapshots().map((qureySnapshot)
    => qureySnapshot.docs.map((waste)
    => WasteModel.fromSnapshot(waste),).toList());
  }

  void _createData(WasteModel wasteModel) {
    final wasteCollection = FirebaseFirestore.instance.collection("waste");
    String id = wasteCollection.doc().id;

    final newData = WasteModel(
      wastename: wasteModel.wastename,
      wastesource: wasteModel.wastesource,
      wastevolume: wasteModel.wastevolume,
      id: id
    ).toJson();

    wasteCollection.doc(id).set(newData);
  }

  void _updateData(WasteModel wasteModel) {
    final wasteCollection = FirebaseFirestore.instance.collection("waste");

    final newData = WasteModel(
      wastename: wasteModel.wastename,
      wastesource: wasteModel.wastesource,
      wastevolume: wasteModel.wastevolume,
      id: wasteModel.id,
    ).toJson();

    wasteCollection.doc(wasteModel.id).update(newData);
  }

  void _deleteData(String id) {
    final wasteCollection = FirebaseFirestore.instance.collection("waste");
    wasteCollection.doc(id).delete();
  }
}

class WasteModel{
  final String? wastename;
  final String? wastesource;
  final int? wastevolume;
  final String? id;

  WasteModel({this.wastename, this.wastesource, this.wastevolume, this.id});

  static WasteModel fromSnapshot(DocumentSnapshot<Map<String, dynamic>>snapshot){
    return WasteModel(
      wastename: snapshot['wastename'],
      wastesource: snapshot['wastesource'],
      wastevolume: snapshot['wastevolume'],
      id: snapshot['id']
    );
  }
  Map<String, dynamic> toJson(){
    return{
      "wastename":wastename,
      "wastesource":wastesource,
      "wastevolume":wastevolume,
      "id":id,
    };
  }
}
