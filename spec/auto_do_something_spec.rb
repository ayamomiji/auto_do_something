require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe AutoDoSomething do
  it 'should strip all fields' do
    user = User.new(:nickname => ' ayaya ',
                    :email => ' ayaya@example.com ',
                    :info => ' hello! ')
    user.valid?
    user.nickname.should == 'ayaya'
    user.email.should == 'ayaya@example.com'
    user.info.should == 'hello!'
  end

  it 'should strip and downcase email' do
    user = User.new(:nickname => ' ayaya ',
                    :email => ' AYAYA@EXAMPLE.COM ',
                    :info => ' hello! ')
    user.valid?
    user.email.should == 'ayaya@example.com'
  end

  it 'should truncate info to 10 characters' do
    user = User.new(:nickname => ' ayaya ',
                    :email => ' AYAYA@EXAMPLE.COM ',
                    :info => ' hello world! ')
    user.valid?
    user.info.should == 'hello worl'
  end
end
