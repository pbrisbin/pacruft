#!/usr/bin/ruby
#
# pbrisbin 2011
#
###
require 'optparse'

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

  def is_older_than?(t)
    return true if @accessed > t.seconds
    return false
  end
end

class Threshold
  attr_writer :years, :months, :days

  def initialize
    # default values
    @years   = 0
    @months  = 0
    @days    = 0
  end

  def seconds
    ret  = 0
    ret += @years  * 365 * 24 * 60 * 60 if @years
    ret += @months *  30 * 24 * 60 * 60 if @months
    ret += @days         * 24 * 60 * 60 if @days

    return ret
  end
end

t = nil

OptionParser.new do |o|
  o.on('-y', '--years  <years>' ) { |y| t = Threshold.new unless t; t.years  = y.to_f }
  o.on('-m', '--months <months>') { |m| t = Threshold.new unless t; t.months = m.to_f }
  o.on('-d', '--days   <days>'  ) { |d| t = Threshold.new unless t; t.days   = d.to_f }
  o.on('-h', '--help'           ) { puts o; exit }

  begin o.parse!
  rescue OptionParser::InvalidOption => e
    puts e; puts o;
    exit 1
  end
end

unless t # if no options were passed
  t = Threshold.new
  t.months = 6
end

`pacman -Qqe`.split("\n").each { |p|
  pkg = Package.new(p)
  puts pkg.name if pkg.is_older_than? t
}
