## Grid generation for 0.25 degree OM4

This is a subset of the preprocessing stage needed for the 0.25 degree OM4 ocean model.

The committed answers (md5sums.txt) require a specific environment that is recorded in Jenkins.csh.

Use
```bash
./Jenkins.csh
```
on PAN at GFDL to reproduce answers.

use
```bash
make
```
to generate files on other platforms.

These scripts makes use of a particular version of [MIDAS](https://github.com/mjharriso/MIDAS) which is recorded in the Makefile.
