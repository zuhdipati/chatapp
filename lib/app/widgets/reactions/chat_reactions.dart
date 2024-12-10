import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:chatapp/app/widgets/reactions/default_reactions_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReactionsChatWidget extends StatefulWidget {
  const ReactionsChatWidget({
    super.key,
    required this.id,
    required this.messageWidget,
    required this.onReactionTap,
    required this.onContextMenuTap,
    this.menuItems = DefaultData.menuItems,
    this.reactions = DefaultData.reactions,
    this.widgetAlignment = Alignment.centerRight,
    this.menuItemsWidth = 0.45,
  });

  // Id for the hero widget
  final String id;

  // The message widget to be displayed in the dialog
  final Widget messageWidget;

  // The callback function to be called when a reaction is tapped
  final Function(String) onReactionTap;

  // The callback function to be called when a context menu item is tapped
  final Function(MenuItem) onContextMenuTap;

  // The list of menu items to be displayed in the context menu
  final List<MenuItem> menuItems;

  // The list of reactions to be displayed
  final List<String> reactions;

  // The alignment of the widget
  final Alignment widgetAlignment;

  // The width of the menu items
  final double menuItemsWidth;

  @override
  State<ReactionsChatWidget> createState() => _ReactionsChatWidgetState();
}


class _ReactionsChatWidgetState extends State<ReactionsChatWidget> {
  // state variables for activating the animation
  bool reactionClicked = false;
  int? clickedReactionIndex;
  int? clickedContextMenuIndex;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // reactions
              buildReactions(context),
              const SizedBox(height: 10),
              // message
              buildMessage(),
              const SizedBox(height: 1),
              // context menu
              buildMenuItems(context),
            ],
          ),
        ),
      ),
    );
  }

  Align buildMenuItems(BuildContext context) {
    return Align(
      alignment: widget.widgetAlignment,
      child: // contextMenu for reply, copy, delete
          Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade500,
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var item in widget.menuItems)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 7),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              clickedContextMenuIndex =
                                  widget.menuItems.indexOf(item);
                            });

                            Future.delayed(const Duration(milliseconds: 500))
                                .whenComplete(() {
                              Get.back();
                              widget.onContextMenuTap(item);
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.label,
                                style: TextStyle(
                                    color: item.isDestuctive
                                        ? Colors.red
                                        : Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .color,
                                    fontSize: 17),
                              ),
                              Pulse(
                                infinite: false,
                                duration: const Duration(milliseconds: 500),
                                animate: clickedContextMenuIndex ==
                                    widget.menuItems.indexOf(item),
                                child: Icon(
                                  item.icon,
                                  color: item.isDestuctive
                                      ? Colors.red
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      if (widget.menuItems.last != item)
                        Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Align buildMessage() {
    return Align(
      alignment: widget.widgetAlignment,
      child: Hero(
        tag: widget.id,
        child: widget.messageWidget,
      ),
    );
  }

  Align buildReactions(BuildContext context) {
    return Align(
      alignment: widget.widgetAlignment,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade500,
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var reaction in widget.reactions)
                FadeInLeft(
                  from: // first index should be from 0, second from 20, third from 40 and so on
                      0 + (widget.reactions.indexOf(reaction) * 20).toDouble(),
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 200),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          reactionClicked = true;
                          clickedReactionIndex =
                              widget.reactions.indexOf(reaction);
                        });
                        // delay for 200 milliseconds to allow the animation to complete
                        Future.delayed(const Duration(milliseconds: 500))
                            .whenComplete(() {
                          // pop the dialog
                          Navigator.of(Get.context!).pop();
                          widget.onReactionTap(reaction);
                        });
                      },
                      child: Pulse(
                        infinite: false,
                        duration: const Duration(milliseconds: 500),
                        animate: reactionClicked &&
                            clickedReactionIndex ==
                                widget.reactions.indexOf(reaction),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          child: Text(
                            reaction,
                            style: const TextStyle(fontSize: 33),
                          ),
                        ),
                      )),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
