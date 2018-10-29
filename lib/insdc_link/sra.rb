require 'json'

module INSDCLink
  module SRA
    module Accessions
      class << self
        def load_accessions(accessions_file_path)
          @@accessions = open(accessions_file_path)
          @@dir = File.dirname(accessions_file_path)
          @@jsonld_fpath = File.join(@@dir, "SRA_Accessions.jsonld")
        end

        def generate_jsonld
          open(@@jsonld_fpath, "w") do |write_io|
            @@accessions.each_line do |line|
              l = line.chomp.split("\t")
              entry = {
                "@id" => l[0], # Accession ID
                :link_to => [
                  1,           # Submission ID
                  10,          # Experiment ID
                  11,          # Sample ID
                  12,          # Study ID
                  17,          # BioSample ID
                  18,          # BioProject ID
                ].map{|i| l[i] } - ["-"],
              }
              write_io.puts(JSON.dump(entry))
            end
          end
        end
      end
    end
  end
end
