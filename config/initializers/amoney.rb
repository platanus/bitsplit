Money.locale_backend = :i18n

MoneyRails.configure do |config|
  
  config.register_currency = {
    priority: 1,
    iso_code: "SAT",
    name: "Satoshis",
    symbol: "🐉",
    disambiguate_symbol: "SAT$",
    alternate_symbols: [],
    subunit: "Peso",
    subunit_to_unit: 1,
    symbol_first: true,
    html_entity: "&#36;",
    decimal_mark: ".",
    thousands_separator: ",",
    smallest_denomination: 1
  }
end
