import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserListWidget extends StatelessWidget {
  const UserListWidget({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.subText,
    this.time,
    this.incomingChat,
  });

  final String name;
  final String imageUrl;
  final String subText;
  final String? time;
  final String? incomingChat;

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('HH.mm').format(DateTime.parse(time?? DateTime.now().toString()));
    return Row(
      children: [
        SizedBox(
          child: SizedBox(
              height: 60,
              width: 60,
              child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) {
                    return CircularProgressIndicator.adaptive();
                  },
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(200)),
                        image: DecorationImage(
                            fit: BoxFit.cover, image: imageProvider),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(200)),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/logo/noimage.png')),
                        ),
                      ))),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                   Text(formattedTime),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  subText.isEmpty
                      ? SizedBox()
                      : Expanded(
                          child: Text(
                            subText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15 ),
                          ),
                        ),
                  SizedBox(width: 10),
                  incomingChat == "0"
                      ? Container()
                      : SizedBox(
                          height: 20,
                          width: 20,
                          child: CircleAvatar(
                            child: Text(
                              incomingChat ?? '',
                              style: TextStyle(fontSize: 12),
                            ),
                          ))
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
