
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../profile/presentation/widgets/circle_user_avatar.dart';
import '../../../../core/entity/message_entity.dart';

class MessageWidget extends StatelessWidget {
  final MessageEntity messageEntity;

  MessageWidget({required this.messageEntity});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleUserAvatar(
          width: 40,
          height: 40,
          url: messageEntity.sender.avatar,
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              messageEntity.sender.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w300, fontSize: 16),
            ),
            Text(
              messageEntity.text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500, fontSize: 16),
            )
          ],
        ),
        Spacer(),
        Text(
          DateFormat.jm().format(messageEntity.createdAt.toLocal()),
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w400, fontSize: 14,color: Theme.of(context).colorScheme.onSurface.withOpacity(.8)),
        )
      ],
    );
  }
}
