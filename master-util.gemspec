# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'master-util/version'

Gem::Specification.new do |s|
  s.name        = 'master-util'
  s.version     = MasterUtil::VERSION
  s.date        = '2014-09-23'
  s.summary     = "MasterUtil!"
  s.description = "master-util gem"
  s.authors     = ["YHL"]
  s.email       = 'yun_haiyuan@163.com'
  s.homepage    = 'https://github.com/yinhailiang'
  s.license       = 'MIT'

   s.files = `git ls-files`.split("\n")
   s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
   s.require_paths = ["lib"]
end