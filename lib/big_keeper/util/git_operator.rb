module BigKeeper
  # Operator for got
  class GitOperator
    def verify_branch(path, branch_name)
      git_fetch(path, branch_name)

      if current_branch(path) == branch_name
        raise %Q(Current branch is '#{branch_name}' already. Use 'update' please)
      end
      if has_branch(path, branch_name)
        raise %Q(Branch '#{branch_name}' already exists. Use 'switch' please)
      end
    end

    def current_branch(path)
      Dir.chdir(path) do
        `git rev-parse --abbrev-ref HEAD`.chop
      end
    end

    def has_branch(path, branch_name)
      has_branch = false
      IO.popen("cd #{path}; git branch -a") do |io|
        io.each do |line|
          has_branch = true if line.include? branch_name
        end
      end
      has_branch
    end

    def git_fetch(path, branch_name)
      Dir.chdir(path) do
        `git fetch origin`
      end
    end

    def git_rebase(path, branch_name)
      Dir.chdir(path) do
        `git rebase #{branch_name}`
      end
    end

    def commit(path, message)
      Dir.chdir(path) do
        `git add .`
        `git commit -m "#{message}"`
      end
    end

    def push(path, branch_name)
      Dir.chdir(path) do
        p `git push origin #{branch_name}`
      end
    end

    def pull(path, branch_name)
      Dir.chdir(path) do
        p `git pull origin #{branch_name}`
      end
    end

    def del(path, branch_name)
      Dir.chdir(path) do
        p `git branch -D #{branch_name}`
      end
    end

    def user
      `git config user.name`.chop
    end
  end

  # p GitOperator.new.user
  # BigStash::StashOperator.new("/Users/mmoaay/Documents/eleme/BigKeeperMain").list
end