module PrettyFormatter
  mattr_accessor :verbose, :suppress_noise, :hostname_maxlen, :custom, :hostname

  @@verbose = Rails.env.production?
  @@suppress_noise = Rails.env.development?
  @@hostname_maxlen = 8
  @@custom = ''

  class << self
    def formatter
      Formatter.new
    end
  end

  class Formatter < ::Logger::Formatter
    @@severity_cache = {}
    @@pid = $$
    @@color = ActiveSupport::LogSubscriber.colorize_logging

    def call(severity, timestamp, progname, msg)
      message = String === msg ? msg : msg.inspect
      full_message = ''

      unless (message.start_with?('Started GET "/assets') || !message.present?) && ::PrettyFormatter.suppress_noise
        prefix, time = ::PrettyFormatter.verbose ? [prefix_string, "#{Time.now.iso8601(5)} "] : ['', '']

        full_message = "#{prefix}#{time}#{severity_color(severity)} #{message}\n"
      end

      full_message
    end

    def self.get_hostname
      `hostname -s`.strip
    end
    @@hostname = get_hostname

    def severity_color(severity)
      formatted_severity = severity

      return @@severity_cache[severity] if @@severity_cache.has_key?(severity)
      if @@color
        if severity == "INFO"
          formatted_severity = "\033[37m" + severity + "\033[0m"
        elsif severity == "WARN"
          formatted_severity = "\033[33m" + severity + "\033[0m"
        elsif severity == "ERROR"|| severity == "FATAL"
          formatted_severity = "\033[31m" + severity + "\033[0m"
        elsif severity == "DEBUG"
          formatted_severity = "\033[32m" + severity + "\033[0m"
        else
          formatted_severity = "\033[34m" + severity + "\033[0m"
        end
      end

      @@severity_cache[severity] = formatted_severity
      formatted_severity
    end

    def prefix_string
      if @@pid != $$
        @@pid = $$
        @@line_prefix = ''
      end

      @@line_prefix ||= begin
                          prefix = "#{@@hostname[(::PrettyFormatter.hostname_maxlen * -1)..-1]}.#{@@pid}  "
                          return "#{::PrettyFormatter.custom} #{prefix}" if ::PrettyFormatter.custom.present?
                          prefix
                        end
    end

    protected :severity_color, :prefix_string
  end
end
