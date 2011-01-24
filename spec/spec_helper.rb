$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'auto_do_something'
Bundler.require(:default, :development)

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
end

class User
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include AutoDoSomething

  # mass assignment
  def initialize(attrs)
    attrs.each do |k, v|
      send("#{k}=", v)
    end
  end

  attr_accessor :nickname, :email, :info

  # i want strip these fields
  auto :strip, :for => [:nickname, :email, :info]

  # and i want downcase all email address
  auto :downcase, :for => :email

  # if info is too long, then just truncate it
  auto :[], :with => 0...10, :for => :info
  # or
  #auto_do :[], :with => [0, 10], :for => :info

  def persisted?
    false
  end
end
