/*
 * jsperf.monitor.top
 * https://github.com/kurohara/jsperf.monitor.top
 *
 * Copyright (c) 2015 Hiroyoshi Kurohara
 * Licensed under the MIT the license.
 */

'use strict';

var fs = require('fs');

var Monitor = function Monitor(params) {
  this.syntax = fs.readFileSync(__dirname + '/top.jison', 'utf8');
  this.args = [ "-l", "0" ];
  if (params.interval) {
    this.args.push("-i");
    this.args.push("" + params.interval);
  }
  this.dataname = "top";
};

module.exports = Monitor;
