% cap4_ftp_exemplo
echo on
objftp=ftp('ftp.mathworks.com')
dir(objftp)
cd(objftp,'pub')
dir(objftp)
close(objftp)
