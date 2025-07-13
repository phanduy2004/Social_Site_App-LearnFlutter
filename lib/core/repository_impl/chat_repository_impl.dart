import 'package:dio/dio.dart';

import '../model/either.dart';
import '../model/failure.dart';
import '../entity/message_entity.dart';
import '../repository/chat_repository.dart';
import '../datasource/chat_remote_datasource.dart';
import '../datasource/chat_socket_datasource.dart';


class ChatRepositoryImpl implements ChatRepository {
  final ChatSocketDatasource chatSocketDatasource;
  final ChatRemoteDatasource chatRemoteDatasource;

  ChatRepositoryImpl(
      {required this.chatSocketDatasource, required this.chatRemoteDatasource});

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessage(
      {required String meetId, DateTime? lastMessageDate, int? limit}) async {
    try {
      return Right(await chatRemoteDatasource.getMessages(
          meetId: meetId, lastMessageDate: lastMessageDate, limit: limit));
    } on DioException catch (e) {
      return Left(ChatFailure(message: e.response?.data['message']));
    } catch (e) {
      return Left(ChatFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> joinChat(
      {required String meetId,
      required Function(MessageEntity message) onNewMessage,
      required Function(String error) onError}) async {
    try {
      await chatSocketDatasource.joinChat(
          meetId: meetId, onNewMessage: onNewMessage, onError: onError);
      return Right(null);
    } catch (e) {
      return Left(ChatFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(
      String meetingId, String message) async {
    try {
      return Right(chatSocketDatasource.sendMessage(meetingId, message));
    } catch (e) {
      return Left(ChatFailure(message: e.toString()));
    }
  }
}
