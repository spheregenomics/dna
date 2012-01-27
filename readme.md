# DNA

Austin G. Davis-Richardson

Sequence file iterator

Supported Formats:

  - [fasta](http://en.wikipedia.org/wiki/FASTA)
  - [fastq](http://en.wikipedia.org/wiki/Fastq)
  - [qseq](http://blog.kokocinski.net/index.php/qseq-files-format?blog=2)

[Request a format](https://github.com/audy/dna/issues/new)

## Installation

`gem install dna`

## Usage

```ruby

require 'dna'

File.open('sequences.fasta') do |handle|
  records = Dna.new(handle)
  
  records.each do |record|
    puts record.length
  end
end
```