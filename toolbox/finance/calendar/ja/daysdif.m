% DAYSDIF   �C�ӂ̓����J�E���g��Ɋ�Â������t�Ԃ̓���
%
% D = DAYSDIF(D1,D2,BASIS)�́A�ݒ肵�����t�J�E���g���p���āAD1 �� 
% D2�Ԃ̓������o�͂��܂��B���t�́A�V���A�����t�ԍ��A�܂��́A���t�������
% ���͂��܂��B
% 
% BASIS �́A���t�J�E���g��ŁA0 = ���ۂ̓��t/���ۂ̓��t(�f�t�H���g)�A
% 1 = 30/360�A2 = ���ۂ̓��t/360�A3 = ���ۂ̓��t/365 �̂����ꂩ��ݒ�
% ���܂��B
%              (NEW) Basis = 4 - 30/360 (PSA����) 
%              (NEW) Basis = 5 - 30/360 (ISDA����)
%              (NEW) Basis = 6 - 30/360 (���[���b�p�^)
%              (NEW) Basis = 7 - act/365 (���{�^)
%
% ���̊֐��́A�����i����Ɨ����̊֐��̕⏕�֐��ŁA�R�[�h��ǂ݈Ղ����A
% if �X�e�[�g�����g�̒��̗]���ȃR�[������菜�����Ƃ�ړI�Ƃ�����̂ł��B


%       Author(s): C.F. Garvin, 4-07-95, Bob Winata 02/02/02
%       Copyright (c) 1995-2002 The MathWorks, Inc. All Rights Reserved.
