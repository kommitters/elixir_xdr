# Changelog

## 0.3.3 (18.10.2022)
* Include OpenSSF BestPractices & Scorecard in README.

## 0.3.2 (08.08.2022)
- Add scorecards actions

## 0.3.1 (25.07.2022)

- Add security policy to the repository

## 0.3.0 (19.07.2022)
* Automate publishing releases

## 0.2.0 (27.08.2021)
* Fix array's elements encoding bug.
* Refactor library exceptions.
* Credo integration.
* Code cleanup.

## 0.1.6 (25.08.2021)
* Solve success-typing dialyzer warnings.
* Properly define typespecs.
* Remove compilation warnings from old dependencies.
* Improve library documentation.

## 0.1.5 (09.08.2021)
* Fix max length issue on Strings.
* Fix issues encoding/decoding discriminated unions.

## 0.1.4 (30.06.2020)

* Improve README.
* Improve documentation of all the XDR types for Hexdocs.
* Added custom implementations of all the XDR types to examples for Hexdocs.
* Improve functions specs for all the XDR types.
* Improve Discriminated Union allowing add module as arm type.
* Add Discriminated Union with `:default` arm.
* Improve Void allowing return remaining binary after decoding.
* Fix maximum default length set to Variable-Length Array.
* Add some unit tests.
* Improve the documentation and some implementations of all XDR types modules.

## 0.1.3 (22.05.2020)

* Increase test coverage to 100%
* The encode_xdr() and decode_xdr() functions now return error tuples
* The encode_xdr!() and decode_xdr!() functions raise the errors
* Add examples of all the XDR-types to README
* Add examples to Hexdocs
* Remove Anti-Patterns

## 0.1.2 (18.05.2020)

* Add support for older Elixir versions strating from 1.7.0.
* Setup ExCoveralls and Credo for code quality.
* Improve readme file.
* Add project badges.

## 0.1.1 (15.05.2020)

Initial release
