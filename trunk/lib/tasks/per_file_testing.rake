module Rake
  class SingleTestTask < TaskLib
    def initialize(filename, &blk)
      @filename = filename
      @filename =~ %r{^test/\w+/(.*/?[^/]+)_test.rb$}
      @task_name = $1.gsub(/\//, '_')
      define(&blk)
    end

    def define
      desc "Run tests in #{@filename}"
      task @task_name => "db:test:prepare" do
        Rake::TestTask.new("__tmp:single") do |t|
          t.pattern = @filename
          t.libs << "test"
          t.verbose = true
          yield t if block_given?
        end
        Rake::Task["__tmp:single"].invoke
      end
    end
  end

  class GroupTestTask < TestTask
    def define
      lib_path = @libs.join(File::PATH_SEPARATOR)
      task @name do
        RakeFileUtils.verbose(@verbose) do
          @ruby_opts.unshift( "-I#{lib_path}" )
          @ruby_opts.unshift( "-w" ) if @warning
          ruby @ruby_opts.join(" ") +
            " \"lib/tasks/group_tester.rb\" -- " +
            file_list.collect { |fn| "\"#{fn}\"" }.join(' ') +
            " #{option_list}"
        end
      end
      self
    end
  end
end

namespace :test do
  namespace :units do
    Dir["test/unit/**/*_test.rb"].each do |file|
      Rake::SingleTestTask.new(file)
    end
  end

  namespace :functionals do
    Dir["test/functional/**/*_test.rb"].each do |file|
      Rake::SingleTestTask.new(file)
    end
  end

  namespace :integration do
    Dir["test/integration/**/*_test.rb"].each do |file|
      Rake::SingleTestTask.new(file)
    end
  end
  
  # add test:all so we can truly test unit/functional/integration tests all within one call to rcov
  desc 'Run unit, functional and integration tests as a single task (makes comprehensive rcov tests more useful)'
  Rake::GroupTestTask.new(:all => "db:test:prepare") do |t|
    t.libs << "test"
    t.pattern = 'test/**/*_test.rb'
    t.verbose = true
  end
end


namespace :db do
  namespace :schemadump do
    desc "Disable automatic dump of development database schema when running tests"
    task :off do
      `touch .rake-no-schema-dump`
    end
    desc "Enable automatic dump of development database schema when running tests"
    task :on do
      `rm -f .rake-no-schema-dump > /dev/null 2>&1`
    end
  end
end

if File.exist?('.rake-no-schema-dump')
  Rake.application.instance_eval { def remove_task(name) @tasks.delete(name); end }
  Rake.application.remove_task "db:structure:dump"
  namespace(:db){namespace(:structure){task(:dump)}}
end
