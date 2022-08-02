function resolveip(input)
try 
    address = java.net.InetAddress.getByName(input);
catch 
    error(sprintf('Unknown host %s.', input));
end
hostname = address.getHostName;
ipaddress = address.getHostAddress;
if strcmp(input,ipaddress)
    disp(sprintf('Host name of %s is %s', input, hostname)); 
else 
    disp(sprintf('IP address of %s is %s', input, ipaddress));
end;
