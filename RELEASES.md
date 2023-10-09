This details significant and/or breaking changes of the affinda self hosted stack.

## V6.15.0 - 2023-10-09

- The frontend application is now available at /app
- Extended the timeout for regular cleanup task for expired documents, fixing a  bug where old expired documents were not removed
- Significantly increased speed of GET /v2/resumes requests

## V6.1.0 - 2023-06-21

- Updated docs for creating API keys, ensure frontend works to allow these keys to be created
- Deprecate undocumented support for `api.localhost/api`, only support `localhost/api` and `api.localhost` now.

## V6.0.0 - 2023-04-12

### Breaking changes:

- Updated inference model names

## V5.0.0 - 2023-03-24

### Breaking changes:

- Changed repository references to new AWS account
- Changed inference container to new repo `affinda-inference-selfhosted-resumes`

### Other changes:

- Update README for new functionality of portal (app.localhost) and API v3 support
- Many fixes to API spec - see changelog
  of [the python client for details of API changes](https://github.com/affinda/affinda-python/blob/master/CHANGELOG.md)