import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/enums.dart';
import '../../logic/cubit/navigation/navigation_cubit.dart';
import '../../logic/cubit/plant/plant_cubit.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({super.key});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  final TextEditingController _controller = TextEditingController();
  bool isClicked = false;
  bool _isSearchMood = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavigationCubit, NavigationState>(
      listener: (context, state) {
        isClicked = state.isMoreClicked;
        if (state.navbarItem != NavbarItem.library) {
          setState(() {
            _isSearchMood = false;
          });
        }
      },
      builder: (context, state) {
        Widget addedIcon() {
          switch (state.navbarItem) {
            case NavbarItem.home:
              return IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/images/raised-bed.svg',
                  width: 25,
                  height: 25,
                ),
              );
            case NavbarItem.library:
              return IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearchMood = !_isSearchMood;
                    });
                  },
                  icon: const Icon(Icons.search));
            case NavbarItem.reminders:
              return const SizedBox();
            case NavbarItem.identification:
              return const SizedBox();
            case NavbarItem.community:
              return Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _isSearchMood = !_isSearchMood;
                        });
                      },
                      icon: const Icon(Icons.search)),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/addpost');
                      },
                      icon: const Icon(Icons.post_add)),
                ],
              );
          }
        }

        return _isSearchMood
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    right: 8.0,
                    left: 8.0,
                  ),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter text',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          _controller.clear();
                          context.read<PlantCubit>().search('');
                          setState(() {
                            _isSearchMood = false;
                          });
                        },
                      ), // Icon on the left
                      suffixIcon: IconButton(
                        onPressed: () {
                          _controller.clear();
                          context.read<PlantCubit>().search('');
                        }, // Clear the text
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                    onChanged: (value) {
                      context.read<PlantCubit>().search(value);
                    },
                  ),
                ))
            : AppBar(
                title: const Text('PlantPal'),
                actions: [
                  addedIcon(),
                  IconButton(
                      onPressed: () {
                        isClicked = !isClicked;
                        context.read<NavigationCubit>().clickMore(isClicked);
                      },
                      icon: const Icon(Icons.more_vert_sharp)),
                ],
              );
      },
    );
  }
}
