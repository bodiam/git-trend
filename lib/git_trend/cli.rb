require 'thor'

module GitTrend
  class CLI < Thor
    include GitTrend::Rendering

    map '-v'              => :version,
        '--version'       => :version

    default_command :list

    desc :version, 'show version'
    def version
      say "git-trend version: #{VERSION}", :green
    end

    desc :list, "\033[32m(DEFAULT COMMAND)\e[0m List Trending repository on github [-l, -s, -d]"
    option :language,    aliases: '-l', required: false, desc: 'Specify a language'
    option :since,       aliases: '-s', required: false, desc: 'Enable: [daily, weekly, monthly]'
    option :description, aliases: '-d', required: false, default: true, type: :boolean, desc: "\033[32m(DEFAULT OPTION)\e[0m Dislpay descriptions"
    option :number,      aliases: '-n', required: false, type: :numeric, desc: 'Number of lines'
    option :help,        aliases: '-h', required: false, type: :boolean
    def list
      help(:list) and return if  options[:help]
      scraper = Scraper.new
      projects = scraper.get(options[:language], options[:since], options[:number])
      render(projects, !!options[:description])
    rescue => e
      say "An unexpected #{e.class} has occurred.", :red
      say e.message unless e.class.to_s == e.message
    end

    desc :languages, 'Show selectable languages'
    def languages
      scraper = Scraper.new
      languages = scraper.languages
      render_languages(languages)
    end
  end
end
