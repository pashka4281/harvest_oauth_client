class Hash
  def hash_revert
    hash_new = Hash.new
    self.each {|key,value|
      if not hash_new.has_key?(key) then hash_new[value] = key end
    }
    return hash_new
  end
end

module HarvestOauthClient
  class CurrencyHelper

    CURRENCY_HASH = {"Vanuatu Vatu - VUV"=>"VUV",
      "Taiwan New Dollars - TWD"=>"TWD",
      "Mozambican Metical - MZN"=>"MZN",
      "Kuwait Dinars - KWD"=>"KWD",
      "Mauritius Rupees - MUR"=>"MUR",
      "Eastern Caribbean Dollars - XCD"=>"XCD",
      "United Arab Emirates Dirham - AED"=>"AED",
      "Trinidad and Tobago Dollars - TTD"=>"TTD",
      "Russia Rubles - RUB"=>"RUB",
      "Fiji Dollars - FJD"=>"FJD",
      "Euro - EUR"=>"EUR",
      "Hungary Forint - HUF"=>"HUF",
      "Mexico Pesos - MXN"=>"MXN",
      "Lithuanian Litas - LTL"=>"LTL",
      "Seychelles Rupees - SCR"=>"SCR",
      "Lebanon Pounds - LBP"=>"LBP",
      "China Yuan Renminbi - CNY"=>"CNY",
      "United States Dollars - USD"=>"USD",
      "Australia Dollars - AUD"=>"AUD",
      "Zambia Kwacha - ZMK"=>"ZMK",
      "Paraguayan Guarani - PYG"=>"PYG",
      "Nigerian Naira - NGN"=>"NGN",
      "Japan Yen - JPY"=>"JPY",
      "Malta Liri - MTL"=>"MTL",
      "Bermuda Dollars - BMD"=>"BMD",
      "Costa Rica Colones - CRC"=>"CRC",
      "Estonia Krooni - EEK"=>"EEK",
      "Jordan Dinars - JOD"=>"JOD",
      "Papua New Guinea Kina - PGK"=>"PGK",
      "Hong Kong Dollars - HKD"=>"HKD",
      "Israel New Shekels - ILS"=>"ILS",
      "Morocco Dirhams - MAD"=>"MAD",
      "Iraq Dinars - IQD"=>"IQD",
      "Bolivian Boliviano - BOB"=>"BOB",
      "Danish Krone - DKK"=>"DKK",
      "Romania New Lei - RON"=>"RON",
      "Netherlands Antillean Guilder - ANG"=>"ANG",
      "Nepal Rupees - NPR"=>"NPR",
      "Bahrain Dinars - BHD"=>"BHD",
      "Aruban Florin - AWG"=>"AWG",
      "Cyprus Pounds - CYP"=>"CYP",
      "South Africa Rand - ZAR"=>"ZAR",
      "India Rupees - INR"=>"INR",
      "Ghana Cedis - GHS"=>"GHS",
      "Uruguayan peso - UYU"=>"UYU",
      "Albania Lek\353 - ALL"=>"ALL",
      "New Zealand Dollars - NZD"=>"NZD",
      "Vietnam Dong - VND"=>"VND",
      "Turkey Lira - TRY"=>"TRY",
      "Sri Lanka Rupees - LKR"=>"LKR",
      "Namibian Dollars - NAD"=>"NAD",
      "Algeria Dinars - DZD"=>"DZD",
      "Chile Pesos - CLP"=>"CLP",
      "United Kingdom Pounds - GBP"=>"GBP",
      "Bahamas Dollars - BSD"=>"BSD",
      "Bulgaria Leva - BGN"=>"BGN",
      "Ukrainian hryvnia - UAH"=>"UAH",
      "Sudan Pounds - SDG"=>"SDG",
      "South Korea Won - KRW"=>"KRW",
      "Oman Rials - OMR"=>"OMR",
      "Brunei Dollar - BND"=>"BND",
      "Canada Dollars - CAD"=>"CAD",
      "Czech Republic Koruny - CZK"=>"CZK",
      "Bangladesh Taka - BDT"=>"BDT",
      "Korea (South) Won - KRW"=>"KRW",
      "Latvian Lat - LVL"=>"LVL",
      "Iran Rials - IRR"=>"IRR",
      "CFP Franc - XPF"=>"XPF",
      "Croatia Kuna - HRK"=>"HRK",
      "Ugandan shilling - UGX"=>"UGX",
      "Tunisia Dinars - TND"=>"TND",
      "Peru Nuevos Soles - PEN"=>"PEN",
      "Colombia Pesos - COP"=>"COP",
      "Norway Kroner - NOK"=>"NOK",
      "Chile Unidad de Fomento - CLF"=>"CLF",
      "Afghanistan Afghanis - AFN"=>"AFN",
      "Jamaica Dollars - JMD"=>"JMD",
      "Thailand Baht - THB"=>"THB",
      "Slovakia Koruny - SKK"=>"SKK",
      "Saudi Arabia Riyals - SAR"=>"SAR",
      "Philippines Pesos - PHP"=>"PHP",
      "Switzerland Francs - CHF"=>"CHF",
      "Dominican Republic Pesos - DOP"=>"DOP",
      "Cayman Islands Dollar - KYD"=>"KYD",
      "Swedish krona - SEK"=>"SEK",
      "Guatemalan quetzal - GTQ"=>"GTQ",
      "Singapore Dollars - SGD"=>"SGD",
      "Qatar Riyals - QAR"=>"QAR",
      "Poland Zlotych - PLN"=>"PLN",
      "Malaysia Ringgits - MYR"=>"MYR",
      "Iceland Kronur - ISK"=>"ISK",
      "Pakistan Rupees - PKR"=>"PKR",
      "Libyan Dinar - LYD"=>"LYD",
      "Venezuela Bolivares - VEB"=>"VEB",
      "Indonesia Rupiahs - IDR"=>"IDR",
      "Kenya Shillings - KES"=>"KES",
      "Argentina Pesos - ARS"=>"ARS",
      "Barbados Dollars - BBD"=>"BBD",
      "Egypt Pounds - EGP"=>"EGP",
      "Belize Dollar - BZD"=>"BZD",
      "Brazil Reais - BRL"=>"BRL"}

    
    def self.get_short_name(full_name)
      CURRENCY_HASH[full_name]
    end

    def self.get_full_name(short_name)
      CURRENCY_HASH.hash_revert[short_name]
    end
    
  end
end