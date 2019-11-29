$LOAD_PATH << __dir__
$LOAD_PATH << File.join(__dir__, "lib")

require "lib/insdc_link"

PROJ_ROOT = File.expand_path(__dir__)

Dir["#{PROJ_ROOT}/lib/tasks/**/*.rake"].each do |path|
  load path
end

namespace :insdc_link do
  desc "Generate JSON-LD for SRA Accessions relation"
  task :accessions do
    INSDCLink::SRA::Accessions.load_accessions("./data/SRA_Accessions.tab")
    INSDCLink::SRA::Accessions.generate_jsonld
  end

  desc "Generate JSON-LD for SRA Run Members relation"
  task :run_members do
    INSDCLink::SRA::RunMembers.load_run_members("./data/SRA_Run_Members.tab")
    INSDCLink::SRA::RunMembers.generate_jsonld
  end
end
