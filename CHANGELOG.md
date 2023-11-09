# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [6.15.0] - 2023-10-09

### Added

- The frontend application is now available at /app

### Fixed

- Extended the timeout for regular cleanup task for expired documents, fixing a bug where old expired documents were not
  removed
- Significantly increased speed of GET /v2/resumes requests

## [6.1.0] - 2023-06-21

### Fixed

- Updated docs for creating API keys, ensure frontend works to allow these keys to be created

### Removed

- Deprecate undocumented support for `api.localhost/api`, only support `localhost/api` and `api.localhost` now.

## [6.0.0] - 2023-04-12

### Changed

- Updated inference model names (breaking change)

## [5.0.0] - 2023-03-24

### Changed

- Changed repository references to new AWS account
- Changed inference container to new repo `affinda-inference-selfhosted-resumes`
- Update README for new functionality of portal (app.localhost) and API v3 support
- Many fixes to API spec - see changelog
  of [the python client for details of API changes](https://github.com/affinda/affinda-python/blob/master/CHANGELOG.md)
