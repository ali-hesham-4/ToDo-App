import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_application/Screens/App_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:to_do_application/providers/app_config_provider.dart';

class LanguageBottomSheet extends StatefulWidget {
  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);

    return Container(
      color: provider.isDark()
          ? AppColors.backgroundDarkColor
          : AppColors.whiteColor,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
                onTap: () {
                  provider.changeLanguage("en");
                },
                child: provider.appLanguage == "en"
                    ? getSelectedItemWidget(
                        AppLocalizations.of(context)!.english)
                    : getUnSelectedItemWidget(
                        AppLocalizations.of(context)!.english)),
            SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () {
                  provider.changeLanguage("ar");
                },
                child: provider.appLanguage == "ar"
                    ? getSelectedItemWidget(
                        AppLocalizations.of(context)!.arabic)
                    : getUnSelectedItemWidget(
                        AppLocalizations.of(context)!.arabic)),
          ],
        ),
      ),
    );
  }

  Widget getSelectedItemWidget(String text) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.primaryColor, fontWeight: FontWeight.w700),
      ),
      Icon(
        Icons.check,
        color: AppColors.primaryColor,
        size: 30,
      )
    ]);
  }

  Widget getUnSelectedItemWidget(String text) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
