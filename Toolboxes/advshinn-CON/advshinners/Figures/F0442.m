k = .2558;
num = k*[1 .98]; den = conv([1 -.2],[1 -1]);
nm = num; dn = poly_add(num,den);
t = 0:10;
c = deconv([nm 0 0*t],conv(dn,[1 -1]));
plot([1;1]*t,[[0;1]*c],'g-',t,1+0*t,'r--');
xlabel('t (sec)'); ylabel('c*(t)');
%
if ( exist('ncdblocks') > 0 )
  pause;
  disp('Root Locus plot from figure 10.41 shows the stable limits on K');
  disp('0 <= K < 0.8193');
  disp('A zeta of .45 is desired, corresponding to 20.56% overshoot');
  disp('An approximation of K shall be estimated by the');
  disp('NonLinear Control Design Toobox, just open the appropriate block,');
  disp('and start the optimization going.  If you desire, you may play');
  disp('around with the constraint window to see the effects.');
  disp('I used the step response to set the constraints by using:');
  disp('Settling time = 8.5 and Percent overshoot = 20.57');
  disp('Also 4.25 @ 70%');
end