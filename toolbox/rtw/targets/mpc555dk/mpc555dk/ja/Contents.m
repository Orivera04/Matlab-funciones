% Embedded Target for Motorola MPC555
% Version 1.0.1 (R13) 20-Jun-2002
%
% Embedded Target for Motorola MPC555 は、任意の Simulink ブロック線図
% ウィンドウのシミュレーションパラメータダイアログボックスの Real-Time 
% Workshop タブからアクセスします。
%
% セットアップ
%   gettargetprefs      - ターゲット実行の手法の取得
%   settargetprefs      - ターゲット実行の手法を設定
%   edit                - ターゲット実行の手法を編集
%
% ブロックライブラリ
%   canblocks           - CAN メッセージの packing、unpacking、および
%                         監視
%   mpc555drivers       - MPC555 に対する I/O ドライバブロック
%   vector_candrivers   - ホスト CAN ドライバブロック
%
% デモ
%
%   プロセッサ・イン・ザ・ループ コ・シミュレーション
%   mpc555pil_fuelsys   - PIL コ・シミュレーションコードの生成とビルド
%
%   リアルタイム実行
%   mpc555rt_ccp        - ターゲットに対する CAN コミュニケーション 
%                         プロトコル (CCP) でリアルタイム
%   mpc555rt_io         - ターゲットに対する I/O でリアルタイム
%   mpc555rt_io_host    - CAN コミュニケーションで、ホスト上において
%                         非リアルタイム
%   mpc555rt_led        - Phytec phyCORE-555 ボードに対する LED で
%                         リアルタイム



% Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $  $Date: 2003/04/18 18:28:22 $
% Generated from Contents.m_template revision 1.10
% $Date: 2003/04/18 18:28:22 $
