m=magic(10);
h=surf(m);
xl=ddeinit('excel','Sheet1');
range1='r1c1:r10c10';
range2='r1c1:r9c9';
status=ddepoke(xl,range1,m);

status=ddeadv(xl,range1,...
          'set(h,''ZData'',z);set(h,''CData'',z);','z');

status=ddepoke(xl,range2,magic(9));

pause

status=ddeunadv(xl,range1);
status=ddeterm(xl);




