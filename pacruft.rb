#!/usr/bin/ruby
#
# pbrisbin 2011
#
###
require 'optparse'

class Fixnum # add some time helpers to Fixnum
  def seconds; return self               end
  def minutes; return self         * 60  end
  def hours;   return self.minutes * 60  end
  def days;    return self.hours   * 24  end
  def months;  return self.days    * 30  end
  def years;   return self.days    * 365 end
end

class Package
  attr_reader :name

  def initialize name
    @name     = name
    @accessed = -1

    max = nil
    owned_files.each do |fname|
      begin
        atime = File.atime(fname)
        max   = atime if !max or atime > max
      rescue
        # can't read; skip
      end
    end

    @accessed = Time.now - max if max
  end

  def is_older_than? t
    return true if @accessed > t.seconds
    return false
  end

  private

  def owned_files 
    # assumption: a non-directory will end in a non-slash
    return `pacman -Qql #{ @name }`.split("\n").find_all { |fname| fname =~ /.*[^\/]$/ }
  end
end

t = 0

OptionParser.new do |o|
  o.on('-y', '--years  <years>' ) { |y| t += y.to_i.years  }
  o.on('-m', '--months <months>') { |m| t += m.to_i.months }
  o.on('-d', '--days   <days>'  ) { |d| t += d.to_i.days   }
  o.on('-h', '--help'           ) { puts o; exit }

  begin o.parse!
  rescue OptionParser::InvalidOption => e
    puts e; puts o;
    exit 1
  end
end

# no options passed?
t = 6.months if t == 0

`pacman -Qqe`.split("\n").each do |p|
  pkg = Package.new(p)
  puts pkg.name if pkg.is_older_than? t
end
