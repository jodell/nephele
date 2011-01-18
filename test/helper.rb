require 'bundler'
Bundler.setup
require 'test/unit'
require 'shoulda'
require 'mocha'

$: << File.expand_path(File.dirname(__FILE__) + '/lib')
require 'nephele'
