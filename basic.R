library(magrittr) # for `%>%`

# Enable caching of some version history queries:
epidatr::set_cache()

# Fetch daily HHS hospitalization count data for all states and territories for
# April 2022 using `epidatr`:
april = epidatr::pub_covidcast(
  source = "hhs",
  signals = "confirmed_admissions_influenza_1d",
  geo_type = "state",
  time_type = "day",
  geo_values = "*",
  time_values = epidatr::epirange(20220401, 20220430)
)
# (You can also use `time_values = "*"` to get data for all times, or
# `time_values = date_vector` to get data for those dates.)

# Fetch these measurements as they were reported on May 10, rather than the
# current version:
april_as_of_may10 =
  epidatr::pub_covidcast(
    "hhs", "confirmed_admissions_influenza_1d",
    "state", "day",
    "*", epidatr::epirange(20220401, 20220430),
    as_of = 20220510
  )
