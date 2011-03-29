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
    recent    = nil
    @accessed = -1

    get_files(name).each { |fname|
      begin
        atime  = File.atime(fname)
        recent = atime if !recent or recent < atime
      rescue
        # can't read; skip
      end
    }

    @name     = name
    @accessed = Time.now - recent if recent
  end

  def is_old?
    return true if @accessed > $threshold
    return false
  end
end

# get all explicitly installed packages
def get_packages 
  `pacman -Qqe`.split("\n").each { |p| yield Package.new(p) }
end

# get all normal files owned by a package
def get_files(pkgname) 
  return `pacman -Qql #{ pkgname }`.split("\n").find_all { |fname| fname =~ /.*[^\/]$/ }
end

$threshold = (60 * 60 * 24 * 180)

OptionParser.new do |o|
  o.on('-3',  'set threshold as 3 months') { $threshold = (60 * 60 * 24 * 90)  }
  o.on('-6',  'set threshold as 6 months') { $threshold = (60 * 60 * 24 * 180) }
  o.on('-12', 'set threshold as 1 year'  ) { $threshold = (60 * 60 * 24 * 365) }

  o.on('-h', '--help', 'display this') { puts o; exit }

  begin o.parse!
  rescue OptionParser::InvalidOption => e
    puts e
    puts o
    exit 1
  end
end

get_packages { |pkg| puts pkg.name if pkg.is_old? }
