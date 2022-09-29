# This script fetches the latest version of a *7-day-averaged* hospitalizations
# *per 100k population* for a fixed set of times and locations (see
# https://cmu-delphi.github.io/delphi-epidata/api/covidcast-signals/hhs.html
# for other available signals and transformations for this data source). See
# the `as_of` argument for getting older versions of the data.

import pandas as pd
import epidatpy.request
import covidcast

def main():
  saturdays = pd.date_range(start="2021-07-03", end="2022-07-02", freq="W")
  geo_values = "*"

  # Two equivalent ways, neglecting some speed and formatting differences:

  # using `epidatpy`, a draft new client package for the Delphi Epidata API:
  cce = epidatpy.request.CovidcastEpidata()
  prop_7dav_state_latest = cce[("hhs", "confirmed_admissions_influenza_1d_prop_7dav")].call(
    "state", geo_values,
    list(saturdays.strftime("%Y%m%d"))
  ).df()[["geo_value", "time_value", "value", "signal"]]
  print(prop_7dav_state_latest)

  # using the older `covidcast` package:
  def fetch_for_saturday(saturday):
    return covidcast.signal(
      "hhs", "confirmed_admissions_influenza_1d_prop_7dav",
      start_day = saturday, end_day = saturday,
      geo_type = "state", geo_values = geo_values
    )
  fetches = saturdays.to_series().apply(fetch_for_saturday)
  prop_7dav_state_latest2 = pd.concat(list(fetches))[["geo_value", "time_value", "value", "signal"]]
  print(prop_7dav_state_latest2)

if __name__ == "__main__":
    main()
