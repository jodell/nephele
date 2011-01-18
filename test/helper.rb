require 'bundler'
Bundler.setup
require 'test/unit'
require 'shoulda'
$: << File.expand_path(File.dirname(__FILE__) + '/lib')
require 'nephele'
