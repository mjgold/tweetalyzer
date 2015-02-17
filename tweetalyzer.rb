# setup.rb makes sure we're setting up our environment correctly, i.e.,
# requiring the necessary gems, connecting to the correct database, etc.
require './setup'

# database.rb is where we're defining our DataMapper models
require './database'

# get text-analysis and twitter client modules
require '~/dropbox/code/text-analysis/textalyze'
require '~/dropbox/code/twitter-client/twitter'

require 'pp'

def twitter_client
  return @client unless @client.nil?

  @client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
    config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
    config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
  end
end

### MAIN

command = ARGV.shift
arguments = ARGV
# client = twitter_client
twitter = TwitterClient::Twitter.new(
                                    api_key: ENV['TWITTER_CONSUMER_KEY'],
                                    api_secret: ENV['TWITTER_CONSUMER_SECRET'],
                                    access_token: ENV['TWITTER_ACCESS_TOKEN'],
                                    access_token_secret: ENV['TWITTER_ACCESS_TOKEN_SECRET']
                                    )

tweets = twitter.run_app(command, arguments)
tweets_string = tweets.join(' ')
tweets_string = sanitize(tweets_string)
tweets_words = tweets_string.split(' ')

counts = item_counts(tweets_words)
print_hash(counts)

# frequencies = item_frequency(tweets_words)
# print_histogram(frequencies)
