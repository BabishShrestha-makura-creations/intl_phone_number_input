import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';

/// Creates a list of Countries with a search textfield.
class CountrySearchListWidget extends StatefulWidget {
  final List<Country> countries;
  final InputDecoration? searchBoxDecoration;
  final String? locale;
  final ScrollController? scrollController;
  final PhoneInputSelectorType phoneInputSelectorType;
  final bool autoFocus;
  final bool? showFlags;
  final bool? useEmoji;
  final Color? scrollBarThumbColor;
  final Color? scrollBarTrackColor;
  const CountrySearchListWidget(
    this.countries,
    this.locale, {
    super.key,
    this.searchBoxDecoration,
    this.scrollController,
    this.showFlags,
    this.useEmoji,
    this.autoFocus = false,
    this.phoneInputSelectorType = PhoneInputSelectorType.BOTTOM_SHEET,
    required this.scrollBarThumbColor,
    required this.scrollBarTrackColor,
  });

  @override
  _CountrySearchListWidgetState createState() =>
      _CountrySearchListWidgetState();
}

class _CountrySearchListWidgetState extends State<CountrySearchListWidget> {
  late TextEditingController _searchController = TextEditingController();
  late List<Country> filteredCountries;

  @override
  void initState() {
    final String value = _searchController.text.trim();
    filteredCountries = Utils.filterCountries(
      countries: widget.countries,
      locale: widget.locale,
      value: value,
    );
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Returns [InputDecoration] of the search box
  InputDecoration getSearchBoxDecoration() {
    return widget.searchBoxDecoration ??
        InputDecoration(labelText: 'Search by country name or dial code');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            key: Key(TestHelper.CountrySearchInputKeyValue),
            decoration: getSearchBoxDecoration(),
            controller: _searchController,
            autofocus: widget.autoFocus,
            onChanged: (value) {
              final String value = _searchController.text.trim();
              return setState(
                () => filteredCountries = Utils.filterCountries(
                  countries: widget.countries,
                  locale: widget.locale,
                  value: value,
                ),
              );
            },
          ),
        ),
        Flexible(
          child: widget.phoneInputSelectorType == PhoneInputSelectorType.CUSTOM
              ? CountryListWithScroller(
                  scrollController: widget.scrollController,
                  filteredCountries: filteredCountries,
                  scrollBarThumbColor: widget.scrollBarThumbColor,
                  scrollBarTrackColor: widget.scrollBarTrackColor,
                  locale: widget.locale,
                  showFlags: widget.showFlags!,
                  useEmoji: widget.useEmoji!,
                  phoneInputSelectorType: widget.phoneInputSelectorType)
              : ListView.builder(
                  controller: widget.scrollController,
                  shrinkWrap: true,
                  itemCount: filteredCountries.length,
                  itemBuilder: (BuildContext context, int index) {
                    Country country = filteredCountries[index];

                    return DirectionalCountryListTile(
                      country: country,
                      locale: widget.locale,
                      showFlags: widget.showFlags!,
                      useEmoji: widget.useEmoji!,
                      phoneInputSelectorType: widget.phoneInputSelectorType,
                    );
                    // return ListTile(
                    //   key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
                    //   leading: widget.showFlags!
                    //       ? _Flag(country: country, useEmoji: widget.useEmoji)
                    //       : null,
                    //   title: Align(
                    //     alignment: AlignmentDirectional.centerStart,
                    //     child: Text(
                    //       '${Utils.getCountryName(country, widget.locale)}',
                    //       textDirection: Directionality.of(context),
                    //       textAlign: TextAlign.start,
                    //     ),
                    //   ),
                    //   subtitle: Align(
                    //     alignment: AlignmentDirectional.centerStart,
                    //     child: Text(
                    //       '${country.dialCode ?? ''}',
                    //       textDirection: TextDirection.ltr,
                    //       textAlign: TextAlign.start,
                    //     ),
                    //   ),
                    //   onTap: () => Navigator.of(context).pop(country),
                    // );
                  },
                ),
        ),
      ],
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class DirectionalCountryListTile extends StatelessWidget {
  final Country country;
  final String? locale;
  final bool showFlags;
  final bool useEmoji;
  final PhoneInputSelectorType phoneInputSelectorType;

  const DirectionalCountryListTile(
      {super.key,
      required this.country,
      required this.locale,
      required this.showFlags,
      required this.useEmoji,
      required this.phoneInputSelectorType});

  @override
  Widget build(BuildContext context) {
    return phoneInputSelectorType == PhoneInputSelectorType.CUSTOM
        ? ListTile(
            key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
            leading: (showFlags
                ? _Flag(country: country, useEmoji: useEmoji)
                : null),
            title: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                '${Utils.getCountryName(country, locale)}',
                textDirection: Directionality.of(context),
                textAlign: TextAlign.start,
              ),
            ),
            trailing: FittedBox(
              child: Container(
                // margin: EdgeInsets.all(12),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                alignment: AlignmentDirectional.centerStart,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(12)),
                child: Text(
                  country.dialCode ?? '',
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ),
            onTap: () => Navigator.of(context).pop(country),
          )
        : ListTile(
            key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
            leading: (showFlags
                ? _Flag(country: country, useEmoji: useEmoji)
                : null),
            title: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                '${Utils.getCountryName(country, locale)}',
                textDirection: Directionality.of(context),
                textAlign: TextAlign.start,
              ),
            ),
            subtitle: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                '${country.dialCode ?? ''}',
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.start,
              ),
            ),
            onTap: () => Navigator.of(context).pop(country),
          );
  }
}

class _Flag extends StatelessWidget {
  final Country? country;
  final bool? useEmoji;

  const _Flag({Key? key, this.country, this.useEmoji}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null
        ? Container(
            child: useEmoji!
                ? Text(
                    Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                    style: Theme.of(context).textTheme.headlineSmall,
                  )
                : country?.flagUri != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          country!.flagUri,
                          package: 'intl_phone_number_input',
                          width: 50,
                          fit: BoxFit.contain,
                        ),
                      )
                    : SizedBox.shrink(),
          )
        : SizedBox.shrink();
  }
}

class CountryListWithScroller extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Country> filteredCountries;
  final String? locale;
  final bool showFlags;
  final bool useEmoji;
  final PhoneInputSelectorType phoneInputSelectorType;
  final Color? scrollBarThumbColor;
  final Color? scrollBarTrackColor;

  const CountryListWithScroller({
    super.key,
    required this.scrollController,
    required this.filteredCountries,
    required this.locale,
    required this.showFlags,
    required this.useEmoji,
    required this.phoneInputSelectorType,
    required this.scrollBarThumbColor,
    required this.scrollBarTrackColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: RawScrollbar(
        trackVisibility: true,
        thumbColor: scrollBarThumbColor,
        trackColor: scrollBarTrackColor, // Customize the track color

        radius: const Radius.circular(12), // Rounded corners for the scrollbar
        controller: scrollController,
        interactive: true, minThumbLength: 80,
        thumbVisibility: true, // This makes the scrollbar always visible
        child: ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          itemCount: filteredCountries.length,
          itemBuilder: (BuildContext context, int index) {
            Country country = filteredCountries[index];

            return DirectionalCountryListTile(
              country: country,
              locale: locale,
              showFlags: showFlags,
              useEmoji: useEmoji,
              phoneInputSelectorType: phoneInputSelectorType,
            );
          },
        ),
      ),
    );
  }
}
