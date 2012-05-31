require 'optparse'
require 'oauth'
require 'net/http'

FEEDS_API_HOST = 'feeds.api.7digital.com'
FEEDS_API_PATH = '/1.2/feed/'
CONSUMER_KEY = 'YOUR_KEY_HERE'
CONSUMER_SECRET = 'YOUR_SECRET_HERE'
APP_USER_AGENT = 'YOUR_FEEDS_APP_NAME/VERSION/PLATFORM' # e.g. "FeedFetcher/0.0 (Windows NT 5.0; Ruby 1.9.3)"

options = {}

# Define command line options
opts = OptionParser.new do|opts|
  opts.banner = "Usage: fetch_feed.rb (artist|release|track) [options]"
  opts.separator ""
  options[:feed_scope_type] = "full"
  opts.on( '-i', '--incremental', 'Flag to download incremental updates feed','(instead of full feed)' ) do
   options[:feed_scope_type] = "updates"
  end
  opts.separator ""
  # Define the options, and what they do
  options[:country] = "GB"
  opts.on( '-c', '--country COUNTRY_CODE', 'Country of the feed (default: GB)' ) do |country_code|
   options[:country] = country_code
  end
  opts.separator ""
  opts.on( '-s', '--shopid SHOP_ID', Integer, 'Shop ID of the feed ', '(optional, overrides country parameter)' ) do |shop_id|
   options[:shop_id] = shop_id
  end
  opts.separator ""
  opts.on( '-d', '--date YYYYMMDD', 'Date of the feed ','(default: today for incremental feeds,','most recent Monday for full feeds)' ) do |yyyymmdd|
   options[:date] = yyyymmdd
  end
  opts.separator ""
  opts.on( '-o', '--output FILE', 'File the downloaded feed will be saved to','(default: <country>_<type>_<date>.csv.gz)') do |file|
   options[:output] = file
  end
  opts.separator ""
  opts.on( '-h', '--help', 'Display this screen' ) do
   puts opts
   exit
  end
end

# Ensure valid feed type was provided as the first command line argument
if ARGV.size == 0 || !['artist','release','track'].include?(ARGV[0].to_s.downcase) then
  puts opts
  exit 1
end
feed_item_type = ARGV[0]

# Ensure valid command line options were provided
begin opts.parse!(ARGV)
rescue OptionParser::InvalidOption => invalid_option_exception
  puts invalid_option_exception
  puts opts
  exit  1
rescue OptionParser::InvalidArgument => invalid_argument_exception
  puts invalid_argument_exception
  puts opts
  exit  1
end

# Generate a default feed date option if not provided
if options[:date].nil? then
  if options[:feed_type] == "full" then
  options[:date] = (Date.today-(Date.today.wday-1)).strftime("%Y%m%d")
  else
  options[:date] = Date.today.strftime("%Y%m%d")
  end
end

# Generate a default output filename option if not provided
if options[:output].nil? then
  options[:output] = (options[:shop_id].to_s || options[:country]) + "_" + ARGV[0] + "_" + options[:feed_scope_type] + "_" + options[:date] + ".csv.gz"
end

# Construct API feed request (use shopId instead of country if provided)
feed_query = "#{feed_item_type}/#{options[:feed_scope_type]}?date=#{options[:date]}"
if options[:shop_id].nil? then
  feed_query += "&country=#{options[:country]}"
else
  feed_query += "&shopId=#{options[:shop_id]}"
end

puts "Fetching feed #{feed_query}"

# Create and OAuth sign HTTP GET request
http_client = Net::HTTP.new(FEEDS_API_HOST)
http_request = Net::HTTP::Get.new(FEEDS_API_PATH + feed_query, {"user-agent" => APP_USER_AGENT})
http_request.oauth!(http_client, OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET), nil)

# Download the feed file
f = open(options[:output],"wb")
begin
  http_client.request(http_request) do |resp|
    if resp.code != '200' || resp["Content-Type"] != 'application/x-gzip' then
      puts(resp.code + " - " + resp.message)
      puts(resp.body)
      abort("Feed not downloaded")
    end
    resp.read_body do |segment|
      f.write(segment)
    end
  end
  puts "Feed successfully downloaded"
ensure
  f.close()
end
