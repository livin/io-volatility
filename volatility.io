// Simple Currency Volatility Analysis System
// Author: Vladimir Livin
//
// Run: io volality.io

// Some imports
doFile("json.io")

// Definitions
baseCurrency := "USD"
targetCurrency := "RUB"

_30days := Duration clone setDays(30)
lastMonth := Date now - _30days

// Rates API
rateForDate := method(base, currency, aDate,
  URL with("http://api.fixer.io/#{aDate asString(\"%Y-%m-%d\")}?base=#{base}&symbols=#{currency}" interpolate) fetch parseJson rates doString(currency)
)

rateLatest := method(base, currency,
  URL with("http://api.fixer.io/latest?base=#{base}&symbols=#{currency}" interpolate) fetch parseJson rates doString(currency)
)

// Rate fetch & calculation
rateToday := rateLatest(baseCurrency, targetCurrency)
rateLastMonth := rateForDate(baseCurrency, targetCurrency, lastMonth)
growth := (((rateToday / rateLastMonth) - 1.0))
growthInPercent := (growth * 100) round
growthAbs := growth abs

// Resolving volatility
if(growthAbs > 0.2) then(resolution := "Panic!!! Enormous volatility.") \
  elseif(growthAbs > 0.05) then(resolution := "It's quite volatile!") \
  elseif(growthAbs > 0.01) then(resolution := "No volatility. Okay.") \
  else(resolution := "Perfect! No volatility at all!")

writeln(baseCurrency, "/", targetCurrency, " Volatility Analysis")
writeln("Today: ", rateToday asString(0, 2))
writeln("Last Month: ", rateLastMonth asString(0, 2))
writeln("Growth/Loss: ", growthInPercent, "%")
writeln("Resolution: ", resolution)
