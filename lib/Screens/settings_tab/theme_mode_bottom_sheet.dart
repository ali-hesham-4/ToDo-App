import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_application/Screens/App_colors.dart';
import 'package:to_do_application/providers/app_config_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeModeBottomSheet extends StatefulWidget {
  @override
  State<ThemeModeBottomSheet> createState() => _ThemeModeBottomSheetState();
}

class _ThemeModeBottomSheetState extends State<ThemeModeBottomSheet> {
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
                        provider.changeTheme(ThemeMode.dark);
                      },
                      child: provider.appTheme == ThemeMode.dark
                          ? getSelectedItemWidget(
                              AppLocalizations.of(context)!.dark_mode)
                          : getUnSelectedItemWidget(
                              AppLocalizations.of(context)!.dark_mode)),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                      onTap: () {
                        provider.changeTheme(ThemeMode.light);
                      },
                      child: provider.appTheme == ThemeMode.light
                          ? getSelectedItemWidget(
                              AppLocalizations.of(context)!.light_mode)
                          : getUnSelectedItemWidget(
                              AppLocalizations.of(context)!.light_mode))
                ])));
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
