class Fixnum # add some time helpers to Fixnum
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
end
