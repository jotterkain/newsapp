import 'package:flutter/material.dart';
import 'package:newsapp/utils/localization.dart';
import 'package:newsapp/utils/persistance/settings/settings_prefs.dart';
import 'package:provider/provider.dart';
import '../../../../../data/api/api.dart';

class ApiErrorWidget extends StatelessWidget {
  const ApiErrorWidget({Key? key, required this.search}) : super(key: key);
  final bool search;

  @override
  Widget build(BuildContext context) {
    String lang = SettingsPrefs.lang;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline,
              size: 80,
              color: SettingsPrefs.darkMode
                  ? Colors.grey.shade300
                  : Colors.grey.shade800),
          const SizedBox(height: 20),
          Text(
            dictionary['@error'][lang],
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontWeight: FontWeight.bold,
                color: SettingsPrefs.darkMode
                    ? Colors.grey.shade300
                    : Colors.grey.shade800),
          ),
          const SizedBox(height: 20),
          if (!search)
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.grey.shade300),
              ),
              onPressed: () {
                Provider.of<NewsAPI>(context, listen: false).articles.clear();
                Provider.of<NewsAPI>(context, listen: false)
                    .fetchNewsByCategory();
              },
              child: Text(
                dictionary['@tryAgain'][lang],
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: Colors.grey.shade700),
              ),
            )
        ],
      ),
    );
  }
}
