require 'tweetstream'
require 'twitter'

puts "Loading twitter libraries."
rest_client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['CONSUMER_KEY']
  config.consumer_secret = ENV['CONSUMER_SECRET']
  config.access_token = ENV['REST_ACCESS_TOKEN']
  config.access_token_secret = ENV['REST_ACCESS_SECRET']
end
TweetStream.configure do |config|
  config.consumer_key = ENV['CONSUMER_KEY']
  config.consumer_secret = ENV['CONSUMER_SECRET']
  config.oauth_token = ENV['STR_ACCESS_TOKEN']
  config.oauth_token_secret = ENV['STR_ACCESS_SECRET']
  config.auth_method = :oauth
end
streaming_client = TweetStream::Client.new

rest_user_id = ENV['REST_USER_ID']
str_user_id = ENV['STR_USER_ID']

puts "Loading regexp list."
regexps = ENV['REGEXP'].split(',').map do |r|
  puts "/#{r.chomp}/"
  Regexp.new(r.chomp)
end

streaming_client.on_inited do
  puts 'Connected!'
end

streaming_client.on_timeline_status do |status|
  if regexps.any? { |r| !r.match(status.text).nil? } && !status.reply? && !status.retweet?
    name = status.user.name
    id = status.user.screen_name
    text = status.text
    url = status.url.to_s
    puts "SendMessage: \n#{name}:#{id}\n#{text}\n#{url}"
    rest_client.create_direct_message(str_user_id, "#{name}:#{id}\n#{text}\n#{url}")
  end
end

streaming_client.userstream
