import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Container(
      // height: 300,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: colorScheme.primary,
      ),

      // color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '진행상태',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '진행상태',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Progress',
                    style: TextStyle(color: colorScheme.onPrimary, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                height: 32,
                width: 32,
                child: FloatingActionButton(
                  backgroundColor: colorScheme.onPrimary,
                  elevation: 0,
                  shape: const CircleBorder(),
                  onPressed: () {},
                  child: Icon(
                    Icons.east,
                    color: colorScheme.primary,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          Text(
            'asd',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
