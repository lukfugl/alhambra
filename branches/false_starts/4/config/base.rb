require 'rubygems'
require 'active_record'
require 'yaml'

ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
dblog = File.join(ROOT, 'log', 'database.log')
dbconfig = File.join(ROOT, 'config', 'database.yml')

ActiveRecord::Base.logger = Logger.new(File.open(dblog, 'a'))
ActiveRecord::Base.establish_connection(YAML::load(File.open(dbconfig)))

$LOAD_PATH << File.join(ROOT, 'app')
