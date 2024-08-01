import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/enums.dart';
import '../../../logic/cubit/navigation/navigation_cubit.dart';

class ToolBarWidget extends StatelessWidget {
  const ToolBarWidget({
    super.key,
    required this.toolBarHight,
    required ScrollController scrollController,
    required GlobalKey<State<StatefulWidget>> columnKey,
  })  : _scrollController = scrollController,
        _columnKey = columnKey;

  final double toolBarHight;
  final ScrollController _scrollController;
  final GlobalKey<State<StatefulWidget>> _columnKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: toolBarHight,
      child: Card(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: IconButton(
                onPressed: () {
                  _scrollController.animateTo(
                    0.0,
                    duration: const Duration(milliseconds: 750),
                    curve: Curves.easeInOut,
                  );
                  context
                      .read<NavigationCubit>()
                      .clickToolBatItem(ToolBarItem.reminders);
                },
                icon: Icon(
                  Icons.water_drop,
                  color: Colors.blue[300],
                ),
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<BeveledRectangleBorder>(
                    const BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                      ),
                    ),
                  ),
                  minimumSize: WidgetStateProperty.all(Size.zero),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: IconButton(
                onPressed: () {
                  if (_columnKey.currentContext != null) {
                    context
                        .read<NavigationCubit>()
                        .clickToolBatItem(ToolBarItem.favorits);
                    final RenderBox renderBox = _columnKey.currentContext!
                        .findRenderObject() as RenderBox;
                    _scrollController.animateTo(
                      renderBox.size.height,
                      duration: const Duration(milliseconds: 750),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.pinkAccent,
                ),
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<BeveledRectangleBorder>(
                    const BeveledRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                    ),
                  ),
                  minimumSize: WidgetStateProperty.all(Size.zero),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
