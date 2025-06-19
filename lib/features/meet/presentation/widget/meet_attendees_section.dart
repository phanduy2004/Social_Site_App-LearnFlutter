import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_site_app/features/meet/presentation/widget/attendee_widget.dart';

import '../bloc/meet_bloc.dart';
import '../bloc/meet_state.dart';

class MeetAttendeesSection extends StatelessWidget {
  const MeetAttendeesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MeetBloc, MeetState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                Text('Attendees', style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ),),
                Icon(Icons.people, color: Theme
                    .of(context)
                    .colorScheme
                    .onSurface)
              ],
            ),
            SizedBox(height: 10,),
            Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .onSurfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(20),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return AttendeeWidget(attendee: state.meetEntity!.attendees[index]);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 10,);
                  },
                  itemCount: state.meetEntity?.attendees.length ?? 0,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                )

            ),
          ],

        );
      },
    );
  }
}
