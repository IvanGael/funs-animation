// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Country {
  final String flagPng;
  final String flagSvg;
  final String flagAlt;
  final String postalFormat;
  final String postalRegex;
  final String commonName;
  final String officialName;
  final Map<String, String> nativeNames;
  final String cca2;
  final Map<String, Currency> currencies;
  final String iddRoot;
  final List<String> iddSuffixes;
  final List<String> capitals;
  final String region;
  final String subregion;
  final Map<String, String> languages;
  final int population;
  bool isSelected = false;

  Country({
    required this.flagPng,
    required this.flagSvg,
    required this.flagAlt,
    required this.postalFormat,
    required this.postalRegex,
    required this.commonName,
    required this.officialName,
    required this.nativeNames,
    required this.cca2,
    required this.currencies,
    required this.iddRoot,
    required this.iddSuffixes,
    required this.capitals,
    required this.region,
    required this.subregion,
    required this.languages,
    required this.population,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      flagPng: json['flags']?['png'] ?? '',
      flagSvg: json['flags']?['svg'] ?? '',
      flagAlt: json['flags']?['alt'] ?? '',
      postalFormat: json['postalCode']?['postalFormat'] ?? '',
      postalRegex: json['postalCode']?['postalRegex'] ?? '',
      commonName: json['name']?['common'] ?? '',
      officialName: json['name']?['official'] ?? '',
      nativeNames: json['name']?['nativeName'] != null
          ? Map<String, String>.from(json['name']['nativeName']
              .map((key, value) => MapEntry(key, value['common'] ?? '')))
          : {},
      cca2: json['cca2'] ?? '',
      currencies: json['currencies'] != null
          ? Map<String, Currency>.from(json['currencies']
              .map((key, value) => MapEntry(key, Currency.fromJson(value))))
          : {},
      iddRoot: json['idd']?['root'] ?? '',
      iddSuffixes: json['idd']?['suffixes'] is List
          ? List<String>.from(json['idd']['suffixes'])
          : [],
      capitals:
          json['capital'] is List ? List<String>.from(json['capital']) : [],
      region: json['region'] ?? '',
      subregion: json['subregion'] ?? '',
      languages: json['languages'] != null
          ? Map<String, String>.from(json['languages'])
          : {},
      population: json['population'] ?? 0,
    );
  }
}

class Currency {
  final String name;
  final String symbol;

  Currency({required this.name, required this.symbol});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
    );
  }
}

class CountriesDiscoverHome extends StatefulWidget {
  const CountriesDiscoverHome({super.key});

  @override
  State<CountriesDiscoverHome> createState() => _CountriesDiscoverHomeState();
}

class _CountriesDiscoverHomeState extends State<CountriesDiscoverHome> {
  List<Country> countries = [];
  List<Country> filteredCountries = [];
  Country? selectedCountry;
  String selectedFilter = 'Languages';
  List<String> filterOptions = ['Languages', 'Currencies', 'Regions'];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  String removeAccents(String str) {
    var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';
    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }
    return str;
  }

  Future<void> fetchCountries() async {
    try {
      final String response = await rootBundle.loadString('assets/countries.json');
      final List<dynamic> data = json.decode(response);
      List<Country> loadedCountries = data.map((countryData) => Country.fromJson(countryData)).toList();

      loadedCountries.sort((a, b) => removeAccents(a.commonName).compareTo(removeAccents(b.commonName)));

      setState(() {
        countries = loadedCountries;
        filteredCountries = List.from(countries);
        selectedCountry = countries[Random().nextInt(countries.length)];
        selectedCountry!.isSelected = true;
      });
    } catch (error) {
      throw Exception('Failed to load countries: $error');
    }
  }

  void handleCountryTap(Country country) {
    setState(() {
      if (selectedCountry != null) {
        selectedCountry!.isSelected = false;
      }
      if (selectedCountry == country) {
        selectedCountry = null;
      } else {
        selectedCountry = country;
        selectedCountry!.isSelected = true;
      }
    });
  }

  void filterCountries(String filter, String option) {
    setState(() {
      selectedFilter = filter;
      if (filter == 'Languages') {
        filteredCountries = countries
            .where((country) => country.languages.containsValue(option))
            .toList();
      } else if (filter == 'Currencies') {
        filteredCountries = countries
            .where((country) => country.currencies.containsKey(option))
            .toList();
      } else if (filter == 'Regions') {
        filteredCountries =
            countries.where((country) => country.region == option).toList();
      }
    });
  }

  Future<void> _openFilterModal(BuildContext context) async {
    List<String> options = [];
    switch (selectedFilter) {
      case 'Languages':
        options = ['English', 'French', 'Spanish', 'German'];
        break;
      case 'Currencies':
        options = ['USD', 'EUR', 'GBP', 'JPY'];
        break;
      case 'Regions':
        options = ['Europe', 'Asia', 'Africa', 'Americas'];
        break;
    }

    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return FilterModal(
          selectedFilter: selectedFilter,
          options: options,
        );
      },
    );
    if (result != null) {
      filterCountries(selectedFilter, result);
    }
  }

  void searchCountries(String query) {
    setState(() {
      filteredCountries = countries
          .where((country) =>
              removeAccents(country.commonName).toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Countries",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        elevation: 10,
        shadowColor: Colors.blueAccent,
        toolbarHeight: 75,
        backgroundColor: Colors.indigoAccent,
        bottom: PreferredSize(
            preferredSize: const Size(200, 30),
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(6)),
              child: TextField(
                controller: searchController,
                onChanged: (query) {
                  searchCountries(query);
                },
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  hintText: "Search country...",
                  hintStyle: TextStyle(
                    color: Colors.white70,
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
              ),
            )),
        actions: [
          DropdownButton<String>(
            value: selectedFilter,
            icon: const Icon(Icons.filter_list, color: Colors.white),
            dropdownColor: Colors.indigoAccent,
            underline: Container(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                // Set the selectedFilter when an option is chosen
                setState(() {
                  selectedFilter = newValue;
                });
                // Open the filter modal
                _openFilterModal(context);
              }
            },
            items: filterOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: filteredCountries.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.indigoAccent),
            ))
          : ListView.builder(
              itemCount: filteredCountries.length,
              itemBuilder: (context, index) {
                final country = filteredCountries[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                  ),
                  child: ListTile(
                    leading: Image.network(
                      country.flagPng,
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                    title: Text(
                      country.commonName,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(country.officialName),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CountryDetailsScreen(
                            country: country,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: (){

              },
              label: Text(
                "${filteredCountries.length} results"
              ),
            ),
    );
  }
}

class FilterModal extends StatefulWidget {
  final String selectedFilter;
  final List<String> options;

  const FilterModal({
    super.key,
    required this.selectedFilter,
    required this.options,
  });

  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select ${widget.selectedFilter}'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.options
              .map(
                (option) => RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                    });
                  },
                  activeColor: Colors.indigoAccent,
                ),
              )
              .toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedOption);
          },
          child: Text(
            'Apply',
            style: TextStyle(color: Colors.indigoAccent.shade700),
          ),
        ),
      ],
    );
  }
}

class CountryDetailsScreen extends StatelessWidget {
  final Country country;

  const CountryDetailsScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 14,
                )),
            const SizedBox(
              width: 8,
            ),
            SizedBox(
              width: 300,
              child: Text(
                country.commonName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.indigoAccent,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                width: 140,
                height: 140,
                child: CircleAvatar(
                    backgroundImage: NetworkImage(country.flagPng)),
              ),
              // Image.network(country.flagPng, height: 100),
            ),
            const SizedBox(height: 8.0),
            Center(
                child: Text(country.officialName,
                    style: const TextStyle(fontSize: 20))),
            const SizedBox(height: 16.0),
            _buildSectionHeader('Basic Info'),
            _buildInfoRow('Capital',
                country.capitals.isNotEmpty ? country.capitals.first : 'N/A'),
            _buildInfoRow('Postal Code Format', country.postalFormat),
            _buildInfoRow('CCA2', country.cca2),
            _buildInfoRow('Population', country.population.toString()),
            _buildSectionHeader('Geography'),
            _buildInfoRow('Region', country.region),
            _buildInfoRow('Subregion', country.subregion),
            _buildSectionHeader('Languages'),
            ...country.languages.entries
                .map((entry) => _buildInfoRow(entry.key, entry.value)),
            _buildSectionHeader('Economy'),
            ...country.currencies.entries.map((entry) => _buildInfoRow(
                entry.key, '${entry.value.name} (${entry.value.symbol})')),
            _buildSectionHeader('Communication'),
            _buildInfoRow(
                'IDD', country.iddRoot + country.iddSuffixes.join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.lightBlue),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(
              width: 200,
              child: Text(
                value,
                style: const TextStyle(fontSize: 18),
              )),
        ],
      ),
    );
  }
}
