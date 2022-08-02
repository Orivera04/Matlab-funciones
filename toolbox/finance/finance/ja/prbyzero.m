% PRBYZERO   1組のゼロ曲線によってポートフォリオを構成する債券の価格を設定
%
% 使用法：
% BondPrices = prbyzero(Bonds, Settle, ZeroRates, ZeroDates)
%
% 入力：
%   Bonds     - 債券情報の NUMBONDS 行 6 列のポートフォリオ
%               Bonds = [ Maturity, CouponRate, Face, .....
%                               CouponPeriod, Basis, EOM]
%   Settle    - 決済日のシリアル日付番号
%   ZeroRates - 観測されるゼロ曲線のNUMDATES行NUMCURVES列の行列
%   ZeroDates - 観測されるゼロ値の日付 NUMDATES 行1列の列 
%
% 出力：
%   BondPrices - 債券のクリーンプライスからなるNUMBONDS行NUMCURVES列の
%                行列、各列は、それぞれ1つのゼロ曲線から構成されています。
%
% 参考 : TR2BONDS, ZBTPRICE.


%   Author(s): J. Akao
%   Copyright 1995-2002 The MathWorks, Inc. 
