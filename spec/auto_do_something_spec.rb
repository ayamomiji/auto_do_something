require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe AutoDoSomething do
  let(:item) { Item.new }

  it 'auto do something after validation' do
    item = Item.new
    item.value = 'value'
    item.another_value = 'another_value'
    item.value.should == 'value'
    item.another_value.should == 'another_value'

    item.valid?
    item.value.should == 'DS: value'
    item.another_value.should == 'DS: another_value'
  end

  it 'dont do anything if attribute value is not respond to method' do
    item = Item.new
    item.value = :'value'
    item.another_value = :'another_value'
    item.value.should == :'value'
    item.another_value.should == :'another_value'

    item.valid?
    item.value.should == :'value'
    item.another_value.should == :'another_value'
  end
end
