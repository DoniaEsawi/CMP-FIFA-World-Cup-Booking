import 'package:country_flags/country_flags.dart';
import 'package:fifa2022/config/lists.dart';
import 'package:fifa2022/models/match.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
class SameDayMatchesList extends StatefulWidget {
  SameDayMatchesList({
  super.key,
  required this.date,
  required this.matchModels
  });
  String date;
  List<MatchModel> matchModels;

  @override
  State<SameDayMatchesList> createState() => _SameDayMatchesListState();
}

class _SameDayMatchesListState extends State<SameDayMatchesList> {
  late DateTime dateTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateTime =DateFormat("yyyy-MM-dd").parse(widget.date);
  }
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Text((dateTime.day==DateTime.now().day&&dateTime.month==DateTime.now().month
        &&dateTime.year==DateTime.now().year)?
          "Today":
          "${weekdays[dateTime.weekday-1]}, ${dateTime.day} ${months[dateTime.month-1]}",
          style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w700
          ),
        ),
        Column(
          children: widget.matchModels.map((e) => MatchTimeCard(matchModel: e,
          onPressed: (){
            Navigator.pushNamed(context, '/match/${e.id.toString()}');
          },
          )).toList()
        ),
        const SizedBox(height: 16,),

      ],
    );
  }
}

class MatchTimeCard extends StatelessWidget {
  MatchTimeCard({
  required this.matchModel,
  this.onPressed,
  super.key,
  });
  MatchModel matchModel;
  VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: (){
          onPressed!=null?onPressed!.call():(){}.call();
        },
        onHover: (val){},
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: Colors.black.withOpacity(0.05),
                width: 1.2

            ),

          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("FIFA World Cup 2022",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontFamily: "kalam",
                        fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                const SizedBox(height: 16,),
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(matchModel.team1_name!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500
                              ),
                              
                            ),
                            const SizedBox(width: 16,),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset('icons/flags/png/${countryFlag.keys.contains(matchModel.team1_name)?
                              countryFlag[matchModel.team1_name]!.toLowerCase():"eg"}.png', package: 'country_icons',
                              width: 35,height: 35,fit: BoxFit.cover,),
                            )

                          ],
                        )),
                    Expanded(
                      flex: 1,
                      child:  Text(matchModel.time!.substring(0,5),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600
                        ),
                      ),),
                    Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset('icons/flags/png/${countryFlag.keys.contains(matchModel.team2_name)?
                              countryFlag[matchModel.team2_name]!.toLowerCase():"eg"}.png', package: 'country_icons',
                                width: 35,height: 35,fit: BoxFit.cover,),
                            ),
                            const SizedBox(width: 16,),

                            Text(matchModel.team2_name!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500
                              ),
                            ),

                          ],
                        )),
                  ],
                ),
                const SizedBox(height: 32,),
                Text("${matchModel.stadium_name}, ${matchModel.stadium!.location}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
