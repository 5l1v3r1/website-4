# frozen_string_literal: true

TIME_LENGTH = "HH:MM".length # Length of timestamp string we're using.
LINES_DIGITS = 3 # Max number of log lines in digits, e.g. 3 digits = 999 lines.
NON_BREAKING_SPACE = '&nbsp;'

module Jekyll

require 'yaml'

  class IRCBlock < Liquid::Block

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      output = super

      # Regex to select lines that begin with HH:MM time.
      output.gsub!(/^([0-1][0-9]|[2][0-3]):[0-5][0-9] .*/).with_index(1) do |line, index|
        # Separate the log line into individual parts.
        lineno  = "#{NON_BREAKING_SPACE * (LINES_DIGITS - index.to_s.length)}#{index}"
        time    = line[0..TIME_LENGTH]
        name    = /<.+?>/.match(line).to_s
        nick    = name.gsub(/[<>]/, '').strip
        message = CGI.escapeHTML(line[TIME_LENGTH + 1 + name.length..-1])
        # Return the log line in HTML markup version.
        "<table class='log-line' id='l-#{index}'>" \
          "<tr class='log-row'>" \
            "<td class='log-lineno'><a href='#l-#{index}'>#{lineno}</a></td>" \
            "<td class='log-time'>#{time}</td>" \
            "<td>" \
              "<span class='log-nick'>&lt;#{nick}&gt;</span>" \
              "<span class='log-msg'>#{message}</span>" \
            "</td>" \
          "</tr>" \
        "</table>"
      end

      output
    end
  end
end

Liquid::Template.register_tag('irc', Jekyll::IRCBlock)
