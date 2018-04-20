# Mu Demo Platform


[![pipeline status](https://gitlab.com/cloudamatic/mu_demo_platform/badges/master/pipeline.svg)](https://gitlab.com/cloudamatic/mu_demo_platform/commits/master)
[![coverage report](https://gitlab.com/cloudamatic/mu_demo_platform/badges/master/coverage.svg)](https://gitlab.com/cloudamatic/mu_demo_platform/commits/master)
[![Maintainability](https://api.codeclimate.com/v1/badges/9bdfaf3844413c136ad7/maintainability)](https://codeclimate.com/github/cloudamatic/mu_demo_platform/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/9bdfaf3844413c136ad7/test_coverage)](https://codeclimate.com/github/cloudamatic/mu_demo_platform/test_coverage)

This repository contains demos Baskets of Kitten's (BoK's) for [Cloudamatic's ***mu***](https://github.com/cloudamatic/mu).

Please see [`/applications/README.md`](./applications/README.md) for more information about the demos that are currently avaiable.

## Framework
`/applications` contains the BoK yaml files that ***mu*** uses to provision new servers, and to define the other resources necicary for application deployments.

`/cookbooks` contains the cookbooks that install the actual demo applications on the virtual servers.

`/databags` contains Chef data_bags that are needed for the applications.

`/roles` contains Chef roles that are needed for the applications.

`/utils` contains other utilities that are helpful for deployments and machine maintance.