import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_laundry/config/app_assets.dart';
import 'package:my_laundry/config/app_colors.dart';
import 'package:my_laundry/config/app_constant.dart';
import 'package:my_laundry/config/app_format.dart';
import 'package:my_laundry/model/shop_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class DetailShopPages extends StatelessWidget {
  const DetailShopPages({super.key, required this.shop});
  final ShopModel shop;

  launchWa(BuildContext context, String number) async {
    bool? yes = await DInfo.dialogConfirmation(
        context, 'Chat via Whatssap', 'Yes to confirm');
    if (yes ?? false) {
      final link = WhatsAppUnilink(
          //no telp hanya dummy
          phoneNumber: number,
          text: 'Hello, I want to order a laundry service');
      if (await canLaunchUrl(link.asUri())) {
        launchUrl(link.asUri(), mode: LaunchMode.externalApplication);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        headerImage(context),
        const SizedBox(
          height: 10,
        ),
        grubItemInfo(context),
        const SizedBox(
          height: 20,
        ),
        catagory(),
        const SizedBox(
          height: 20,
        ),
        description(),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 50,
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          child: ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Order',
                style: TextStyle(fontSize: 18, height: 1),
              )),
        )
      ]),
    );
  }

  Padding description() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DView.textTitle('Description', color: Colors.black87),
          const SizedBox(
            height: 8,
          ),
          Text(
            shop.description,
            style: const TextStyle(color: Colors.black54, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Padding catagory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DView.textTitle('Catagory', color: Colors.black87),
          const SizedBox(
            height: 8,
          ),
          Wrap(
            spacing: 8,
            children:
                ['Reguler', 'Express', 'Economical', 'Exclusive'].map((e) {
              return Chip(
                label: Text(e),
                visualDensity: const VisualDensity(vertical: -4),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.green),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Padding grubItemInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                itemInfo(
                    const Icon(
                      Icons.location_city,
                      color: Colors.green,
                      size: 20,
                    ),
                    shop.city),
                const SizedBox(
                  height: 6,
                ),
                itemInfo(
                    const Icon(
                      Icons.location_on,
                      color: Colors.green,
                      size: 20,
                    ),
                    shop.location),
                const SizedBox(
                  height: 6,
                ),
                GestureDetector(
                  onTap: () => launchWa(context, shop.whatsapp),
                  child: itemInfo(
                      Image.asset(
                        AppAssets.wa,
                        width: 20,
                      ),
                      shop.whatsapp),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppFormat.longPrice(shop.price),
                style: const TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Text('/kg')
            ],
          )
        ],
      ),
    );
  }

  Widget headerImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Card(
              elevation: 3,
              margin: const EdgeInsets.all(0),
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  '${AppConstant.baseImageUrl}/shop/${shop.image}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AspectRatio(
                aspectRatio: 2,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                          colors: [Colors.transparent, Colors.black],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: shop.rate,
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
                            '(${shop.rate})',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
                          )
                        ],
                      ),
                      shop.pickup || shop.delivery
                          ? const SizedBox(
                              height: 16,
                            )
                          : DView.nothing(),
                      Row(
                        children: [
                          if (shop.pickup) childOrder('Pickup'),
                          if (shop.delivery)
                            const SizedBox(
                              width: 8,
                            ),
                          if (shop.delivery) childOrder('Delivery'),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 40,
              child: SizedBox(
                height: 40,
                child: FloatingActionButton.extended(
                  heroTag: 'fab-hero-button',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.white,
                  extendedIconLabelSpacing: 0,
                  extendedPadding: const EdgeInsets.symmetric(horizontal: 15),
                  label: const Text('Back'),
                  icon: const Icon(Icons.navigate_before),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container childOrder(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: AppColors.green, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: const TextStyle(color: Colors.white, height: 1),
          ),
          const SizedBox(
            width: 4,
          ),
          const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 14,
          )
        ],
      ),
    );
  }

  Widget itemInfo(Widget icon, String text) {
    return Row(
      children: [
        SizedBox(
          height: 20,
          width: 30,
          child: icon,
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        )
      ],
    );
  }
}
