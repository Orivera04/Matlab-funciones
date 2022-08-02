% ACRUBOND   定期的利払いの有価証券の経過利子
%
% INT = ACRUBOND(ID,SD,FD,RV,CPN,PER,BASIS)は、定期的利払いの有価証券の
% 経過利子を出力します。この関数は、標準、短期、長期の最初のクーポン期間
% をもつ有価証券の経過利子を計算します。ID は発行日、SD は決済日、FD は
% 最初のクーポン日、RV は額面価格、CPN はクーポン利率、PER は年間の期間数
% (デフォルト=2)、BASIS は日数カウント基準で、 0 = actual/actual
% (デフォルト)、1=  30/360、2 = actual/360、3 = actual/365のいずれかを
% 設定します。日付は、シリアル日付番号、または、日付文字列で入力します。
%       
% 例題：
%  
%       int = acrubond('31-jan-1983', '1-mar-1993',...  
%                            '31-jul-1983', 100, 0.1, 2, 0) 
%   
% この結果、int = 0.8011 が出力されます。
%  
% 参考 : ACRUDISC, CFAMOUNTS, ACCRFRAC.
%   
% 注意: 第1期間以後の経過利子を計算する時には、関数 cfamounts、または、
%       関数 accrfrac を実行するのが良いでしょう。なお入力引数をチェック
%       してください。


%       Author(s): C.F. Garvin, 2-23-95  
%       Copyright 1995-2002 The MathWorks, Inc.   
