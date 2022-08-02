function whoami
% Test function to illustrate the use of the java.net package.
%
% Mastering MATLAB 6 Java Example 1 - 7/3/00

% Use try and catch to avoid an exception.

try
    me = java.net.InetAddress.getLocalHost;
catch
    error('Unable to get local host address.');
end

% Find my hostname and IP address

myname = me.getHostName;
myip = me.getHostAddress;

% and print the results.

disp(sprintf('My host name is %s', char(myname)));
disp(sprintf('My IP address is %s', char(myip)));
