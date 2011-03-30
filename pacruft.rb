#!/usr/bin/ruby
#
# pbrisbin 2011
#
###
require 'optparse'

# a Package consists of a name and the time since its most recently 
# accessed file was accessed
class Package
  attr_reader :name, :accessed

  def initialize(name)
    @name     = name
    @accessed = -1

    max = nil
    owned_files.each { |fname|
      begin
        atime = File.atime(fname)
        max   = atime if !max or atime > max
      rescue
        # can't read; skip
      end
    }

    @accessed = Time.now - max if max
  end

  def owned_files 
    return `pacman -Qql #{ @name }`.split("\n").find_all { |fname| fname =~ /.*[^\/]$/ }
  end

  def is_old?
    return true if @accessed > $T
    return false
  end
end

$T = (60 * 60 * 24 * 180)

OptionParser.new do |o|
  o.on('-3',  'set threshold as 3 months') { $T = (60 * 60 * 24 * 90)  }
  o.on('-6',  'set threshold as 6 months') { $T = (60 * 60 * 24 * 180) }
  o.on('-12', 'set threshold as 1 year'  ) { $T = (60 * 60 * 24 * 365) }

  o.on('-h', '--help', 'display this') { puts o; exit }

  begin o.parse!
  rescue OptionParser::InvalidOption => e
    puts e; puts o;
    exit 1
  end
end

`pacman -Qqe`.split("\n").each { |p|
  pkg = Package.new(p)
  puts pkg.name if pkg.is_old?
}
