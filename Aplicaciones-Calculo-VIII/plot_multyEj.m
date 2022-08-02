%   Example of plot_multy
   time = 0:.01:20;
   TIME_g    = struct('Data',time,'Label','time');
   COS_g     = struct('Data',cos(time),'Label','cos t');
   SIN_g     = struct('Data',sin(time),'Label','sin t');
   TAN_g     = struct('Data',tan(time),'Label','tan t','Scale',[-5 5],'Color','k');
   COS2_g    = struct('Data',cos(2*time),'Label','cos 2t','Color','r');
   SIN2_g    = struct('Data',sin(2*time),'Label','sin 2t','Color','r');
   SINxCOS_g = struct('Data',cos(time).*sin(time),'Label','sin t x cos t','Color','m');
   SINCOS_g  = struct('Data',[sin(time); cos(time)],'Label','sin t, cos t');
   plot_multiy(TIME_g,COS_g,SIN_g,TAN_g,COS2_g,SIN2_g,SINxCOS_g,SINCOS_g)
   title('Trig functions')
