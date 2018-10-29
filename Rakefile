$LOAD_PATH << __dir__
$LOAD_PATH << File.join(__dir__, "lib")

require "lib/insdc_link"

PROJ_ROOT = File.expand_path(__dir__)

Dir["#{PROJ_ROOT}/lib/tasks/**/*.rake"].each do |path|
  load path
end

namespace :insdc_link do
  desc "Generate INSDC Link data in JSON-LD"
  task :json_ld do
    INSDCLink::SRA::Accessions.load_accessions("./data/SRA_Accessions.tab")
    INSDCLink::SRA::Accessions.generate_jsonld
  end
end
