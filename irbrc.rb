### self consistent config
require 'rubygems'
require 'benchmark'

# gem which awesome_print get path
$: << '/Users/wpzero/.rvm/gems/ruby-2.2.4@rails4.2.6/gems/awesome_print-1.7.0/lib/'

require 'awesome_print'

AwesomePrint.irb!

alias p puts

def bb(&block)
  Benchmark.bm do |x|
    x.report(&block)
  end
end

def source_for(object, method_sym)
  if object.respond_to?(method_sym, true)
    method = object.method(method_sym)
  elsif object.is_a?(Module)
    method = object.instance_method(method_sym)
  end
  location = method.source_location
  location
rescue
  nil
end

def ob_str_size(object)
  str = Marshal.dump(object)
  str.bytesize
end

require 'SecureRandom'

def give_me_a_password(length = 6)
  SecureRandom.hex[0..length-1]
end

# A simple method to get gem path by gem name
if defined?(Bundler)
  def gem_path_by_name(gem_name)
    Bundler.rubygems.find_name(gem_name).first.full_gem_path
  end
end
