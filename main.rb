require "httparty"
require "colorize"

puts "[*] RubyFuzz loading...".blue

def clear_screen()
    puts "\e[H\e[2J"
end

def domain_exists?(domain)
    begin
        Socket.gethostbyname(domain)
    rescue SocketError
        return false
    end

    return true
end

def subdomain_scan()
    print "Domain name: "
    base_domain = gets.chomp
    start = Time.now    
    IO.foreach('./fuzzdb/discovery/dns/dnsmapCommonSubdomains.txt') do |line|
        line.strip!
        if domain_exists?(line + "." + base_domain) then
            puts "[OK] ".green + line.green + ".".green + base_domain.green + " exists!".green
        end
    end
    finish = Time.now
    puts "Finished scan in " + (finish - start).round(3).to_s + " seconds."
    main_menu()
end


def main_menu()
    puts "RubyFuzz v0.1"
    puts "1) Subdomain Scan"

    puts "99) Exit"

    print "$ "
    choice = gets.chomp.to_i

    if choice == 1 then
        subdomain_scan()        
    elsif choice == 99 then
        exit()
    end
end

puts "[*] Checking enviroment...".blue

if !Dir.exist?("fuzzdb")
    puts "[ERR] Please install the fuzzdb submodule using 'git submodule update --init'.".red
    abort()
end

main_menu()
