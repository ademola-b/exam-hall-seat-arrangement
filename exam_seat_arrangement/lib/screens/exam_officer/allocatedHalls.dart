import 'package:exam_seat_arrangement/models/allocations_response.dart';
import 'package:exam_seat_arrangement/services/remote_services.dart';
import 'package:exam_seat_arrangement/utils/constants.dart';
import 'package:exam_seat_arrangement/utils/defaultContainer.dart';
import 'package:exam_seat_arrangement/utils/defaultText.dart';
import 'package:exam_seat_arrangement/utils/defaultTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class AllocatedHalls extends StatefulWidget {
  const AllocatedHalls({super.key});

  @override
  State<AllocatedHalls> createState() => _AllocatedHallsState();
}

class _AllocatedHallsState extends State<AllocatedHalls> {
  DateTime pickedDate = DateTime.now();
  TextEditingController _date = TextEditingController();
  Future<List<AllocationsResponse>?>? _allot;

  Future<List<AllocationsResponse>?>? _getAllocations(context,
      {String? date}) async {
    setState(() {
      _allot = RemoteServices.allocations(context, date: date);
    });
    return _allot;
  }

  _pickDate() async {
    DateTime? picked = await Constants.pickDate(context, pickedDate);
    if (picked != null && picked != pickedDate) {
      setState(() {
        pickedDate = picked;
        _date.text = DateFormat("yyyy-MM-dd").format(pickedDate);
        _getAllocations(context, date: _date.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                    text: "Allocations",
                    size: 20.0,
                    color: Constants.splashBackColor,
                  )
                ],
              ),
              const SizedBox(height: 40.0),
              DefaultTextFormField(
                label: "Search by date",
                text: _date,
                obscureText: false,
                icon: Icons.search_outlined,
                maxLines: 1,
                onTap: _pickDate,
                keyboardInputType: TextInputType.none,
              ),
              const SizedBox(height: 50.0),
              Expanded(
                child: Column(
                  children: [
                    FutureBuilder(
                      future: _allot ?? _getAllocations(context),
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
                                      "assets/images/no_data.svg",
                                      width: 150,
                                      height: 150,
                                    ),
                                    const SizedBox(height: 30.0),
                                    DefaultText(
                                      text: "No Allocation found",
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
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: data!.length,
                              itemBuilder: (context, index) {
                                return DefaultContainer(
                                  child: ListTile(
                                    title: DefaultText(
                                        size: 18.0,
                                        text: DateFormat("dd-MMM-yyyy")
                                            .format(data[index].date)),
                                    subtitle: DefaultText(
                                        text:
                                            "${data[index].course.courseTitle} - ${data[index].level} - ${data[index].invigilator.userId.name}"),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Constants.primaryColor,
                                            )),
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.recycling,
                                              color: Constants.primaryColor,
                                            )),
                                        IconButton(
                                            onPressed: () {
                                              Constants.dialogBox(context,
                                                  icon: Icons.info,
                                                  text:
                                                      "Seats linked with this allocation will also be deleted, confirm delete",
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
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
