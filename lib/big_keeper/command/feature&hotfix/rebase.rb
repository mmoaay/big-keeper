require 'big_keeper/util/logger'
require 'big_keeper/util/cache_operator'

require 'big_keeper/dependency/dep_service'

module BigKeeper
  def self.rebase(path, user, type)
    begin
      # Parse Bigkeeper file
      BigkeeperParser.parse("#{path}/Bigkeeper")
      branch_name = GitOperator.new.current_branch(path)

      Logger.error("Not a #{GitflowType.name(type)} branch, exit.") unless branch_name.include? GitflowType.name(type)

      modules = ModuleCacheOperator.new(path).current_path_modules

      modules.each do |module_name|
        ModuleService.new.rebase(path, user, module_name, branch_name, type)
      end

      Logger.highlight("Rebase '#{GitflowType.base_branch(type)}' "\
        "to branch '#{branch_name}' for 'Home'...")

      # Rebase Home
      Logger.error("You have some changes in branch '#{branch_name}' "\
        "for 'Home'. Use 'push' first please") if GitOperator.new.has_changes(path)

      GitService.new.verify_rebase(path, GitflowType.base_branch(type), 'Home')
    ensure
    end
  end
end
