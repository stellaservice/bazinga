module Bazinga
  class Runner
    COLOR_MAP = {
        'red'    => "\001\e[1m\e[31m\002",
        'yellow' => "\001\e[1m\e[33m\002",
        'green'  => "\001\e[1m\e[32m\002",
        'reset'  => "\001\e[0m\002"
    }

    class << self

      # Issue: readline breaks. Fixed.
      # Credits: http://stackoverflow.com/questions/8806643/colorized-output-breaks-linewrapping-with-readline
      def colorize(text, color)
        "#{COLOR_MAP[color]}#{text}#{COLOR_MAP['reset']}"
      end

      def run
        env_tag = (ENV['STELLA_ENV'] && ENV['STELLA_ENV'].downcase)

        console_tag = case env_tag
                        when 'production' then "(#{colorize('prod', 'red')})"
                        when 'staging' then "(#{colorize('staging', 'yellow')})"
                        when 'development' then "(#{colorize('dev', 'green')})"
                        else "(#{colorize(env_tag, 'yellow')})"
                      end

        IRB.conf[:PROMPT][:RAILS_ENV] = {
            :PROMPT_I => "#{console_tag} :%03n > ",
            :PROMPT_N => "#{console_tag} :%03n?> ",
            :PROMPT_S => "",
            :PROMPT_C => "#{console_tag} :%03n?> ",
            :RETURN => "=> %s\n"
        }

        IRB.conf[:PROMPT_MODE] = :RAILS_ENV
        puts "#{COLOR_MAP['red']}Logged in on Production#{COLOR_MAP['reset']}" if env_tag.eql? 'production'
      end
    end
  end
end

Bazinga::Runner.run
