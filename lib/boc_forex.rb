require "boc_forex/version"

require "boc_forex/cache"
require "boc_forex/fetcher"

module BocForex

  BOC_VALET_FOREX_GROUP = "FX_RATES_DAILY"
  BOC_VALET_BASE_URI = "https://www.bankofcanada.ca/valet"
  BOC_VALET_GROUP_OBS_PATH = "observations/group"
  BOC_VALET_FOREX_FIRST_YEAR = 2017

end
