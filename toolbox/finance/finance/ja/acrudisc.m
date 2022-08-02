% ACRUDISC   満期償還割引有価証券の経過利子
%
% INT = ACRUDISC(SD,MD,RV,DISC,PER,BASIS)は、満期償還割引有価証券の経過
% 利子を出力します。SD は決済日、MD は満期日、RV は有価証券の額面価格、
% DISC は有価証券の割引率、PER は年間の期間数(デフォルト=2)、BASIS は
% 日数カウント基準で、0 = actual/actual (デフォルト)、1=  30/360、
% 2 = actual/360、3 = actual/365 のいずれかを設定します。日付はシリアル
% 日付番号または、日付文字列で入力します。
%   
% 例題： 
%   
%       int = acrudisc('05/01/1992','07/15/1992',100, 0.1, 2, 0)  
%   
% この結果 int = 2.0604 が出力されます。  
%   
% 参考 : ACRUBOND, YLDDISC, PRDISC, YLDMAT, PRMAT.
%   
% 参考文献：SIA Standard Securities Calculation Methods,   
%           Volumes I-II, 3rd Edition.   Formula D


%       Author(s): C.F. Garvin, 2-23-95   
%       Copyright 1995-2002 The MathWorks, Inc.    
