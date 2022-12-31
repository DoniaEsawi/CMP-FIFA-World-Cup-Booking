
import 'package:fifa2022/config/constants.dart';
import 'package:fifa2022/screens/admin/card_tasks.dart';
import 'package:flutter/material.dart';

class TaskInProgress extends StatefulWidget {
  const TaskInProgress({
    required this.data,
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  final List<CardTaskData> data;
  final List<VoidCallback> onPressed;
  @override
  State<TaskInProgress> createState() => _TaskInProgressState();
}

class _TaskInProgressState extends State<TaskInProgress> {
  ScrollController? _scrollController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController= ScrollController();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(kBorderRadius * 2),
          child: SizedBox(
            height: 250,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              controller: _scrollController!,
              itemCount: widget.data.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: kSpacing / 2),
                child: CardTask(
                  data: widget.data[index],
                  primary: _getSequenceColor(index),
                  onPrimary: Colors.white,
                  onPressed: widget.onPressed[index],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16,),
        Row(
          children: [
            IconButton(
              splashColor: mainRed.withOpacity(0.5),
              splashRadius: 25,
              onPressed: (){
              _scrollController!.animateTo(_scrollController!.offset-200,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear);
            }, icon: const Icon(Icons.navigate_before_outlined, color: mainRed,
            size: 25,),),
            const SizedBox(width: 16,),
            IconButton(
              splashColor: mainRed.withOpacity(0.5),
              splashRadius: 25,
              onPressed: (){
                _scrollController!.animateTo(_scrollController!.offset+200,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear);
              }, icon: const Icon(Icons.navigate_next_outlined, color: mainRed,
              size: 25,),),
          ],
        )
      ],
    );
  }

  Color _getSequenceColor(int index) {
    int val = index % 4;
    if (val == 3) {
      return Colors.indigo;
    } else if (val == 2) {
      return Colors.grey;
    } else if (val == 1) {
      return Colors.redAccent;
    } else {
      return Colors.lightBlue;
    }
  }
}
