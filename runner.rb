#!/usr/bin/env ruby

require 'getoptlong'

# a runner just mechanically runs the benchmarks be told.
class Runner
  def initialize()
      @jvm_options = ['-XX:+UnlockDiagnosticVMOptions', '-Xbatch', '-XX:+PrintCodeCache']
      @prog_options = []
  end

  def run_all()
    BENCHMARKS.each do |b| 
      run_single b
    end 
  end

  def run_single(benchmark)
    puts "running #{benchmark}"
  end
end

# A plan consists of multiple-runs. It also manages configurations.
# eg. a plan can kick off 2 runs over an JVM option -XX:+SomethingNew.
class Plan < Runner
  def before_run
  end 

  def after_run
  end
end

$suite = nil
$repetition = nil
$benchmark = nil

opts = GetoptLong.new(
  ['--suite',      '-s', GetoptLong::REQUIRED_ARGUMENT],
  ['--benchmark',  '-b', GetoptLong::REQUIRED_ARGUMENT],
  ['--repeat',     '-r', GetoptLong::REQUIRED_ARGUMENT],
  ['--help',       '-h', GetoptLong::NO_ARGUMENT      ]
)

opts.each do |opt, arg|
  case opt
    when '--help'
      puts <<-EOF
hello [OPTION] ... DIR

-h, --help:
   show help

--repeat x, -r x:
   repeat x times

--suite s, -s suite 
  select benchmark suite

--benchmark name, -b name:
   specify a benchmark name in suite to run

EOF
    when '--repeat'
      $repetitions = arg.to_i
    when '--benchmark'
      $benchmark = arg
    when '--suite'
      $suite = arg
  end
end

if $0 == __FILE__
  $: .unshift '.'
  suite = 'Renaissance'
  
  load suite + '.rb'
  runner = Plan.new

  if $benchmark != nil
    if BENCHMARKS.include? $benchmark
      runner.run_single $benchmark
    else
      raise "unknown benchmark #{$benchmark} in #{$suite}"
    end
  else
    runner.run_all
  end
end
