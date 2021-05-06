import 'package:flutter_riverpod/flutter_riverpod.dart';

final statusProvider = StateNotifierProvider<StatusCheck, bool>((ref) => StatusCheck());

class StatusCheck extends StateNotifier<bool>{
  StatusCheck() : super(false);
  void toggle(){
    state = !state;
  }

}

final visibilityProvider = StateNotifierProvider<StatusCheck, bool>((ref) => StatusCheck());

class VisibilityCheck extends StateNotifier<bool>{
  VisibilityCheck() : super(false);
  void toggle(){
    state = !state;
  }

}

final indexProvider = StateNotifierProvider<IndexCheck, int>((ref) => IndexCheck());

class IndexCheck extends StateNotifier<int>{
  IndexCheck() : super(0);
  void toggle(int index){
    state = index;
  }

}