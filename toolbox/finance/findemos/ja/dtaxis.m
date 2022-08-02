% DTAXIS   データと同期させた日付軸ラベル
%
% 使用法：dtaxis(XYZ, DateForm, StartDate, TickDateSpace)
%
% 入力：
% XYZ           : 'x', 'y', 'z' のいずれかの文字列。デフォルト: 'x'
% DateForm      : 日付文字列の日付書式フラグ。デフォルト: 6  -> 'mm/dd'
% StartDate     : 軸の最小日付。              デフォルト: data-min
% TickDateSpace : 目盛り間に割り当てることのできる最小日数です。
%    
% 例題： 
%   dates = cfdates(today, today+3*365, 2);
%   plot( dates, rand(size(dates)))
%   dtaxis('x',2,[],180)


% Example utility J. Akao 11/08/97
% Copyright 1995-2002 The MathWorks, Inc.  
