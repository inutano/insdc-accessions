require 'json'

module INSDCLink
  module SRA
    class << self
      def parse_accessions(accessions_fpath)
        open(accessions_fpath).each_line do |line|
          l = line.chomp.split("\t")
          link = [1,10,11,13,17,18].map{|i| l[i] } - ["-"]
          body = {
            "@id" => l[0],
            :link => [
              l[1],
              l[10],
              l[11],
              l[13],
              l[17],
              l[18],
            ] - ["-"]
          }
          puts JSON.dump(body)
        end
      end
    end
  end
end
