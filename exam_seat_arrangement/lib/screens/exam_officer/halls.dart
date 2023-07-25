import 'package:exam_seat_arrangement/models/halls_response.dart';
import 'package:exam_seat_arrangement/services/remote_services.dart';
import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultContainer.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/defaultTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Halls extends StatefulWidget {
  const Halls({super.key});

  @override
  State<Halls> createState() => _HallsState();
}

class _HallsState extends State<Halls> {
  DateTime pickedDate = DateTime.now();
  TextEditingController _date = TextEditingController();
  Future<List<HallsResponse>?>? _halls;

  Future<List<HallsResponse>?>? _getHalls(context) async {
    setState(() {
      _halls = RemoteServices.halls(context);
    });

    return _halls;
  }

  _refresh() {
    _getHalls(context);
  }

  _deleteHall(context, String? id) async {
    await RemoteServices.deleteHall(context, id);
    _getHalls(context);
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: RefreshIndicator(
          onRefresh: () {
            return _refresh();
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios,
                          color: Constants.splashBackColor),
                      iconSize: 25,
                    ),
                    DefaultText(
                      text: "Halls",
                      size: 20.0,
                      color: Constants.splashBackColor,
                    )
                  ],
                ),
                const SizedBox(height: 40.0),
                DefaultTextFormField(
                  label: "Search by hall name",
                  obscureText: false,
                  icon: Icons.search_outlined,
                  maxLines: 1,
                  fillColor: Constants.splashBackColor,
                  keyboardInputType: TextInputType.text,
                ),
                const SizedBox(height: 50.0),
                Center(
                  child: DefaultText(
                    text:
                        "Below is a list of halls you can allocate your students",
                    size: 18.0,
                    color: Constants.splashBackColor,
                  ),
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: FutureBuilder(
                          future: _halls ?? _getHalls(context),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data!.isEmpty) {
                              return SizedBox(
                                width: size.width,
                                child: DefaultContainer(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/hotel_room.svg",
                                          width: 180,
                                          height: 180,
                                        ),
                                        const SizedBox(height: 30.0),
                                        DefaultText(
                                          text: "No Hall Found",
                                          size: 18.0,
                                          color: Constants.pillColor,
                                          align: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else if (snapshot.hasData) {
                              var data = snapshot.data;
                              return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: data!.length,
                                  itemBuilder: (context, index) {
                                    return DefaultContainer(
                                      child: ListTile(
                                        title: DefaultText(
                                            size: 18.0, text: data[index].name),
                                        subtitle: DefaultText(
                                            color: Constants.primaryColor,
                                            text:
                                                "Number of Seats: ${data[index].seatNo}"),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  Constants.dialogBox(context,
                                                      icon: Icons.info,
                                                      text:
                                                          "Are you sure you want to delete this hall",
                                                      textColor:
                                                          Constants.pillColor,
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: DefaultText(
                                                              text: "No",
                                                              // text: "$buttonText",
                                                              color: Constants
                                                                  .pillColor,
                                                              size: 18.0,
                                                            )),
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              _deleteHall(
                                                                  context,
                                                                  data[index]
                                                                      .hallId);
                                                            },
                                                            child: DefaultText(
                                                              text: "Yes",
                                                              color: Constants
                                                                  .backgroundColor,
                                                              size: 18.0,
                                                            )),
                                                      ]);
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Constants.pillColor,
                                                )),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }
                            return CircularProgressIndicator(
                                color: Constants.splashBackColor);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Add Hall",
          backgroundColor: Constants.splashBackColor,
          onPressed: () {
            Navigator.popAndPushNamed(context, '/addHall');
          },
          child: DefaultText(
            text: "+",
            color: Constants.pillColor,
            size: 30.0,
          ),
        ),
      ),
    );
  }
}
