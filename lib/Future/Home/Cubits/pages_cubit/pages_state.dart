part of 'pages_cubit.dart';

abstract class PageScreenState {}

class PageScreenInitState extends PageScreenState {}

class PageScreenInitialState extends PageScreenState {
  final AppScreen pageType;
  final Widget page;

  PageScreenInitialState({
    required this.page,
    required this.pageType,
  });
}

class PagesScreenChange extends PageScreenState {
  AppScreen pageType;
  Widget page;
  PagesScreenChange({required this.page, required this.pageType});
}
