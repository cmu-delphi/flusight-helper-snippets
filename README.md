# flusight-helper-snippets
This repository contains code snippets showing how to access archived HHS data
through Delphi's Epidata API using the `epidatr` and `covidcast` R packages and
`epidatpy` and `covidcast` Python packages.

If you encounter problems such as "Error: '' does not exist in current working
directory", please re-run the installation script, then try again in a fresh
session. If problems persist, please file a bug report here or in the relevant
client repository: cmu-delphi/covidcast, cmu-delphi/epidatpy, or
cmu-delphi/epidatr.

## Python snippets
- (Run `install_dependencies_for_python.sh` first.)
- `basic.py`: shows basic daily data fetching for a time range, plus how to
  access historical versions

## R snippets
- (Run `install_dependencies_for_R.R` first.)
- `basic.R`: shows basic daily data fetching for a time range, plus how to
  access historical versions
