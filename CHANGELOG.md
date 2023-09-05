# Changelog

## 0.3.10 (05.09.2023)
* Update all dependencies.
  | Package | Type | Update | Change |
  |---|---|---|---|
  | [actions/cache](https://togithub.com/actions/cache) | action | minor | `v3.2.3` -> `v3.3.1` |
  | [actions/checkout](https://togithub.com/actions/checkout) | action | major | `v3.3.0` -> `v4.0.0` |
  | [erlef/setup-elixir](https://togithub.com/erlef/setup-elixir) | action | minor | `v1.15.2` -> `v1.16.0` |
  | [github/codeql-action](https://togithub.com/github/codeql-action) | action | minor | `v2.1.37` -> `v2.21.5` |
  | [ossf/scorecard-action](https://togithub.com/ossf/scorecard-action) | action | minor | `v2.1.2` -> `v2.2.0` |
  | [step-security/harden-runner](https://togithub.com/step-security/harden-runner) | action | minor | `v2.1.0` -> `v2.5.1` |
* Lock ubuntu version to `ubuntu-20.04` in CI/CD.
* Ignore updates for `ubuntu`.

## 0.3.9 (16.01.2023)
* Update all dependencies.
* Block egress traffic in GitHub Actions.
* Add stability badge in README.

## 0.3.8 (27.12.2022)
* Add Renovate as dependency update tool.
* Add default permissions as read-only in the CI workflow.

## 0.3.7 (23.12.2022)
* Harden GitHub Actions.

## 0.3.6 (21.12.2022)
* Bump ossf/scorecard-action to v2.0.6.

## 0.3.5 (21.12.2022)
* Update build badge and lock to ubuntu-20.04.

## 0.3.4 (25.10.2022)
* Enable ExCoveralls with parallel builds.

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
