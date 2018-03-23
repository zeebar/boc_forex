require 'open-uri'
require 'pathname'

module BocForex

  BOC_VALET_BASE_URI = "https://www.bankofcanada.ca/valet"
  BOC_VALET_GROUP_OBS_PATH = "observations/group"

  class Cache

    def self.home_dir 
      @home_dir ||= begin
        bf_home_s = ENV['BOCFOREX_HOME'] 
        if bf_home_s.nil? || bf_home_s.empty?
          boc_home = Pathname.new( Dir.home ) + ".bocforex"
        else
          boc_home = Pathname.new( bf_home_s )
        end
        boc_home.mkpath unless boc_home.exist?
        boc_home
      end
    end

    def self.cache_dir
      @cache_dir ||= begin
        boc_cache = home_dir + "cache"
        boc_cache.mkpath unless boc_cache.exist?
        boc_cache
      end
    end

    def self.load_or_fetch_year_group_obs( group_name, year )
      cache_file = cache_dir + ("#{group_name}_#{year}.csv")
      if cache_file.exist?
        cache_file.read
      else
        uri = "#{BOC_VALET_BASE_URI}/#{BOC_VALET_GROUP_OBS_PATH}/#{group_name}/csv?start_date=#{year}-01-01&end_date=#{year}-12-31"
        data = begin 
          open( uri ).read
        rescue OpenURI::HTTPError => he
          raise "could not fetch #{uri}: #{he.message}"
        end
        cache_file.write( data )
        data
      end
    end

  end

end

