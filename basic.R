library(magrittr) # for `%>%`

# Fetch daily HHS hospitalization count data for all states and territories for
# April 2022 using `epidatr`, a draft new client package for accessing the
# Delphi Epidata API:
april = epidatr::covidcast(
  "hhs", "confirmed_admissions_influenza_1d",
  "day", "state",
  time_values = epidatr::epirange(20220401, 20220430),
  geo_values = "*"
) %>%
  epidatr::fetch_tbl()

# Fetch these measurements as they were reported on May 10, rather than the
# current version:
april_as_of_may10 =
  epidatr::covidcast(
    "hhs", "confirmed_admissions_influenza_1d",
    "day", "state",
    epidatr::epirange(20220401, 20220430),
    "*",
    as_of = 20220510
  ) %>%
  epidatr::fetch_tbl()

# Fetch the first data set using the older `covidcast` package:
april_with_covidcast = covidcast::covidcast_signal(
  "hhs", "confirmed_admissions_influenza_1d",
  as.Date("2022-04-01"), as.Date("2022-04-30"),
  "state", "*"
)
