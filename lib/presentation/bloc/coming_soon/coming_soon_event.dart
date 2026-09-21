import 'package:equatable/equatable.dart';

abstract class ComingSoonEvent extends Equatable {
  const ComingSoonEvent();

  @override
  List<Object?> get props => [];
}

class FetchUpcomingMovies extends ComingSoonEvent {
  final bool isRefresh;

  const FetchUpcomingMovies({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class LoadMoreUpcomingMovies extends ComingSoonEvent {}
