# jsperf.monitor.top

The monitor module for [jsperf](https://github.com/kurohara/jsperf) that runs 'top' command.
This module is developed with using 'top' command of MacOSX.

## Getting Started
See [jsperf readme](https://github.com/kurohara/jsperf/blob/master/README.md) for usage of this system.
You need to install this monitor like as `npm install jsperf.monitor.top` so that jsperf can use this module.
After installing, invoke jsperf as:
```
node jsperf/bin/jsperf.js -m top -d mongo
```
Because there is only mongodb datastore module at this moment, you have to start up mongodb server to make this command work properly.

## Documentation
_(Coming soon)_

## Examples
_(Coming soon)_

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## Release History
_(Nothing yet)_

## License
Copyright (c) 2015 Hiroyoshi Kurohara  
Licensed under the MIT license.
