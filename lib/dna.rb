require 'zlib'

##
# Dna
#
class Dna
  include Enumerable

  attr_reader :format

  def initialize(handle)
    @handle = handle
    @format = detect_format
    @iterator =
      case @format
      when :fasta
        FastaParser.new @handle
      when :fastq
        FastqParser.new @handle
      when :qseq
        QSEQParser.new @handle
      else
        raise "#{@format} not supported."
      end
  end

  def detect_format
    
    # is gzipped?
    unless @handle.class == Array # for tests mostly...
      begin
        @handle = Zlib::GzipReader.new(@handle)
      rescue
        @handle.rewind
      end
    end
    
    first_line = @handle.first
    @handle.rewind if @handle.class == File

    return :unknown if first_line == nil

    # detect qseq by counting number of tabs.
    if first_line.split("\t").length == 11
      return :qseq
    elsif first_line[0].chr == '>'
      return :fasta
    elsif first_line[0].chr == '@'
      return :fastq
    else
      raise Exception, "cannot detect format of input"
    end
  end

  def each &block
    @iterator.each(&block)
  end
end

class Record # nucleotide record
  def length
    @sequence.length
  end
end

Dir.glob(File.join(File.dirname(__FILE__), 'parsers', '*.rb')).each { |f| require f }