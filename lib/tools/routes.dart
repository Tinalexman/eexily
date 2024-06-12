import 'package:eexily/pages/home/home.dart';
import 'package:go_router/go_router.dart';
import 'constants.dart';

final List<GoRoute> routes = [

  GoRoute(
    path: Pages.home.path,
    name: Pages.home,
    builder: (_, __) => const Homepage(),
  )
];
