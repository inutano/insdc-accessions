require 'json'

module INSDCLink
  module SRA
    module RunMembers
      class << self
        def load_run_members(run_members_file_path)
          @@run_members = open(run_members_file_path)
          @@dir = File.dirname(run_members_file_path)
          @@jsonld_fpath = File.join(@@dir, "SRA_Run_Members.jsonld")
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
            @@run_members.each_line do |line|
              l = line.chomp.split("\t")
              link = {
                "@id" => "insdc.sra:" + l[0], # Run ID
                "id.org:link_to" => [
                  "insdc.sra:" + l[2],        # Experiemnt ID
                  "insdc.sra:" + l[3],        # Sample ID
                  "insdc.sra:" + l[4],        # Study ID
                  "biosample:" + l[8],        # BioSample ID
                ].select{|e| e !~ /-$/ },
              }
              write_io.puts(JSON.dump(link) + ",")
            end

            # Closing
            write_io.puts(footer)
          end
        end
      end
    end
  end
end
