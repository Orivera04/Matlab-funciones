% BUSDATE   次または前の営業日
% 
% BD = BUSDATE(D,DIREC,HOL,WEEKEND) 
%
% 入力:
%
%   D       - 基準の営業日
%
% 入力(オプション):
%
%   DIREC   - つぎ(DIREC = 1, デフォルト)の営業日か前(DIREC = -1)の
%             営業日かを指定します。
%
%   HOL     - 休業日のベクトル。HOL の指定がない場合は、ルーチン 
%             HOLIDAYS によって決定されます。
%             現時点では、HOLIDAYS はNYの休日をサポートします。
%
%   WEEKEND - 週末を1とする0と1を含む長さ7のベクトルです。
%             このベクトルの最初の要素は、日曜日に対応します。
%             そのため、土曜日と日曜日が週末とすると、
%             WEEKDAY = [1 0 0 0 0 0 1] となります。デフォルトでは、
%             土曜日と日曜日が週末になります。
%
% 出力:
%
%  BD       - HOL によって、つぎ、または前の営業日になります。
%  
% たとえば、bd = busdate('3-jul-1997',1)は、 July 7, 1997 に対応する
% シリアル日付番号 bd = 729578 を出力します。  
%
% 参考 : HOLIDAYS, ISBUSDAY.


%   Author(s): C.F. Garvin, 10-31-95
%  Copyright (c) 1995-1999 The MathWorks, Inc. All Rights Reserved.
