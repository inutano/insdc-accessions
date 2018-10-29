require 'json'

module INSDCLink
  module SRA
    class << self
      def parse_accessions(accessions_fpath)
        open(accessions_fpath).each_line do |line|
          l = line.chomp.split("\t")
          entry = {
            "@id" => l[0], # Accession ID
            :link => [
              1,           # Submission ID
              10,          # Experiment ID
              11,          # Sample ID
              13,          # Study ID
              17,          # BioSample ID
              18,           # BioProject ID
            ].map{|i| l[i] } - ["-"],
          }
        end
      end
    end
  end
end
