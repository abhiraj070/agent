import '../../domain/entities/country.dart';

/// Curated dial-code list for the phone-entry country picker. India is
/// first/default since it's the app's primary market; the rest are sorted
/// alphabetically by name.
class CountryCodes {
  const CountryCodes._();

  static const Country defaultCountry = Country(name: 'India', isoCode: 'IN', dialCode: '+91');

  static const List<Country> all = [
    defaultCountry,
    Country(name: 'Afghanistan', isoCode: 'AF', dialCode: '+93'),
    Country(name: 'Australia', isoCode: 'AU', dialCode: '+61'),
    Country(name: 'Bangladesh', isoCode: 'BD', dialCode: '+880'),
    Country(name: 'Bhutan', isoCode: 'BT', dialCode: '+975'),
    Country(name: 'Brazil', isoCode: 'BR', dialCode: '+55'),
    Country(name: 'Canada', isoCode: 'CA', dialCode: '+1'),
    Country(name: 'China', isoCode: 'CN', dialCode: '+86'),
    Country(name: 'Egypt', isoCode: 'EG', dialCode: '+20'),
    Country(name: 'France', isoCode: 'FR', dialCode: '+33'),
    Country(name: 'Germany', isoCode: 'DE', dialCode: '+49'),
    Country(name: 'Hong Kong', isoCode: 'HK', dialCode: '+852'),
    Country(name: 'Indonesia', isoCode: 'ID', dialCode: '+62'),
    Country(name: 'Ireland', isoCode: 'IE', dialCode: '+353'),
    Country(name: 'Italy', isoCode: 'IT', dialCode: '+39'),
    Country(name: 'Japan', isoCode: 'JP', dialCode: '+81'),
    Country(name: 'Kenya', isoCode: 'KE', dialCode: '+254'),
    Country(name: 'Kuwait', isoCode: 'KW', dialCode: '+965'),
    Country(name: 'Malaysia', isoCode: 'MY', dialCode: '+60'),
    Country(name: 'Maldives', isoCode: 'MV', dialCode: '+960'),
    Country(name: 'Mauritius', isoCode: 'MU', dialCode: '+230'),
    Country(name: 'Nepal', isoCode: 'NP', dialCode: '+977'),
    Country(name: 'Netherlands', isoCode: 'NL', dialCode: '+31'),
    Country(name: 'New Zealand', isoCode: 'NZ', dialCode: '+64'),
    Country(name: 'Nigeria', isoCode: 'NG', dialCode: '+234'),
    Country(name: 'Oman', isoCode: 'OM', dialCode: '+968'),
    Country(name: 'Pakistan', isoCode: 'PK', dialCode: '+92'),
    Country(name: 'Philippines', isoCode: 'PH', dialCode: '+63'),
    Country(name: 'Qatar', isoCode: 'QA', dialCode: '+974'),
    Country(name: 'Saudi Arabia', isoCode: 'SA', dialCode: '+966'),
    Country(name: 'Singapore', isoCode: 'SG', dialCode: '+65'),
    Country(name: 'South Africa', isoCode: 'ZA', dialCode: '+27'),
    Country(name: 'South Korea', isoCode: 'KR', dialCode: '+82'),
    Country(name: 'Sri Lanka', isoCode: 'LK', dialCode: '+94'),
    Country(name: 'Spain', isoCode: 'ES', dialCode: '+34'),
    Country(name: 'Sweden', isoCode: 'SE', dialCode: '+46'),
    Country(name: 'Switzerland', isoCode: 'CH', dialCode: '+41'),
    Country(name: 'Thailand', isoCode: 'TH', dialCode: '+66'),
    Country(name: 'United Arab Emirates', isoCode: 'AE', dialCode: '+971'),
    Country(name: 'United Kingdom', isoCode: 'GB', dialCode: '+44'),
    Country(name: 'United States', isoCode: 'US', dialCode: '+1'),
    Country(name: 'Vietnam', isoCode: 'VN', dialCode: '+84'),
  ];
}
