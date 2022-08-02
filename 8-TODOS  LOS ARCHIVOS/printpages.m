%p = ['lpr -Php114-duplex 111.ps'];
p = ['lpr -Php114 111.ps'];
for i=51:204
  s = ['dvips -o 111.ps notes-root -pp ' int2str(i) ':' int2str(i+1)];
  disp(s)
  [status,result] = unix(s);
  disp(status)
  disp(result)
  
  [status,result] = unix(p);
  disp(status)
  disp(result)
  pause(120)
end


