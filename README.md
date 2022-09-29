# flusight-helper-snippets
Snippets showing how to access archived HHS data through Delphi's Epidata API
using the `epidatr` and `covidcast` R packages and `epidatpy` and `covidcast`
Python packages.

## Python snippets
- (Run `install_dependencies_for_python.sh` first.)
- `basic.py`: shows basic daily data fetching for a time range, plus how to
  access historical versions
- `per100k_7dav_on_saturdays.py`: shows how to access counts per 100k
  population, 7-day-averaged, for a sequence of Saturdays

## R snippets
- (Run `install_dependencies_for_R.R` first.)
- `basic.R`: shows basic daily data fetching for a time range, plus how to
  access historical versions
- `per100k_7dav_on_saturdays.R`: shows how to access counts per 100k
  population, 7-day-averaged, for a sequence of Saturdays
- `flusight_targets_as_of.R`: shows how to fetch the daily data used to
  calculate the targets for some forecast date as of some later evaluation date,
  and how to recompute the weekly targets from the daily data. This snippet is a
  bit more verbose than the previous examples, as it includes helper functions
  to provide some sanity checks on the requests and data.
