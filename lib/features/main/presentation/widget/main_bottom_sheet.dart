import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_site_app/features/main/presentation/bloc/main_bloc.dart';
import 'package:social_site_app/features/main/presentation/bloc/main_event.dart';
import 'package:social_site_app/features/main/presentation/bloc/main_state.dart';
import 'package:social_site_app/features/main/presentation/widget/nearby_meet_widget.dart';
import 'package:social_site_app/features/meet/presentation/bloc/meet_bloc.dart';

import 'current_meet_widget.dart';

class MainBottomSheet extends StatelessWidget {
  const MainBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      builder: (context, scrollController) {
        return BlocBuilder<MainBloc, MainState>(
          builder: (context,state) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(blurRadius: 10, spreadRadius:  10, color: Colors.grey.withOpacity(.5))]
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text('Current meets',style: Theme.of(context).textTheme.bodyLarge,),
                      SizedBox(height: 10,),
                      ListView.separated(itemBuilder: (context,index){
                        return CurrentMeetWidget(meetEntity: state.currentMeets![index]);
                      },
                        separatorBuilder: (context,index){
                          return SizedBox(height: 10,);
                        }, shrinkWrap: true,padding: EdgeInsets.zero,physics: NeverScrollableScrollPhysics(),itemCount: state.currentMeets?.length ?? 0,),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            );
          }
        );
      },
      initialChildSize: .2,
      minChildSize: .1,
      maxChildSize: .5,
    );
  }
}
