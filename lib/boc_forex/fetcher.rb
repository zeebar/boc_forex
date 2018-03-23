
require 'open-uri'

module BocForex

  class Fetcher
    
    @forex_by_year = []

    def self.forex_by_year( year )

      @forex_by_year[year] ||= begin
         raise ArgumentError.new("BOC Valet API supplies forex data starting in #{BOC_VALET_FOREX_FIRST_YEAR}") if year < BOC_VALET_FOREX_FIRST_YEAR

         afx_by_date = {}
         parse_state = :waiting_for_obs
         currencies = []
         Cache.load_or_fetch_year_group_obs( BOC_VALET_FOREX_GROUP, year ).each_line do |line|
           case parse_state
           when :waiting_for_obs
             parse_state = :getting_header if line.strip.downcase == "observations"
           when :getting_header
             parse_state = :loading_data 
             currencies = line.split(",").map do |s| 
               if s.length == 8 && s[0..1] == "FX" && s[5..7] == "CAD" 
                 s[2..4].upcase.to_sym
               else
                 nil
               end
             end
             parse_state = :loading_data
           when :loading_data
             words = line.split(",")
             date_s = words[0].strip
             if date_s.empty?
               parse_state = :done
             else
               date = Date.parse( date_s )
               fmap = {}
               currencies.each_with_index do |currency, hx| 
                 unless currency.nil? 
                   fx_s = words[hx]
                   fmap[currency] = fx_s.to_f unless fx_s.empty?
                 end
               end
               afx_by_date[date] = fmap
             end
           end
         end
         afx_by_date
      end      

    end

    def self.forex_map( dates, currencies, opts = {} ) 

      fxmap = {}

      dates.each do |date|
        if dcmap = (forex_by_year(date.year) || {})[date]
          cmap = nil
          currencies.each do |currency|
            if fx_rate = dcmap[currency] 
              (cmap ||= {})[currency] = fx_rate
            else
              puts "no #{currency} in #{cmap}"
            end
          end
          fxmap[date] = cmap if cmap
        end
      end

      fxmap

    end

    def self.forex( date, currency, opts = {} ) 
      (forex_map( [date || Date.today], [currency || :USD], opts )[date] || {})[currency]
    end

  end

end

