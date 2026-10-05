library(magrittr) # for `%>%`
library(epidatr)

# Fetch latest NHSN hospitalization data for all states and territories:
nhsn_latest <- epidata("nhsn", "confirmed_admissions_flu_ew", "state")

# Fetch latest NSSP data:
nssp_latest <- epidata("nssp", "pct_ed_visits_influenza", "state")

# Fetch NHSN hospitalization revision history:
nhsn_history <- epidata_archive("nhsn", "confirmed_admissions_flu_ew", "state")

# See also the {epiprocess} package for working with the time series
# data and revision histories, and {epipredict} for some
# "plug-and-predict" forecasters.

# Browse available signals (see also
# https://cmu-delphi.github.io/delphi-epidata/api/v5_signals.html
# and
# https://delphi.cmu.edu/epiportal/
# ):
meta <- epidata_meta()
signals_by_source <- meta %>% lapply(function(x) x$signals)
names(signals_by_source)
signals_by_source[["nssp"]] # equivalent to epidata_meta("nssp")$signals
