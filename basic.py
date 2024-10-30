import datetime

import pandas as pd

from epidatpy import CovidcastEpidata, EpiDataContext, EpiRange

# All calls using the `epidata` object will be cached for a day
epidata = EpiDataContext(use_cache=True, cache_max_age_days=1)

# Fetch daily HHS hospitalization count data for all states and territories for
# April 2022:
april = epidata.pub_covidcast(
    data_source = "hhs",
    signals = "confirmed_admissions_influenza_1d",
    geo_type = "nation",
    time_type = "day",
    geo_values = "*",
    time_values = EpiRange(20220401, 20220430)
).df()
# (You can also use `time_values = "*"` to get data for all times, or
# `time_values = array_of_dates` to get data for those dates.)

# Fetch these measurements as they were reported on May 10, rather than the
# current version:
april_as_of_may10 = epidata.pub_covidcast(
    data_source = "hhs",
    signals = "confirmed_admissions_influenza_1d",
    geo_type = "nation",
    time_type = "day",
    geo_values = "*",
    time_values = EpiRange(20220401, 20220430),
    as_of = 20220510
).df()
