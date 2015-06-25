def usage()
  if ARGV[0] == nil
    puts "Usage ./ers_client [local|http] <http url>"
    puts "examples: "
    puts "./ers_client local # to send in memory requests"
    puts "./ers_client http http://localhost:9292 # to send network requests"
    exit 1
  else
    if ARGV[0] == 'local'
      using_local = true
    elsif ARGV[0] == 'http'
      using_local = false
      if ARGV[1] == nil
        puts 'please provide a host to send requests to'
        exit 1
      else
        host = ARGV[1]
      end 
    else
      puts 'options are either local or http'
      exit 1
    end
    
  end
  [using_local, host]
end
