# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [7.54.1] - 2025-06-20

*Note: this release contains the `text_extraction` container ONLY.
This release is fully compatible with v6.33.445.*

### Fixed
- Memory leak in `text_extraction` container

## [6.33.445] - 2024-12-31
### Added
- Add Job Description extractor

## [6.33.264] - 2024-10-09
### Added
- add optional MDS_TO_SKIP_IMPORT env var for skipping mapping data sources on import
- add ENABLED_EXTRACTORS to control which extractors are enabled in web/celery workers

## [6.33.128] - 2024-08-07
### Added
- Health check for celery container

## [6.33.86] - 2024-07-23
### Fixed
- Improved unpacking on first boot for clustered deployments

## [6.33.79] - 2024-07-16
### Added
- Updates for v4 resume parser

## [6.33.73] - 2024-07-12
### Added
- PELIAS_GEOCODE_CITY_KEYS and PELIAS_GEOCODE_VERSION environment variables

### Fixed
- Improved handling of apartment numbers with global Pelias dataset

## [6.33.67] - 2024-07-09
### Fixed
- Issue with enableValidationTool: false

## [6.33.45] - 2024-06-22
### Added
- Add pdf2html service
- Added support for arbitarily nested validation rule sources across multiple datapoints
- reading order image

### Changed
- garbage detector thresholds

## [6.31.92] - 2024-06-03
### Fixed
- Various performance improvements and fixes

## [6.31.47] - 2024-05-10
### Added
- Add `Field.hideEnumDetail` to hide the hoverable enum value detail icon.

## [6.30.3] - 2024-04-15
### Added
- Added dependency on opensearch service
- Added support for resume-v4 (NextGen) in selfhosted
- Added support for custom extractors including resume-v4 Next Gen

### Changed
- Changed default CELERY_WORKER_CONCURRENCY to 3 for celery workers, 1 for celery beat

## [6.29.72] - 2024-03-28
### Added
- Enum detail popover. Hover the information icon to see and copy value details
- New framework for managing taxonomies.  In the field editor dialogue you can now choose between available taxonomies
- Add types for search tool theme config
- for a given field.  New taxonomies can be added via the API or the field editor.
- First release of collection-level validation rules

### Changed
- Ability to change the datatype of a field after creation.
- Requesting tailored models is now only available for collections in the AP category
- Custom field creation UI visibility can be controlled at an organisational level
- Deprecate `Field.showDropdown`. A dropdown will now automatically be shown for enum fields and text fields with a `dataSource`.

### Fixed
- Fix showing zero as empty in integer and float inputs
- Fixed being able to add fields to tables when custom fields are disabled
- Fixed rectless annotations should inherit the pageIndex of their parent if they have one

## [6.21.10] - 2023-11-15
### Added
- Show organization ID in settings

### Changed
- More clearly de-emphasise other non-child annotations when focussing on a group or table
- Make document table row controls and customize column buttons sticky
- Document.identifier has been made globally unique, and replaced with customIdentifier where users would like topass through their own identifiers for a document.

### Fixed
- Fixed error when selecting a choice for a rectless field
- Fixed an issue where the selection of the next unconfirmed annotation was being immediately undone
- Annotation confirmed event not triggered by sidebar
- Significant performance improvements in the validation tool for large and complex documents
- Fixed issue where incorrect currency values could be introduced for some currency codes

## [6.15.0] - 2023-10-09
### Added
- The frontend application is now available at /app

### Fixed
- Extended the timeout for regular cleanup task for expired documents, fixing a bug where old expired documents were not
- removed
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
- of [the python client for details of API changes](https://github.com/affinda/affinda-python/blob/master/CHANGELOG.md)
