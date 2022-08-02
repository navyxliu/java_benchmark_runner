#TODO: download it from the official website and do checksum
RENAISSANCE="./renaissance-gpl-0.14.1.jar"
BENCHMARKS = %x/java -jar #{RENAISSANCE} --raw-list/.split

puts "loading suite #{RENAISSANCE}..."
#puts BENCHMARKS
