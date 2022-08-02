% CFPORT   キャッシュフロー額のポートフォリオ形式
%
% 債権ポートフォリオの全キャッシュフロー日付のベクトルと、これらの
% キャッシュフロー日付に対する各債権のキャッシュフローを写像した行列を
% 出力します。出力された行列は、割引係数曲線に対して債権の価格を決定する
% 時に使用します。
% 
%   [CFBondDate, AllDates, AllTF, IndByBond] = cfport(...
%                                         CFlowAmounts, CFlowDates, TFactors)
%   
% 入力：
% CFlowAmounts  - CFlowDates で示された各日付に対応するキャッシュフロー
%                 の総額を示す入力をもつNUMBONDS行M列の行列です。 
%
% CFlowDates   - 各債権のキャッシュフロー日付を示し、空白部を NaN で
%                埋められた行をもつNUMBONDS行M列の行列です。
%
% TFactors     - 決済日と半年クーポン期間で割り出されたキャッシュフロー
%                日付間の時間を示す入力をもつNUMBONDS行M列の行列です。
%
% 出力：
% CFBondDate   - 各証券、及び、AllDates に記載のある日付毎にインデックス
%                付けされたキャッシュフローで構成されるNUMBONDS行
%                NUMDATES列の行列です。各行は、AllDates の入力要素に
%                対応するインデックスにおける当該債権のキャッシュフロー
%                で構成されています。各行におけるその他のインデックスは、
%                ゼロで構成されます。
%
% AllDates     - 証券ポートフォリオからキャッシュフローが発生する全ての
%                日付が記載されたNUMDATES行1列のリストです。
%
% AllTF        - AllDates に記載された各日付に対応する時間係数を記載する
%                NUMDATES行1列のリストです。 TFactors に入力がない場合、
%                AllTF は、AllDates に記載されている最初の日付からの日数
%                を示すリストとなります。
%
% IndByBond    - インデックスの NUMBONDS 行 NUMDATES 列の行列です。i番目
%                の行は、i番目の債権がキャッシュフローを発生する AllDates
%                のインデックスを示すリストを出力します。ある債権が他の
%                債権よりも多くのキャッシュフローをもつ場合、この行列の
%                空白部は NaN で埋められ、要素数を揃えます。
%
% 参考 : CFAMOUNTS.


%   Author(s): J. Akao, 10-15-1998
%   Copyright 1995-2002 The MathWorks, Inc. 
