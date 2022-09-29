# This script fetches the daily count data used to calculate the forecasting
# targets (weekly counts) for a given forecast date, using the values reported
# as of some specified date. It then calculates weekly count targets. Some extra
# setup is taken to allow fetching with either `epidatr` (new, faster) or
# `covidcast` (more stable), and some additional diagnostics. Jump to the end to
# see the usage.

library(magrittr) # for `%>%`

# --- Main fetching functions: ---

fetch_daily_with_epidatr = function(forecast_date, geo_type, geo_values, as_of) {
  target_date_range = target_date_range_for(forecast_date)
  validate_time_parameters(forecast_date, as_of)
  epidatr::covidcast("hhs", "confirmed_admissions_influenza_1d", "day", geo_type,
                     epidatr::epirange(format(target_date_range[[1L]], "%Y%m%d"),
                                       format(target_date_range[[2L]], "%Y%m%d")),
                     geo_values,
                     as_of = format(as_of, "%Y%m%d")
                     ) %>%
    epidatr::fetch_tbl()
}

fetch_daily_with_covidcast = function(forecast_date, geo_type, geo_values, as_of) {
  target_date_range = target_date_range_for(forecast_date)
  validate_time_parameters(forecast_date, as_of)
  covidcast::covidcast_signal("hhs", "confirmed_admissions_influenza_1d",
                              target_date_range[[1L]], target_date_range[[2L]],
                              geo_type, geo_values,
                              as_of=as_of)
}

# --- Helper functions: ---

saturday_preceding_monday = function(monday) {
  if (!identical(as.POSIXlt(forecast_date)$wday, 1L)) {
    rlang::abort("`monday` should be a single Monday")
  }
  monday - 2L
}

target_date_range_for = function(forecast_date) {
  saturday_preceding_deadline = saturday_preceding_monday(forecast_date)
  c(saturday_preceding_deadline + 1L, saturday_preceding_deadline + 7L*4L)
}

validate_time_parameters = function(forecast_date, as_of) {
  if (!inherits(forecast_date, "Date") && length(forecast_date) == 1L) {
    rlang::abort("`forecast_date` must be a single `Date`")
  }
  if (!inherits(as_of, "Date") && length(as_of) == 1L) {
    rlang::abort("`as_of` must be a single `Date`")
  }
  if (Sys.Date() < as_of) {
    rlang::abort("Can't fetch data `as_of` a date in the future.")
  } else if (Sys.Date() == as_of) {
    rlang::warn("Fetching data `as_of` today; if the data is updated in HealthData or Epidata later today, then this `as_of` data will change.", use_cli_format=TRUE)
  }
  saturday_preceding_deadline = saturday_preceding_monday(forecast_date)
  if (as_of <= saturday_preceding_deadline + 7L*4L) {
    rlang::abort("Not all targets for the requested `forecast_date` have observations as of the requested `as_of`; use a later `as_of` or custom code to handle the missingness.", use_cli_format=TRUE)
  } else if (as_of <= forecast_date + 7L*6L) {
    # (guidelines specify a single evaluation as_of that would avoid this warning for all forecast dates)
    rlang::warn("The requested `as_of` is within 6 weeks of the requested `forecast_date`; the 4 wk ahead target calculations might be missing some days due to reporting latency, and has a more substantial chance of changing due to data revisions during this period.", use_cli_format=TRUE)
  }
}

abbr_to_flusight_fips = function(abbr) {
  covidcast_fips = as.character(covidcast::abbr_to_fips(abbr))
  if (!all(abbr == "us" | substr(covidcast_fips, 3L, 5L) == "000")) {
    rlang::abort("Unexpected `abbr` entries encountered.")
  }
  dplyr::if_else(abbr == "us", "US", substr(covidcast_fips, 1L, 2L))
}

weekly_sum_from_daily = function(daily) {
  result_with_completeness = daily %>%
    # for each date, get the Saturday of the same epi week:
    dplyr::mutate(target_end_date = .data$time_value + (6L-as.POSIXlt(.data$time_value)$wday) %% 7L) %>%
    # calculate the weekly sums:
    dplyr::group_by(.data$geo_value, .data$target_end_date) %>%
    dplyr::summarize(value = sum(.data$value), n_days_in_week = dplyr::n(), .groups="drop")
  stopifnot(all(result_with_completeness$n_days_in_week <= 7L))
  partial_observations = result_with_completeness %>%
    dplyr::filter(.data$n_days_in_week < 7L)
  if (nrow(partial_observations) != 0L) {
    rlang::warn(
      paste(sep="\n",
            "There were partially-observed weeks and/or 0s reported as missing rows:",
            paste(collapse="\n", capture.output(print(
              partial_observations %>%
                dplyr::select(geo_value, target_end_date, n_days_in_week)
            ))),
            "For more details, enable `rlang::global_entrace()`, re-run, and look at",
            "`rlang::last_warnings()[[1]]$partial_observations`",
            "(assuming this is the only warning)."
            ),
      partial_observations = partial_observations
    )
  }
  result_with_completeness %>%
    dplyr::select(-n_days_in_week) %>%
    dplyr::mutate(location = abbr_to_flusight_fips(.data$geo_value))
}

# --- Usage: ---

# Arbitrary example values:
forecast_date = as.Date("2022-03-07")
as_of = as.Date("2022-09-01")

# epidatr and covidcast should yield the same daily results modulo some minor
# output format differences and download speed.
daily_nation_with_epidatr = fetch_daily_with_epidatr(forecast_date, "nation", "*", as_of)
daily_nation_with_covidcast = fetch_daily_with_covidcast(forecast_date, "nation", "*", as_of)

weekly_nation_with_epidatr = daily_nation_with_epidatr %>% weekly_sum_from_daily()
weekly_nation_with_covidcast = daily_nation_with_covidcast %>% weekly_sum_from_daily()
stopifnot(isTRUE(all.equal(weekly_nation_with_covidcast, weekly_nation_with_epidatr)))

# Same interface applies to fetching state data:
daily_state_with_epidatr = fetch_daily_with_epidatr(forecast_date, "state", "*", as_of)
