import 'package:chatbot/core/common_ui/custom_text.dart';
import 'package:chatbot/core/constants/countries_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectCountryScreen extends StatefulWidget {
  const SelectCountryScreen({Key? key}) : super(key: key);

  @override
  State<SelectCountryScreen> createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  final _searchController = TextEditingController();
  String searchValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: CustomText(text: "Select Country"),
            elevation: 0,
            floating: true,
            snap: true,
            stretch: true,
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: CupertinoSearchTextField(
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryContainer),
              backgroundColor: Colors.transparent,
              onChanged: (value) {
                setState(() {
                  searchValue = value;
                });
              },
              controller: _searchController,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(countryList
                .where((e) => e.name
                    .toString()
                    .toLowerCase()
                    .contains(searchValue.toLowerCase()))
                .map((e) => ListTile(
                      onTap: () {
                        Navigator.pop(context, '+${e.phoneCode}');
                      },
                      title: Text(e.name),
                      trailing: Text('+${e.phoneCode}'),
                    ))
                .toList()),
          )
        ],
      ),
    );
  }
}
