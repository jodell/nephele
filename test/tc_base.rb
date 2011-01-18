require 'helper'

class TestNepheleBase < Test::Unit::TestCase
  context 'sanity' do
    should 'be sane' do
      assert_not_nil Nephele
      assert_not_nil Nephele::Base.new
      assert_kind_of Nephele::Rackspace,
        Nephele.new(:service => :rackspace, :user => 'foo', :key => 'bar')
      assert_raise RuntimeError do 
        Nephele.new(:service => :ec2, :user => 'foo', :key => 'bar')
      end
      assert_raise RuntimeError do
        Nephele.new(:service => 'garbage', :user => 'foo', :key => 'bar')
      end
    end
  end
end
