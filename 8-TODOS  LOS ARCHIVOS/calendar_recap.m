%% Calendar Chapter Recap
% This is an executable program that illustrates the statements
% introduced in the Calendar Chapter of "Experiments in MATLAB".
% You can access it with
%
%    calendar_recap
%    edit calendar_recap
%    publish calendar_recap
%
% Related EXM programs
%
%    biorhythm.m
%    easter.m
%    clockex.m
%    friday13.m

%% Clock and fprintf
   format bank
   c = clock
   f = '%6d %6d %6d %6d %6d %9.3f\n'
   fprintf(f,c);

%% Modular arithmetic
   y = c(1)
   is_leapyear = (mod(y,4) == 0 && mod(y,100) ~= 0 || mod(y,400) == 0)

%% Date functions
   c = clock;
   dnum = datenum(c)
   dnow = fix(now)
   xmas = datenum(c(1),12,25)
   days_till_xmas = xmas - dnow
   [~,wday] = weekday(now)

%% Count Friday the 13th's
    c = zeros(1,7);
    for y = 1:400
       for m = 1:12
          d = datenum([y,m,13]);
          w = weekday(d);
          c(w) = c(w) + 1;
       end
    end
    format short
    c

%% Biorhythms
    bday = datenum('8/17/1939')
    t = (fix(now)-bday) + (-28:28);
    y = 100*[sin(2*pi*t/23)
             sin(2*pi*t/28)
             sin(2*pi*t/33)];
    plot(t,y)
    axis tight
