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

        def context
          {
            "id.org" => "http://identifiers.org/",
            "insdc.org" => "http://identifiers.org/insdc.sra/",
            "biosample" => "http://identifiers.org/biosample/",
          }
        end

        def context_jsonld
          JSON.dump(context)
        end

        def header
          '{"@context":' + context_jsonld + ', "@graph":['
        end

        def footer
          ']}'
        end

        def generate_jsonld
          open(@@jsonld_fpath, "w") do |write_io|
            # JSON-LD header
            write_io.puts(header)

            # Entities
            @@accessions.each_line do |line|
              l = line.split("\t")
              write_io.puts(
                JSON.dump(
                  {
                    "@id" => l[0], # Accession ID
                    "link_to" => [
                      l[1],        # Submission ID
                      l[10],       # Experiment ID
                      l[11],       # Sample ID
                      l[12],       # Study ID
                      l[17],       # BioSample ID
                      l[18],       # BioProject ID
                    ] - ["-"],
                  }
                )
              )
            end
            
            # Closing
            write_io.puts(footer)
          end
        end
      end
    end
  end
end
