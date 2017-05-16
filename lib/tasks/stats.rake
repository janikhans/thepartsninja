task stats: 'thepartsninja:statsetup'

namespace :thepartsninja do
  task :statsetup do
    require 'rails/code_statistics'
    ::STATS_DIRECTORIES << ['Forms', 'app/forms']
    ::STATS_DIRECTORIES << ['Importers', 'app/importers']
    ::STATS_DIRECTORIES << ['Classes', 'app/classes']

    # For test folders not defined in CodeStatistics::TEST_TYPES (ie: spec/)
    ::STATS_DIRECTORIES << ['Form tests', 'test/forms']
    CodeStatistics::TEST_TYPES << 'Form tests'
  end
end
