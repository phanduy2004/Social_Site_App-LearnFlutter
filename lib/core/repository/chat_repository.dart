import 'package:social_site_app/core/model/failure.dart';
import 'package:social_site_app/core/entity/message_entity.dart';

import '../model/either.dart';

abstract class ChatRepository{
  Future<Either<Failure, void>> joinChat({required String meetId,
    required Function(MessageEntity message) onNewMessage,
    required Function(String error) onError});
  Future<Either<Failure, void>> sendMessage(String meetingId, String message);

  Future<Either<Failure, List<MessageEntity>>> getMessage(
      {required String meetId, DateTime? lastMessageDate, int? limit});}