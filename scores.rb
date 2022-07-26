#!/usr/bin/env ruby

# do the statistics of renaissance results
#
# probably should choose gem 'enumerable-statistics' in the future.
# so far, we only need simple procedures.
#
def median(a)
  copy = a.sort
  return copy[a.size / 2]
end

def mean(a)
  return a.inject(0.0, :+) / a.size
end

# standard deviation
# treat 'a' as a sample, so use N-1 correction
def stddev(a)
  avg = mean(a)
  sum = a.inject(0.0) { |sum, e| sum + (e - avg) ** 2 }
  variance = sum / (a.size - 1)
  std = Math.sqrt(variance)
  std
end

WARMUP_ITER = 3
$codecache_used = nil
$codecache_max  = nil

# output: comma-separated CSC
# mean, stddev, median[, codecache_used, codecache_max] \n
def renassance_result(output)
  results = []
  output.each do |line|
    # ====== chi-square (apache-spark) [default], iteration 57 completed (795.509 ms) ======
    line.match /iteration \d+ completed \((\d+\.\d+) ms\)/ do |m|
      #puts line, m[1]
      results << m[1].to_f
    end

    # CodeHeap 'profiled nmethods': size=118876Kb used=13066Kb max_used=13066Kb free=105809Kb
    line.match /^CodeHeap 'profiled nmethods':.*used=(\d+)Kb.*max_used=(\d+)Kb/ do |m|
      $codecache_used = m[1].to_i
      $codecache_max  = m[2].to_i
    end
  end

  #puts "warmup #{WARMUP_ITER} iterations"
  # drop first WARMUP_ITER results
  results.shift WARMUP_ITER
  printf "%.3f, %.3f, %.3f", mean(results), stddev(results), median(results)
  if $codecache_used != nil and $codecache_max != nil
     printf ", %d, %d\n", $codecache_used, $codecache_max
   else
     puts 
  end
end

if $0 == __FILE__
  output = ARGF.readlines
  renassance_result output
end
