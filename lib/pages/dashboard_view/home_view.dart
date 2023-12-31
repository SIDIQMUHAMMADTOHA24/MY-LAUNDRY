import 'package:d_button/d_button.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_laundry/config/app_assets.dart';
import 'package:my_laundry/config/app_colors.dart';
import 'package:my_laundry/config/app_constant.dart';

import 'package:my_laundry/config/failure.dart';
import 'package:my_laundry/config/nav.dart';
import 'package:my_laundry/data_source/promo_datasource.dart';
import 'package:my_laundry/data_source/shop_datasource.dart';
import 'package:my_laundry/model/promo_model.dart';
import 'package:my_laundry/model/shop_model.dart';
import 'package:my_laundry/pages/detail_shop_pages.dart';
import 'package:my_laundry/pages/search_by_city_pages.dart';
import 'package:my_laundry/pages/widget/error_background.dart';
import 'package:my_laundry/providers/home_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final edtSearch = TextEditingController();
  final pageController = PageController();

  gotoSearchCity() {
    Nav.push(context, SearchByCityPages(query: edtSearch.text));
  }

  getPromo() {
    PromoDataSource.readLimit().then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setHomePromoStatus(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setHomePromoStatus(ref, 'Error Not Found');
              break;
            case ForbiddenFailure:
              setHomePromoStatus(ref, 'You don\'t have access');
              break;
            case BadRequestFailure:
              setHomePromoStatus(ref, 'Bad request');
              break;
            case UnauthorisedFailure:
              setHomePromoStatus(ref, 'Unauthorised');
              break;
            default:
              setHomePromoStatus(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setHomePromoStatus(ref, 'Success');
          List data = result['data'];
          List<PromoModel> promos =
              data.map((e) => PromoModel.fromJson(e)).toList();
          ref.read(homePromoListProvider.notifier).setData(promos);
        },
      );
    });
  }

  getRecommendation() {
    ShopDataSource.readRecommendationLimit().then((value) {
      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              setHomeRecommendationStatus(ref, 'Server Error');
              break;
            case NotFoundFailure:
              setHomeRecommendationStatus(ref, 'Error Not Found');
              break;
            case ForbiddenFailure:
              setHomeRecommendationStatus(ref, 'You don\'t have access');
              break;
            case BadRequestFailure:
              setHomeRecommendationStatus(ref, 'Bad request');
              break;
            case UnauthorisedFailure:
              setHomeRecommendationStatus(ref, 'Unauthorised');
              break;
            default:
              setHomeRecommendationStatus(ref, 'Request Error');
              break;
          }
        },
        (result) {
          setHomeRecommendationStatus(ref, 'Success');
          List data = result['data'];
          List<ShopModel> shops =
              data.map((e) => ShopModel.fromJson(e)).toList();
          ref.read(homeRecommendationListProvider.notifier).setData(shops);
        },
      );
    });
  }

  refresh() {
    getPromo();
    getRecommendation();
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await refresh(),
      child: ListView(
        children: [header(), catagory(), promo(), recommendation()],
      ),
    );
  }

  header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "We're ready",
            style:
                GoogleFonts.ptSans(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            "to clean your cloths",
            style: GoogleFonts.ptSans(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.black54),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Icon(
                Icons.location_city,
                color: Colors.green,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                'Find by city',
                style: TextStyle(
                    fontWeight: FontWeight.w300, color: Colors.grey[600]),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green[50]),
                    child: Row(
                      children: [
                        IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: () => gotoSearchCity(),
                            icon: const Icon(Icons.search)),
                        Expanded(
                          child: TextField(
                            onSubmitted: (value) => gotoSearchCity(),
                            controller: edtSearch,
                            decoration: const InputDecoration(
                                hintText: 'Search', border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                DButtonElevation(
                    onClick: () {},
                    mainColor: Colors.green,
                    splashColor: Colors.greenAccent,
                    width: 50,
                    radius: 10,
                    child: const Icon(
                      Icons.tune,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  catagory() {
    return Consumer(
      builder: (_, wiRef, __) {
        String catagorySelected = wiRef.watch(homeCategoryProvider);
        return SizedBox(
          height: 30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AppConstant.homeCatagory.length,
            itemBuilder: (context, index) {
              String catagory = AppConstant.homeCatagory[index];
              return InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  setHomeCategory(ref, catagory);
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(index == 0 ? 30 : 8, 0,
                      index == AppConstant.homeCatagory.length - 1 ? 30 : 8, 0),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: catagorySelected == catagory
                              ? Colors.green
                              : Colors.green[400]!),
                      color: catagorySelected == catagory
                          ? Colors.green
                          : Colors.transparent),
                  child: Text(
                    catagory,
                    style: TextStyle(
                        height: 1,
                        color: catagorySelected == catagory
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  promo() {
    return Consumer(
      builder: (_, wiRef, __) {
        List<PromoModel> list = wiRef.watch(homePromoListProvider);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DView.textTitle('Promo', color: Colors.black),
                  DView.textAction(() {}, color: AppColors.green)
                ],
              ),
            ),
            if (list.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: ErrorBackground(
                  ratio: 16 / 9,
                  message: 'No Promo',
                ),
              ),
            if (list.isNotEmpty)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: PageView.builder(
                  controller: pageController,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    PromoModel item = list[index];
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              index == 0 ? 30 : 30,
                              0,
                              index == AppConstant.homeCatagory.length - 1
                                  ? 20
                                  : 30,
                              30),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FadeInImage(
                              placeholder: const AssetImage(
                                  AppAssets.placeholderLaundry),
                              image: NetworkImage(
                                '${AppConstant.baseImageUrl}/promo/${item.image}',
                              ),
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error);
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 20),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey[600]!,
                                    blurRadius: 1,
                                  )
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.shop.name,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${(item.oldPrice.toInt())} /kg',
                                      style: const TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.red),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Text(
                                      '${item.newPrice.toInt()} /kg',
                                      style: const TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            if (list.isNotEmpty)
              const SizedBox(
                height: 8,
              ),
            if (list.isNotEmpty)
              SmoothPageIndicator(
                controller: pageController,
                count: list.length,
                effect: WormEffect(
                    dotHeight: 7,
                    dotWidth: 25,
                    activeDotColor: Colors.green,
                    dotColor: Colors.grey[300]!),
              ),
          ],
        );
      },
    );
  }

  recommendation() {
    return Consumer(builder: (_, wiRef, __) {
      List<ShopModel> list = wiRef.watch(homeRecommendationListProvider);
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DView.textTitle('Recommendation', color: Colors.black),
                DView.textAction(() {}, color: AppColors.green)
              ],
            ),
          ),
          if (list.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: ErrorBackground(
                ratio: 1.2,
                message: 'No Recommendation Yet',
              ),
            ),
          if (list.isNotEmpty)
            SizedBox(
              height: 270,
              child: ListView.builder(
                itemCount: list.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  ShopModel item = list[index];
                  return GestureDetector(
                    onTap: () {
                      Nav.push(context, DetailShopPages(shop: item));
                    },
                    child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2,
                                offset: Offset(0, 1))
                          ]),
                      margin: EdgeInsets.fromLTRB(index == 0 ? 30 : 0, 0,
                          index == list.length - 1 ? 30 : 20, 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            FadeInImage(
                              placeholder: const AssetImage(
                                  AppAssets.placeholderLaundry),
                              image: NetworkImage(
                                '${AppConstant.baseImageUrl}/shop/${item.image}',
                              ),
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error);
                              },
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: MediaQuery.sizeOf(context).height / 2,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                      Colors.transparent,
                                      Colors.black54
                                    ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter)),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              left: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            color: AppColors.green,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: const Text(
                                          'Regular',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            color: AppColors.green,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: const Text(
                                          'Express',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(9),
                                        color: Colors.white),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: GoogleFonts.ptSans(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Row(
                                            children: [
                                              RatingBar.builder(
                                                initialRating: item.rate,
                                                itemCount: 5,
                                                allowHalfRating: true,
                                                unratedColor: Colors.grey,
                                                ignoreGestures: true,
                                                itemSize: 12,
                                                itemBuilder: (context, index) {
                                                  return const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  );
                                                },
                                                onRatingUpdate: (value) {},
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                '(${item.rate})',
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black54),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            item.location,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          )
                                        ]),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
        ],
      );
    });
  }
}
