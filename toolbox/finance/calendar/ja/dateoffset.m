% DATEOFFSET   �������w�肵�����̐����������������t���v�Z
%
% ���̊֐��́A�w�肳�ꂽ�������(�����A�܂��́A�ߋ���)�w�肵�����̐�
% (����)�������炵�����t���o�͂��܂��B�ǂꂾ���̌�������������������
% �I�t�Z�b�g�l�ɂ́A�ߋ��̓��t�ɑ΂��Ă͕��̒l�A�����̓��t�ɑ΂��ẮA
% ���̒l�œ��͂��܂��B
%
% [CpnDay, CpnMonth, CpnYear] = dateoffset(RefDay , RefMonth , .....
%           RefYear ,  MonthOffset)
%
%   [CpnDay, CpnMonth, CpnYear] = dateoffset(RefDay , RefMonth , ....
%           RefYear , MonthOffset , Rule)
%
% ����: 
%   RefDay      - �w�肵������̌��̓�
%   RefMonth    - �w�肵������̌�
%   RefYear     - �w�肵������̔N
%   MonthOffset - �������A�o�͂������t���v�Z���邽�߂ɉߋ��A�܂��́A
%                 �����ɓ��������̐��𐮐��œ��͂��܂��B�ߋ��̓��t�ɑ΂�
%                 �Ă͕��̒l�A�����̓��t�ɑ΂��ẮA���̒l�œ��͂��܂��B
% 
% ����(�I�v�V����):
%   Rule       - �ߋ��A�܂��́A�����̓��t���m�肷��ۂɗp��������̃J�E
%                ���g��y�ь����K���������w�W(����)�BRule�̒l�Ɠ�����
%                �J�E���g��y�ь����K���Ƃ̑Ή��͎��̒ʂ�ł��B
%                                         
%     Rule                �����̃J�E���g��@�����K���͗L�����H
%     ----                ------------------  -----------------
%       0 (default) -->   actual/actual         Yes
%       1           -->       30/360            Yes
%       2           -->   actual/360            Yes
%       3           -->   actual/365            Yes
%       4           -->   actual/actual          No
%       5           -->       30/360             No
%       6           -->   actual/360             No
%       7           -->   actual/365             No
%
% �����K�����L��(Rule�̒l��0,1,2,3�̂����ꂩ)�ł���ꍇ�A���̖������ŏ�
% �̓��t�Ƃ��Đݒ肵�A���Y�̌����A30�A�܂��́A����������Ȃ���������
% �Ȃ��ꍇ�A�����A�܂��́A�ߋ��̑Ή����錎�̓�����28,29,30�A�܂��́A31��
% ���邩�ǂ����Ɋւ�炸�A�Ή����鏫���A�܂��́A�ߋ��̌��̎��ۂ̖�����
% �o�͂����悤�ɂȂ�܂��B
%
% �o��: 
%   CpnDay   - ����ɂ��ďo�͂��ꂽ�ߋ��A�܂��́A�����̌��̓�
%   CpnMonth - ����ɂ��ďo�͂��ꂽ�ߋ��A�܂��́A�����̌�
%   CpnYear  - ����ɂ��ďo�͂��ꂽ�ߋ��A�܂��́A�����̌��̔N
%
% �Q�l : DAYS360, DAYS365, DAYSACT, DAYSDIF, WRKDYDIF.


% Copyright 1995-2002 The MathWorks, Inc.
