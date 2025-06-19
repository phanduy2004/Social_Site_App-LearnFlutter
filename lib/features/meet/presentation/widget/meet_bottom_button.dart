import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_site_app/core/ui/default_button.dart';
import 'package:social_site_app/features/auth/presentation/bloc/user_bloc.dart';
import 'package:social_site_app/features/auth/presentation/bloc/user_state.dart';
import 'package:social_site_app/features/meet/presentation/bloc/meet_event.dart';

import '../bloc/meet_bloc.dart';
import '../bloc/meet_state.dart';

class MeetBottomButtons extends StatelessWidget {
  const MeetBottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetBloc, MeetState>(
      builder: (context, meetState) {
        return BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (!(meetState.meetEntity?.attendees
                .any((e) => e.id == state.userEntity?.id) ??
                false)) {
              return DefaultButton(
                text: 'Join',
                onPressed: (){
                  context.read<MeetBloc>().add(JoinMeetEvent());
                },
              );
            }
            if(meetState.meetEntity?.admin.id == state.userEntity?.id){
              return Row(
                children: [
                  Expanded(child: DefaultButton(
                    text: 'Chat',
                    onPressed: (){
                    },
                  )),
                  if(!(meetState.meetEntity?.isFinished ?? true))Row(
                    children: [
                      SizedBox(width: 10,),
                      IconButton(onPressed: (){
                        context.read<MeetBloc>().add(CancelMeetEvent());
                      }, icon: Icon(CupertinoIcons.clear_circled),style: IconButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.surface,
                          backgroundColor: Theme.of(context).colorScheme.error
                      ),),
                    ],
                  ),
                ],
              );
            }
            return Row(
              children: [
                Expanded(child: DefaultButton(
                  text: 'Chat',
                  onPressed: (){
                  },
                ),),
                if(!(meetState.meetEntity?.isFinished ?? true))
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      IconButton(onPressed: (){
                        context.read<MeetBloc>().add(LeaveMeetEvent());
                      }, icon: Icon(Icons.exit_to_app),style: IconButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.surface,
                          backgroundColor: Theme.of(context).colorScheme.error
                      ),),
                    ],
                  )
              ],
            );
            return Container();
          },
        );
      },
    );
  }
}
