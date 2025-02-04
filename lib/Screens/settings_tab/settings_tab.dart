import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_application/Screens/App_colors.dart';
import 'package:to_do_application/Screens/settings_tab/language_bottom_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:to_do_application/Screens/settings_tab/theme_mode_bottom_sheet.dart';
import 'package:to_do_application/providers/app_config_provider.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  void showLanguageBottomSheet() {
    showModalBottomSheet(
        shape: Border.all(width: 0),
        context: context,
        builder: (context) => LanguageBottomSheet());
  }

  void showThemeModeBottomSheet() {
    showModalBottomSheet(
        shape: Border.all(width: 0),
        context: context,
        builder: (context) => ThemeModeBottomSheet());
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(AppLocalizations.of(context)!.language,
              style: provider.isDark()
                  ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.whiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)
                  : Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 20, fontWeight: FontWeight.w700)),
          SizedBox(height: 15),
          InkWell(
              onTap: () {
                showLanguageBottomSheet();
              },
              child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: provider.isDark()
                          ? AppColors.blackDarkColor
                          : AppColors.whiteColor,
                      border:
                          Border.all(width: 2, color: AppColors.primaryColor)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        provider.appLanguage == "en"
                            ? AppLocalizations.of(context)!.english
                            : AppLocalizations.of(context)!.arabic,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: AppColors.primaryColor),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        size: 35,
                        color: AppColors.primaryColor,
                      )
                    ],
                  ))),
          SizedBox(height: 30),
          Text(AppLocalizations.of(context)!.mode,
              style: provider.isDark()
                  ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.whiteColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)
                  : Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 20, fontWeight: FontWeight.w700)),
          SizedBox(height: 15),
          InkWell(
            onTap: () {
              showThemeModeBottomSheet();
            },
            child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: provider.isDark()
                        ? AppColors.blackDarkColor
                        : AppColors.whiteColor,
                    border:
                        Border.all(width: 2, color: AppColors.primaryColor)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      provider.appTheme == ThemeMode.dark
                          ? AppLocalizations.of(context)!.dark_mode
                          : AppLocalizations.of(context)!.light_mode,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppColors.primaryColor),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 35,
                      color: AppColors.primaryColor,
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
