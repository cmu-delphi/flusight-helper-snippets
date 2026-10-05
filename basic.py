import datetime

from epidatpy import CovidcastEpidata, EpiDataContext, EpiRange

epidata = EpiDataContext()

# Fetch latest NHSN hospitalization data for all states and territories:
nhsn_latest = epidata.epidata_snapshot(
  "nhsn", "confirmed_admissions_flu_ew", "state"
).df()

# Fetch latest NSSP data:
nssp_latest = epidata.epidata_snapshot(
  "nssp", "pct_ed_visits_influenza", "state"
).df()

# Fetch NHSN hospitalization revision history:
nhsn_history = epidata.epidata_archive(
  "nhsn", "confirmed_admissions_flu_ew", "state"
).df()

# Browse available signals (see also
# https://cmu-delphi.github.io/delphi-epidata/api/v5_signals.html
# and
# https://delphi.cmu.edu/epiportal/
# ):
meta = epidata.epidata_meta()
meta.keys()
signals_by_source["nssp"]["signals"] # equivalent to epidata.epidata_meta("nssp")["signals"]
