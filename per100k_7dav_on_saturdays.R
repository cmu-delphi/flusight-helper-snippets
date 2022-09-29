# This script fetches the latest version of a *7-day-averaged* hospitalizations
# *per 100k population* for a fixed set of times and locations (see
# https://cmu-delphi.github.io/delphi-epidata/api/covidcast-signals/hhs.html for
# other available signals and transformations for this data source). See the
# `as_of` argument for getting older versions of the data.

library(magrittr) # for `%>%`

saturdays = seq(as.Date("2021-07-03"), as.Date("2022-07-02"), by="week")
geo_values = "*" # or, e.g., `c("id", "mi")` for select locations

# Three equivalent ways, neglecting some speed and formatting differences:

# using `epidatr`, a draft new client package for the Delphi Epidata API:
cce = epidatr::covidcast_epidata()
hhs = cce$sources$hhs
prop_7dav_state_latest =
  hhs$signals$confirmed_admissions_influenza_1d_prop_7dav$call(
    "state", geo_values,
    format(saturdays, "%Y%m%d")
  ) %>%
  epidatr::fetch_tbl() %>%
  dplyr::select(geo_value, time_value, value, signal)

# using alternative `epidatr` interface more similar to `covidcast` package:
prop_7dav_state_latest2 =
  epidatr::covidcast(
    "hhs", "confirmed_admissions_influenza_1d_prop_7dav",
    "day", "state",
    format(saturdays, "%Y%m%d"),
    geo_values
  ) %>%
  epidatr::fetch_tbl() %>%
  dplyr::select(geo_value, time_value, value, signal)

# using the older `covidcast` package:
prop_7dav_state_latest3 =
  saturdays %>%
  purrr::map_dfr(function(saturday) {
    covidcast::covidcast_signal(
      "hhs", "confirmed_admissions_influenza_1d_prop_7dav",
      start_day = saturday, end_day = saturday,
      "state", geo_values
    )
  }) %>%
  dplyr::as_tibble() %>%
  dplyr::select(geo_value, time_value, value, signal)
