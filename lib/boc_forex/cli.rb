
require 'thor'
require 'boc_forex'

module BocForex

  class CLI < Thor    

    desc "cad DATES CURRENCIES", "list all available exchange rates"

    method_option :verbose, type: :boolean, default: false, desc: 'be verbose' 

    def cad( dates = "", currencies = "")

        curs = currencies.split(",").map(&:strip).select { |s| !s.empty? }.map(&:to_sym).map(&:upcase)
        curs.push(:USD) if curs.empty?

        dats = dates.split(",").map(&:strip).select { |s| !s.empty? }.map do |ds| 
          if ds == "today"
            Date.today
          else
            Date.parse(ds) 
          end
        end

        dats.push(Date.today) if dats.empty?
      
        BocForex::Fetcher.forex_map( dats, curs, verbose: options[:verbose] ).each do |date, rate_map|
          fxra = curs.map do |cur| 
            if fxr = rate_map[cur] 
              "%8.4f" % [fxr]
            else
              ""
            end
          end.join( " " )
          puts "#{date.iso8601} #{fxra}"
        end

    end

  end

end

