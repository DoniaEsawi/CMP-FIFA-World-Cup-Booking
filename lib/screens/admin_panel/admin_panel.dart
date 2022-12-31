import 'package:fifa2022/config/constants.dart';
import 'package:fifa2022/config/enums.dart';
import 'package:fifa2022/models/admin.dart';
import 'package:fifa2022/models/user.dart';
import 'package:fifa2022/screens/admin/card_tasks.dart';
import 'package:fifa2022/screens/admin/widgets/task_in_progress.dart';
import 'package:fifa2022/screens/shared_widgets/notfound.dart';
import 'package:fifa2022/screens/shared_widgets/unauthorized.dart';
import 'package:fifa2022/screens/shared_widgets/weird_connection.dart';
import 'package:fifa2022/services/admin_service.dart';
import 'package:fifa2022/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdminPanel extends StatefulWidget {
  static const String route = '/admin';
  const AdminPanel({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> with SingleTickerProviderStateMixin{
  int selectedTap=1;
  bool finishedAnim=true;
  late int tabSelected;
  List<User> users=<User>[];
  List<User> usersManagers=<User>[];
  late AnimationController animationController;
  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    animationController=   AnimationController(vsync: this,
        duration: const Duration(seconds: 2))..repeat();
    if(AdminModel.token!=null) {
      Future.delayed(Duration.zero, () async {
        showAlertDialog(context, animationController);
        try {
          await getAllInfo();
          Navigator.pop(context);
        }
        catch (e) {
          Navigator.pop(context);
          showErrorSnackBar(context, e.toString());
        }
      });
    }
    super.initState();
  }
  Future<void> getAllInfo()async{
    try{
      var result=await AdminServices().getAllUsers(AdminModel.token!);
      users.clear();
      for(Map<String, dynamic> userJson in result)
        {
          users.add(User.fromJson(userJson));
        }
      var result2=await AdminServices().getAllUsersWhoWantToBeManager(AdminModel.token!);
      usersManagers.clear();
      print("helloooo");
      print(result2);
      for(Map<String, dynamic> userJson in result2)
      {
        usersManagers.add(User.fromJson(userJson));
      }
      setState(() {

      });
    }
    catch(e)
    {
      rethrow;
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backGround,
      body:AdminModel.token!=null?Row(
        children: [
          AnimatedContainer(
            duration:const Duration(milliseconds: 200),
            width: screenWidth>1200?350:80,
            onEnd: (){
              if(screenWidth>1200){
                setState(() {
                  finishedAnim= true;
                });
              }
              else
                {
                  setState(() {
                    finishedAnim= false;
                  });
                }
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,
                      horizontal: 16),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        selectedTap =0;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),

                    onHover: (val){

                    },
                    child: Ink(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selectedTap==0?mainRed.withOpacity(0.2):Colors.white
                      ),
                      child: AnimatedContainer(
                        height:screenWidth>1200&&finishedAnim?100:60,
                        duration:const Duration(milliseconds: 200),
                        child:screenWidth>1200&&finishedAnim? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(color: mainRed,
                                  width: 2)
                                ),

                                child:
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),

                                  child: Image.asset("assets/images/admin_boy.png",
                                    width: 55,
                                  height: 55,fit: BoxFit.cover,),
                                )
                              ),
                              const SizedBox(width: 16,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(AdminModel.adminName??"",
                                    style: const TextStyle(
                                        color:
                                        mainRed,
                                        fontSize: 18,
                                        fontFamily: "kalam",
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  const Text("Admin",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ):
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: mainRed,
                                        width: 2)
                                ),

                                child:
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),

                                  child: Image.asset("assets/images/admin_boy.png",
                                    width: 40,
                                    height: 40,fit: BoxFit.cover,),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,
                  horizontal: 16),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        selectedTap =1;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),

                    onHover: (val){

                    },
                    child: Ink(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selectedTap==1?mainRed.withOpacity(0.2):Colors.white
                      ),
                      child: AnimatedContainer(
                        height: 60,
                        duration:const Duration(milliseconds: 200),
                        child:screenWidth>1200&&finishedAnim? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(
                                selectedTap==1?Icons.home:
                                Icons.home_outlined,
                                color: selectedTap==1?mainRed:Colors.grey,
                                size: 25,
                              ),
                              const SizedBox(width: 16,),
                              Text("Home",
                                style: TextStyle(
                                    color: selectedTap==1?
                                    mainRed:Colors.grey,
                                    fontSize: 16,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          ),
                        ):
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            selectedTap==1?Icons.home:
                            Icons.home_outlined,
                            color: selectedTap==1?mainRed:Colors.grey,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0,
                      horizontal: 16),
                  child: InkWell(
                    
                    onTap: (){
                      setState(() {
                        selectedTap =2;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),

                    onHover: (val){

                    },
                    child: Ink(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selectedTap==2?mainRed.withOpacity(0.2):Colors.white
                      ),
                      child: AnimatedContainer(
                        height: 60,

                        duration:const Duration(milliseconds: 200),
                        child:screenWidth>1200&&finishedAnim? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(
                                selectedTap==2?Icons.people_alt:
                                Icons.people_outline,
                                color: selectedTap==2?mainRed:Colors.grey,
                                size: 25,
                              ),
                              const SizedBox(width: 16,),
                              Expanded(
                                child: Text("Manage all Users",
                                  style: TextStyle(
                                      color: selectedTap==2?
                                      mainRed:Colors.grey,
                                      fontSize: 16,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ):
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:  Icon(
                            selectedTap==2?Icons.people_alt:
                            Icons.people_outline,
                            color: selectedTap==2?mainRed:Colors.grey,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                )

              ],


            ),
          ),

          Expanded(flex: 2,child: Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: selectedTap!=2?Column(
              children: [
                const SizedBox(height: 64,),
                TaskInProgress(data: usersManagers.map((e) =>
                    CardTaskData(
                        label: e.username!,
                        birthDate: DateTime.parse(e.birthDate!),
                        isFan: e.role=="fan",
                        gender: e.gender=="f"?Gender.female:Gender.male,
                        label2: "${e.firstName!} ${e.lastName!}",
                        email: e.email!,
                    ),

                ).toList(),
                onPressed: usersManagers.map((e) =>()async{
                  showAlertDialog(context, animationController);
                  bool success=false;
                  String errorMsg="";
                  var userJson;
                  try{
                    userJson= await AdminServices().makeUserManager(AdminModel.token!, e.id!);

                    success=true;

                  }
                  catch(e){
                    errorMsg=e.toString();
                    success=false;
                  }
                  Navigator.pop(context);
                  if(success)
                    {
                      showSuccessSnackBar(context, "Successfully added as manager");
                      usersManagers.removeWhere((element) => element.id==e.id!);
                      int index= users.indexWhere((element) => element.id==e.id);
                      users[index]=User.fromJson(userJson);
                      setState(() {

                      });

                    }
                  else{
                    showErrorSnackBar(context, errorMsg);

                  }
                }).toList(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0,
                    horizontal: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: <BoxShadow>[
                          BoxShadow(color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 4),
                          blurRadius: 20
                          )
                        ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text("Recent 10 Users",
                              style: TextStyle(
                                  color:Colors.grey,
                                  fontSize: 18,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                          Divider(thickness: 2,
                            height: 0,
                            color: Colors.grey.withOpacity(0.15),),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: users.reversed.toList().sublist(0,users.length>10?10:users.length)
                                          .map((e) => UserRow(index: users.indexOf(e),
                                          user: e,
                                        onPressed: ()async{
                                          showAlertDialog(context, animationController);
                                          bool success=false;
                                          String errorMsg="";
                                          try{
                                            success= await AdminServices().deleteUser(AdminModel.token!, e.id!);
                                          }
                                          catch(e){
                                            errorMsg=e.toString();
                                            success=false;
                                          }
                                          Navigator.pop(context);
                                          if(success)
                                          {
                                            showSuccessSnackBar(context, "Successfully removed user ${e.username}");
                                            users.removeWhere((element) => element.id==e.id!);
                                            usersManagers.removeWhere((element) => element.id==e.id!);
                                            setState(() {

                                            });

                                          }
                                          else{
                                            showErrorSnackBar(context, errorMsg);

                                          }
                                        },
                                      ),).toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32,)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )


              ],
            ):Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0,
                        horizontal: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: <BoxShadow>[
                            BoxShadow(color: Colors.black.withOpacity(0.05),
                                offset: const Offset(0, 4),
                                blurRadius: 20
                            )
                          ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text("All Users",
                              style: TextStyle(
                                  color:Colors.grey,
                                  fontSize: 18,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                          Divider(thickness: 2,
                            height: 0,
                            color: Colors.grey.withOpacity(0.15),),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: users
                                          .map((e) => UserRow(index: users.indexOf(e),
                                        user: e,
                                        onPressed: ()async{
                                          showAlertDialog(context, animationController);
                                          bool success=false;
                                          String errorMsg="";
                                          try{
                                            success= await AdminServices().deleteUser(AdminModel.token!, e.id!);
                                          }
                                          catch(e){
                                            errorMsg=e.toString();
                                            success=false;
                                          }
                                          Navigator.pop(context);
                                          if(success)
                                          {
                                            showSuccessSnackBar(context, "Successfully removed user ${e.username}");
                                            users.removeWhere((element) => element.id==e.id!);
                                            usersManagers.removeWhere((element) => element.id==e.id!);

                                            setState(() {

                                            });

                                          }
                                          else{
                                            showErrorSnackBar(context, errorMsg);

                                          }
                                        },
                                      ),).toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32,)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),),

        ],
      ):
      const UnauthorizedWidget(),
    );
  }

}


class UserRow extends StatelessWidget {
  const UserRow({
    super.key,
    required this.index,
    required this.user,
    required this.onPressed,
  });
  final User user;
  final int index;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: index%2==0?mainRed.withOpacity(0.2):Colors.white,
      child: InkWell(
        onTap: (){},
        onHover: (val){

        },
        child: Ink(
          height: 85,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: index%2==0?mainRed:Colors.black,
                            width: 2)
                    ),

                    child:
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        user.role=="manager"&&user.gender=="f"?
                        "assets/images/manager_girl.png":
                        user.role=="manager"&&user.gender=="m"?
                        "assets/images/manager_boy.png":
                        user.role=="fan"&&user.gender=="f"?
                        "assets/images/fan_girl.png":
                        "assets/images/fan_boy.png"
                        ,
                        width: 50,
                        height: 50,fit: BoxFit.cover,),
                    )
                ),
                const SizedBox(width: 16,),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      Text("${user.username}(${user.firstName} ${user.lastName})",
                        style: TextStyle(
                            color:index%2==0?mainRed:Colors.black,
                            fontSize: 18,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      Text(user.email!,
                        style: TextStyle(
                            color:index%2==0?Colors.black:Colors.grey,
                            fontSize: 14,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: buildDate(DateTime.parse(user.birthDate!),Colors.black))
                ,Expanded(
                    flex: 1,
                    child: doneButton("Remove",
                    index%2==0?Colors.black:Colors.redAccent,
                        index%2==0?Colors.redAccent:Colors.black,
                    Icons.delete_forever,
                       onPressed
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
