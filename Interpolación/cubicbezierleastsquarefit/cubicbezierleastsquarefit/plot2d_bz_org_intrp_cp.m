% % plot original data, interpolated data, control points of bezier curve
% Mat: original data
% MatI: approximated (fitted) data
% p0mat,p1mat,p2mat,p3mat: control points

function plot2d_bz_org_intrp_cp(Mat,MatI,p0mat,p1mat,p2mat,p3mat)

lw=2; %line width

plot(Mat(:,1),Mat(:,2),'b','Linewidth',lw);               % original data
plot(MatI(:,1),MatI(:,2),'g','Linewidth',lw);                                     % interpolated
bpx=[p0mat(:,1);p3mat(end,1)];
bpy=[p0mat(:,2);p3mat(end,2)];
plot(bpx,bpy,'ro','Linewidth',lw);                                                
legend('Original Data','Fitted Data','Break Points','Location','SouthEast');

% plot([p1mat(:,1),p2mat(:,1)],[p1mat(:,2),p2mat(:,2)],'rd','Linewidth',lw)
% ;    % middle control points

% % % -------------------------------------------------------------------------
% % % This program or any other program(s) supplied with it does not provide any
% % % warranty direct or implied. This program is free to use/share for
% % % non-commercial purpose only, for any other usage contact with author.
% % % Kindly reference author.
% % % Thanking you.
% % % @ Copyright M Khan
% % % Email: mak2000sw@yahoo.com
% % %        mak2000@GameBox.net 
% % % http://www.geocities.com/mak2000sw