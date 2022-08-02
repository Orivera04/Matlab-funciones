%=MLINK|MFDC!'INTC,LAST'
clc
chan = ddeinit('MLINK', 'MFDC');
a = ddereq(chan, 'AA,LAST')

%chan = ddeinit('excel', 'examples.xls');
%a = ddereq(chan, 'R2C3')


%rc = ddeadv(chan, 'r1c1:r5c5', 'disp(x)', 'a');
