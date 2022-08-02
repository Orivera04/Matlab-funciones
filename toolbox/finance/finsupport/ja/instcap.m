% INSTCAP   'Cap'タイプ 商品の作成関数
%
% データ配列から新しい商品変数を生成するには、つぎのように設定します。
%   ISet = instcap(Strike, Settle, Maturity, Reset, Basis, Principal)
%
% 'Cap' 商品を商品変数に追加するには、つぎのように設定します。
%   ISet = instcap(ISet, Strike, Settle, Maturity, Reset, Basis, ....
%           Principal)
%
% 'Cap' 商品に適用されるフィールドメタデータを表示するには、つぎのように
% 設定します。
%   [FieldList, ClassList, TypeString] = instcap;
%
% 入力: 
% データ引数には、NINST 行1列のベクトル、スカラ、または、空のいずれかを
% 入力できます。ベクトル内の指定のない入力については、NaN 値が入力されま
% す。商品の生成にはたった1つのデータ引数が必要とされ、他のデータ引数は
% 削除、または、空行列 []として省略されます。全ての入力は、入力データの
% クラスに応じて、FINARGPARSE によって解釈されます。データのクラスを参照
% するには、"[FieldList, ClassList] = instcap" とタイプしてください。
% なお、日付については、シリアル日付番号、または、日付文字列で入力して
% ください。
%
%   Strike     - キャップが行使される利率。十進法で表記されます。
%   Settle     - キャップの決済日を示す日付文字列、または、シリアル日付
%                番号。
%   Maturity   - キャップの満期日を示す日付文字列、または、シリアル日付
%                番号。
%   Reset      - 年に何回満期が訪れるか、その頻度を示すスカラ値。
%   Basis      - 入力されたフォワード利率ツリーの分析に用いられる日付
%                カウント基準を示すスカラ値。
%   Principal  - 想定元本(名目元本)。
%
% 出力:
%   ISet       - 商品の集合からなる変数。商品は、タイプ毎に分類され、そ
%                のそれぞれのタイプについて、互いに異なるデータフィール
%                ドを設定することができます。記憶されたデータフィールド
%                は、商品のそれぞれに対応する行ベクトル、または、文字列
%                となっています。変数 ISet に関する詳細については、
%                "help instget" とタイプしてください。
%   FieldList  - この商品タイプに適用されるデータフィールドの名称をリス
%                ト表示する文字列で構成される NFIELDS 行1列のセル配列。
%   ClassList  - 各フィールドのデータクラスを記載する文字列からなる 
%                NF-IELDS行1列のセル配列、ここに記載されるデータクラスに
%                よって、引数の解釈法が決定されます。入力可能な引数は、
%                'dble', 'date',  'char' です。 
%   TypeString - 追加される商品のタイプを指定する文字列です。
%                 TypeString = 'Cap'
%
% 参考 : INSTBOND, INSTFLOOR, INSTSWAP, INSTADDFIELD, INSTDISP, 
%        INTENVPRICE, HJMPRICE.


%   Author(s): M. Reyes-Kattar 03/10/99
%   Copyright 1995-2002 The MathWorks, Inc. 
