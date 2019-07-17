# mu-demo-locust

A cookbook to install [locust](https://locust.io/).

## Requirements

Chef 12.14 or newer is required

## Attributes

Attributes are used to configure the default recipe.

* `node['deployment']['application_attributes']['test_repo']` - add an optional public repo to clone. *(default: null)*

## Recipes

### `default`

The default recipe installs Locustio and optionally checks out a test repo into `/test`

## License
see LICENSE

## Authors
[Zach Rowe](zachary.rowe@eglobaltech.com)

