#!perl -w

# $Id: zpod.t 3888 2008-05-13 23:10:10Z david $

use strict;
use Test::More;
eval 'use Test::Pod 1.20';
plan skip_all => 'Test::Pod 1.20 required for testing POD' if $@;
all_pod_files_ok();
