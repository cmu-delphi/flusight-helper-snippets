# flusight-helper-snippets
This repository contains code snippets showing how to access the
latest NHSN and NSSP data, as well as how to access version history of
data sets, through Delphi's Epidata API using the `epidatr` R package
and `epidatpy` Python package.

These scripts are built for epidatr 1.4+ and epidatpy 0.7+; if you are
on an older version, please try the relevant install scripts.  If you
encounter any problems, please file a bug report here or in the
relevant client repository:
[cmu-delphi/delphi-epidata](https://github.com/cmu-delphi/delphi-epidata/),
[cmu-delphi/epidatpy](https://github.com/cmu-delphi/epidatpy/), or
[cmu-delphi/epidatr](https://github.com/cmu-delphi/epidatr/).

## Python snippets
- (Run `install_dependencies_for_python.sh` first.)
- `basic.py`: shows how to fetch the latest data for NHSN and NSSP, as well as an example of fetching version history

## R snippets
- (Run `install_dependencies_for_R.R` first.)
- `basic.R`: shows how to fetch the latest data for NHSN and NSSP, as well as an example of fetching version history
