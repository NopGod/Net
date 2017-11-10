#!/usr/bin/perl

```perl -e "foreach (0..999999){ $xx = '77720'.sprintf '%.6d', $_; print $xx.$_.\"\n\" foreach (A..Z)}" >> tel_AZ.txt```
```perl -e "foreach (0..999999){ $xx = '77720'.sprintf '%.6d', $_; print $xx.$_.\"\n\" foreach (a..z)}" >> tel_az.txt```
```perl -e "foreach (0..999999){ $xx = '77720'.sprintf '%.6d', $_; print $xx.\"\n\"}" >> tel.txt```
