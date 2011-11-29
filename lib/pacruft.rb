class Fixnum # :nodoc:
  def seconds; return self               end
  def minutes; return self         * 60  end
  def hours;   return self.minutes * 60  end
  def days;    return self.hours   * 24  end
  def months;  return self.days    * 30  end
  def years;   return self.days    * 365 end
end

module Pacruft
  class Package
    attr_reader :name

    def initialize name
      @name     = name
      @accessed = -1

      max = nil

      `pacman -Qql #{@name}`.lines do |out|
        fname = out.chomp

        begin
          if File.file?(fname)
            atime = File.atime(fname)
            max = atime if !max or atime > max
          end
        rescue # no read permissions
        end
      end

      @accessed = Time.now - max if max
    end

    def is_older_than? t
      @accessed > t.seconds
    end
  end
end
