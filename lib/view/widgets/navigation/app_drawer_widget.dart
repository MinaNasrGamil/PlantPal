import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/cubit/navigation/navigation_cubit.dart';

class AppDrawerWidget extends StatelessWidget {
  const AppDrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 20,
        top: 0,
        child: SizedBox(
          width: 100,
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 1,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/profile');
                      context.read<NavigationCubit>().clickMore(false);
                    },
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<BeveledRectangleBorder>(
                        const BeveledRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                        ),
                      ),
                      minimumSize: WidgetStateProperty.all(Size.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Profile')),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      context.read<NavigationCubit>().clickMore(false);
                      Navigator.of(context).pushNamed('/settings');
                    },
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
                    child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Settings')),
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
              ],
            ),
          ),
        ));
  }
}
