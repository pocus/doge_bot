require "socket"
require "open-uri"
require "JSON"

server = "irc.bitmakerlabs.com"
port = "6667"
nick = "boozy_doge_bot"
channel = "#bot_test"

beer1_json = open("http://lcboapi.com/products/186510/").read
beer2_json = open("http://lcboapi.com/products/254946/").read

@beer1 = JSON.parse(beer1_json)
@beer2 = JSON.parse(beer2_json)

words1 = @beer1['result']['tasting_note']
words2 = @beer2['result']['tasting_note']

all_words = words1 + words2
word_ary = all_words.split
word_ary.each { |w| w.downcase!}


greeting_prefix = "privmsg #{channel} :"
greetings = ["taste", "beer", "doge"]
prefixes = ["such", "amaze", "so"]
suffixes = [" ", "wow" ]

irc_server = TCPSocket.open(server, port)

irc_server.puts "USER bhellobot 0 * BHelloBot"
irc_server.puts "NICK #{nick}"
irc_server.puts "JOIN #{channel}"
irc_server.puts "PRIVMSG #{channel} :Hello from #{nick}"

# Hello, Bot!
until irc_server.eof? do
  msg = irc_server.gets.downcase
  puts msg

  was_greeted = false

  greetings.each do |g|
    was_greeted = true if msg.include?(g)
  end

  if msg.include?(greeting_prefix) and was_greeted
  	irc_server.puts "PRIVMSG #{channel} :#{prefixes.sample} #{word_ary.sample} #{suffixes.sample}"
  end
end