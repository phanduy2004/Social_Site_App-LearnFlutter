import 'package:flutter/material.dart';
import 'package:social_site_app/features/profile/presentation/bloc/last_meets_bloc.dart';
import 'package:social_site_app/features/profile/presentation/bloc/last_meets_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'last_meets_widget.dart';

class LastMeetsSection extends StatelessWidget {
  const LastMeetsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BlocBuilder<LastMeetsBloc, LastMeetsState>(
            builder: (context, state) {
              return ListView.separated(
                itemBuilder: (context, index) {
                  return LastMeetsWidget(meetEntity: state.lastMeets![index]);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
                itemCount: state.lastMeets?.length ?? 0,
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(
                ),

              );
            },
          ),
        ],
      ),
    );
  }
}
