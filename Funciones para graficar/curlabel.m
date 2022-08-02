function curlabel(txt)

% curlabel('txt')  Puts  a  text  label  on  the  end  of a line
% pointing  to  a  curve.  Click on the curve where you want the
% line  to  point  to and then click at the postion of the curve
% label.  The  justification  of  the  text  is  taken  care  of
% automatically.

%                                        Andrew Knight, Dec. 1992


disp('Please click on the curve where you want the line to point to')
disp('and then click at the postion of the curve label')
disp(['(Doing label: ' txt ')'])

HoldState = ishold;
if HoldState~=1
   hold on
end
ax = axis;
axis(ax)
[x,y] = ginput(2);
if abs(x(2) - x(1))<(ax(2) - ax(1))/20
   halignment = 'center';
   if y(1)<y(2)
      valignment = 'bottom';
   else
      valignment = 'top';
   end
else
   valignment = 'middle';
   if x(2) > x(1)
      halignment = 'left';
   else
      halignment = 'right';
   end
end
if ~(x(1)==x(2) & y(1)==y(2))
  plot(x,y)
end
text(x(2),y(2),txt,'HorizontalAlignment',halignment,...
                   'VerticalAlignment',  valignment)

% Restore hold state:
if HoldState==0
   hold off
end

% Write m-file segment into file which does the same thing without the
% mouse:

if x(1)~=x(2) & y(1)~=y(2)

  s = ['xcurlabel = [ ' num2str(x(1)) ' ' num2str(x(2)) '];'];
  s = str2mat(s,...
      ['ycurlabel = [ ' num2str(y(1)) ' ' num2str(y(2)) '];']);
  s = str2mat(s,'plot(xcurlabel,ycurlabel)');
  s = str2mat(s,...
      ['text(xcurlabel(2),ycurlabel(2),''' txt ...
	  ''',''HorizontalAlignment'','''  halignment ...
	  ''',''VerticalAlignment'',''' valignment ''')']);
  for i = 1:4
    disp(deblank(s(i,:)))
  end
  
else
  
  s = ['xcurlabel = ' num2str(x(1)) ';'];
  s = str2mat(s,...
      ['ycurlabel = ' num2str(y(1)) ';']);
  s = str2mat(s,...
      ['text(xcurlabel,ycurlabel,''' txt ...
	  ''',''HorizontalAlignment'',''' halignment ...
	  ''',''VerticalAlignment'',''' valignment ''')']);
    
  for i = 1:3
    disp(deblank(s(i,:)))
  end

end

