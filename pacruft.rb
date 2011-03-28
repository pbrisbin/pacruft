#!/usr/bin/ruby
#
# pbrisbin 2011
#
###
require 'optparse'

class Package
  attr_reader :name, :accessed

  def initialize(name)
    output = `pacman -Qql #{ name }`.split("\n")
    fnames = output.find_all{ |fname| fname =~ /.*[^\/]$/ }

    recent    = nil
    @accessed = -1

    fnames.each { |fname|
      begin
        atime  = File.atime(fname)
        recent = atime if !recent or recent < atime
      rescue
        # no read rights, skip it
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

def human_readable(seconds)
  s = seconds.floor

  y =  s / (60 * 60 * 24 * 365)
  s %= 60 * 60 * 24 * 365

  m =  s / (60 * 60 * 24 * 30)
  s %= 60 * 60 * 24 * 30

  d =  s / (60 * 60 * 24)
  s %= 60 * 60 * 24

  h =  s / (60 * 60)
  s %= 60 * 60

  p = []
  p += [ y.to_s + " year"   ] if y == 1
  p += [ y.to_s + " years"  ] if y >= 2
  p += [ m.to_s + " month"  ] if m == 1
  p += [ m.to_s + " months" ] if m >= 2
  p += [ d.to_s + " day"    ] if d == 1
  p += [ d.to_s + " days"   ] if d >= 2

  return p.join(", ")
end

def print_heading
  puts "-" * 80
  printf("Packages not accessed in the past %s:\n", human_readable($threshold))
  puts "-" * 80
  printf("%-30s %s\n", "Package", "Last access") 
  puts "=" * 80
end

def output_pkg(pkg)
  puts pkg.name if $quiet
  printf("%-30s %s ago\n", pkg.name, human_readable(pkg.accessed)) unless $quiet
end

# defaults
$quiet     = false
$threshold = (60 * 60 * 24 * 180)

# getopts
OptionParser.new do |o|
  o.banner = "usage: pacruft [ -q ] [ -3 | -6 | -12 ]"

  o.on('-3',  'set threshold as 3 months') { $threshold = (60 * 60 * 24 * 90)  }
  o.on('-6',  'set threshold as 6 months') { $threshold = (60 * 60 * 24 * 180) }
  o.on('-12', 'set threshold as 1 year'  ) { $threshold = (60 * 60 * 24 * 365) }

  o.on('-q', '--quiet', 'output only package names' ) { $quiet = true }
  o.on('-h', '--help',  'display this') { puts o; exit }

  o.parse!
end

print_heading unless $quiet

`pacman -Qqe`.split("\n").each do |pkg|
  p = Package.new(pkg)
  output_pkg(p) if p.is_old?
end
