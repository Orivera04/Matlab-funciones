% BUSDATE   ���܂��͑O�̉c�Ɠ�
% 
% BD = BUSDATE(D,DIREC,HOL,WEEKEND) 
%
% ����:
%
%   D       - ��̉c�Ɠ�
%
% ����(�I�v�V����):
%
%   DIREC   - ��(DIREC = 1, �f�t�H���g)�̉c�Ɠ����O(DIREC = -1)��
%             �c�Ɠ������w�肵�܂��B
%
%   HOL     - �x�Ɠ��̃x�N�g���BHOL �̎w�肪�Ȃ��ꍇ�́A���[�`�� 
%             HOLIDAYS �ɂ���Č��肳��܂��B
%             �����_�ł́AHOLIDAYS ��NY�̋x�����T�|�[�g���܂��B
%
%   WEEKEND - �T����1�Ƃ���0��1���܂ޒ���7�̃x�N�g���ł��B
%             ���̃x�N�g���̍ŏ��̗v�f�́A���j���ɑΉ����܂��B
%             ���̂��߁A�y�j���Ɠ��j�����T���Ƃ���ƁA
%             WEEKDAY = [1 0 0 0 0 0 1] �ƂȂ�܂��B�f�t�H���g�ł́A
%             �y�j���Ɠ��j�����T���ɂȂ�܂��B
%
% �o��:
%
%  BD       - HOL �ɂ���āA���A�܂��͑O�̉c�Ɠ��ɂȂ�܂��B
%  
% ���Ƃ��΁Abd = busdate('3-jul-1997',1)�́A July 7, 1997 �ɑΉ�����
% �V���A�����t�ԍ� bd = 729578 ���o�͂��܂��B  
%
% �Q�l : HOLIDAYS, ISBUSDAY.


%   Author(s): C.F. Garvin, 10-31-95
%  Copyright (c) 1995-1999 The MathWorks, Inc. All Rights Reserved.
