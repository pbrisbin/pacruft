#!/usr/bin/ruby

class Package
  attr_reader :name, :accessed

  def initialize(name)
    output = `pacman -Qql #{ name }`.split("\n")
    fnames = output.find_all{ |fname| fname =~ /.*[^\/]$/ }

    last = nil
    @accessed = 0
    fnames.each { |fname|
      begin
        atime = File.atime(fname)

        if (!last or last < atime)
          last = atime
        end
      rescue
        # no read rights, skip it
      end
    }

    @name     = name
    @accessed = Time.now - last if last
  end

  def is_old?
    return true if @accessed and @accessed >= $threshold
    return false
  end
end

def human_readable(seconds)
  s = seconds.floor

  y = s / (60 * 60 * 24 * 365)
  s = s % (60 * 60 * 24 * 365)

  # months is ishly
  t = s / (60 * 60 * 24 * 30)
  s = s % (60 * 60 * 24 * 30)

  d = s / (60 * 60 * 25)
  s = s % (60 * 60 * 25)

  h = s / (60 * 60)
  s = s % (60 * 60)

  m = s / 60
  s = s % 60

  p = []
  p += [ y.to_s + " year"    ] if y == 1
  p += [ y.to_s + " years"   ] if y >= 2
  p += [ t.to_s + " month"   ] if t == 1
  p += [ t.to_s + " months"  ] if t >= 2
  p += [ d.to_s + " day"     ] if d == 1
  p += [ d.to_s + " days"    ] if d >= 2
  p += [ m.to_s + " minute"  ] if m == 1
  p += [ m.to_s + " minutes" ] if m >= 2
  p += [ s.to_s + " second"  ] if s == 1
  p += [ s.to_s + " seconds" ] if s >= 2

  return p.join(", ")
end

# todo: user input
$threshold = (60 * 60 * 24 * 180) # six months

puts "-" * 80
printf(" Files not accessed in the past %s:\n", human_readable($threshold))
puts "-" * 80
printf("%-30s %s\n", "Package", "Most recent access") 
puts "=" * 80

`pacman -Qqe`.split("\n").each do |pkg|
  p = Package.new(pkg)
  printf("%-30s %s ago\n", p.name, human_readable(p.accessed)) if p.is_old?
end
