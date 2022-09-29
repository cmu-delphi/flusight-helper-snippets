import datetime

import pandas as pd

import epidatpy.request
import covidcast

# Fetch daily HHS hospitalization count data for all states and territories for
# April 2022 using `epidatpy`, a draft new client package for accessing the
# Delphi Epidata API:
cce = epidatpy.request.CovidcastEpidata()
april = cce[("hhs", "confirmed_admissions_influenza_1d")].call(
    "state", "*",
    epidatpy.request.EpiRange(20220401, 20220430)
).df()

# Fetch these measurements as they were reported on May 10, rather than the
# current version:
april_as_of_may10 = cce[("hhs", "confirmed_admissions_influenza_1d")].call(
    "state", "*",
    epidatpy.request.EpiRange(20220401, 20220430),
    as_of = 20220510
).df()

# Fetch the first data set using the older `covidcast` package:
april_with_covidcast = covidcast.signal(
  "hhs", "confirmed_admissions_influenza_1d",
  datetime.date(2022, 4, 1), datetime.date(2022, 4, 30),
  "state", "*"
)
