require 'json'

module INSDCLink
  module SRA
    module Accessions
      class << self
        def load_accessions(accessions_file_path)
          accessions_tmp_path = accessions_file_path + ".tmp"
          system("sed -e '1,1d' #{accessions_file_path} > #{accessions_tmp_path}")

          @@accessions = open(accessions_tmp_path)
          @@number_of_entries = open(accessions_tmp_path).readlines.size

          @@dir = File.dirname(accessions_file_path)
          @@jsonld_fpath = File.join(@@dir, "SRA_Accessions.jsonld")
        end

        def context
          {
            "id.org" => "http://identifiers.org/",
            "insdc.org" => "http://identifiers.org/insdc.sra/",
            "biosample" => "http://identifiers.org/biosample/",
            "bioproject" => "http://identifiers.org/bioproject/",
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

        def add_header
          open(@@jsonld_fpath, "w") do |io|
            io.print(header)
          end
        end

        def remove_last_camma
          File.truncate(@@jsonld_fpath, File.size(@@jsonld_fpath) - 1)
        end

        def add_footer
          remove_last_camma
          open(@@jsonld_fpath, "a") do |io|
            io.print(footer)
          end
        end

        def add_content
          open(@@jsonld_fpath, "a") do |write_io|
            @@accessions.each_line do |line|
              l = line.split("\t")
              write_io.print(
                JSON.dump(
                  {
                    "@id" => "insdc.org:" + l[0], # Accession ID
                    "id.org:link_to" => [
                      "insdc.org:" + l[1],        # Submission ID
                      "insdc.org:" + l[10],       # Experiment ID
                      "insdc.org:" + l[11],       # Sample ID
                      "insdc.org:" + l[12],       # Study ID
                      "biosample:" + l[17],       # BioSample ID
                      "bioproject:" + l[18],       # BioProject ID
                    ] - ["insdc.org:-", "biosample:-", "bioproject:-"],
                  }
                ) + ","
              )
            end
          end
        end

        def generate_jsonld
          add_header
          add_content
          add_footer
        end
      end
    end
  end
end
