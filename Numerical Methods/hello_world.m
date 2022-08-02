% HELLO_WORLD  Traditional greeting.
% Programming languages are traditionally introduced by the
% phrase 'hello world'.  Here is a demo of some MATLAB capabilities.
% Usage:
%    publish hello_world

   help hello_world
   format loose

%% Array operations

   h = 'hello world'
   h'
   fliplr(h)
   flipud(h')
   diag(h)
   sort(h)

%% Characters

   x = real(h)
   char(x)
   char(max(h))
   char(x+3)

%% Plots

   H = upper(h)
   
   figure(1)
   plot(x,'*-')
   title(H)
   
   figure(2)
   bar(x)
   set(gca,'xticklabel',{H(:)})
   set(2,'pos',get(1,'pos')+[30 -30 0 0])
   
   figure(3)
   p = pie(x);
   for k = 1:11
      set(p(2*k),'string',H(k))
   end
   set(3,'pos',get(1,'pos')+[60 -60 0 0])
