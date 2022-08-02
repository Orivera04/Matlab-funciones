function varargout = gui_diagstats( m, action, varargin )
%GUI_DIAGSTATS   GUI Tool for displaying ANOVA Table and other statistics.
%   GUI_DIAGSTATS(M,ACTION)
%
%   See also XREGRBF/GUI_DIAGSTATS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:50:43 $


switch lower(action)
case 'create'
   % create tool
   varargout{1}=i_Create(varargin{:});
case 'id'
   varargout{1}='model';
end

%------------------------------------------------------------------------------|
function Tool= i_Create(hFig);
% create Stats tables

Tool.layout= xregcontainer(hFig);

%------------------------------------------------------------------------------|

% % % % % We really want to use the inherited method from xregrbf but we want to modify 
% % % % % i_Display
% % % % 
% % % % switch lower( action )
% % % % case 'display'
% % % %     % Update Table Values
% % % %     i_Display(m,varargin{:});
% % % % otherwise
% % % %     if nargout > 0,
% % % %         [varargout{1:nargout}] = gui_diagstats( m.xregrbf, action, varargin{:} );
% % % %     else
% % % %         gui_diagstats = gui_diagstats( m.xregrbf, action, varargin{:} );
% % % %     end
% % % % end
% % % % 
% % % % %------------------------------------------------------------------------------|
% % % % function i_Display(Model,Tool)
% % % % 
% % % % StatsRes= stats(Model,'stepwise');
% % % % 
% % % % % Display Anova Table
% % % % Tool.Anova(:,:)= StatsRes(:,1:3);
% % % % Store = get(Model,'Store');%save data to the xreglinear store
% % % % % PRESS, PRESS R^2, R^2 (stored in last column of StatsRes
% % % % cost = getFitOpt(Model,'cost');
% % % % if isempty(cost)
% % % %     cost = Inf;
% % % % end   
% % % % 
% % % % if prod( size( Store.X ) ) < 500,
% % % %     cond_X = cond(Store.X);
% % % % elseif prod( size( Store.X ) ) < 2000,
% % % %     cond_X = condest(Store.X);
% % % % else,
% % % %     cond_X = -1;
% % % % end
% % % % 
% % % % Tool.Stats(:,1) = [ StatsRes(:,end)' sqrt(StatsRes(end-1,3)) cost cond_X ];
% % % % 
% % % % return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
