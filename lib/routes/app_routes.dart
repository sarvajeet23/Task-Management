abstract class AppRoutes {
  static const initial = _Routes.initial;
  static const homePage = _Routes.homePage;
  static const addTaskPage = _Routes.detailPage;
  static const moviePage = _Routes.moviePage;
}

abstract class _Routes {
  static const initial = '/splash_page';
  static const homePage = "/home_page";
  static const detailPage = "/detail_page";
  static const moviePage = "/movie_page";
}
