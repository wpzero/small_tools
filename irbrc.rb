### self consistent config
require 'rubygems'
require 'benchmark'
require 'json'

# gem which awesome_print get path
$: << '/Users/wpzero/.rvm/gems/ruby-2.3.1@rails5/gems/awesome_print-1.7.0/lib/'

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


def measure(&block)
  no_gc = (ARGV[0] == '--no-gc')

  if no_gc
    GC.disable
  else
    GC.start
  end

  memory_before = `ps -o rss= -p #{Process.id}`.to_i / 1024
  gc_stat_before = GC.stat
  time = Benchmark.realtime do
    yield
  end
  puts ObjectSpace.count_objects
  unless no_gc
    GC.start(full_mark: true, immediate_sweep: true, immediate_mark: false)
  end
  puts ObjectSpace.count_objects
  gc_stat_after = GC.stat
  memory_after = `ps -o rss= -p #{Process.id}`.to_i / 1024

  puts({
         RUBY_VERSION => {
           gc: no_gc ? 'disabled' : 'enabled',
           time: time.round(2),
           gc_count: gc_stat_after[:count] - gc_stat_before[:count],
           memory: "%d MD" % (memory_after - memory_before)
         }
       })
end
