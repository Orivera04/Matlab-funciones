% INSTARGCF   'Type', 'CashFlow' �����̌��؂��s���T�u���[�`��
%
% ���̊֐��́A�������[�`���̍ŏ��Ɏ��s����܂��B
%
%   [CFlowAmounts, CFlowDates, Settle, Basis] = instargcf(Arglist{:})
%
% ����: 
%     Arglist{:}  �o�͂�1��1�ŏ���������������͂��܂��B
%
% �o��: 
% �o�͂́A�K������ NINST �s MOSTCFS ��̍s��ƂȂ�܂��B
%
%   CFlowAmounts - �L���b�V���t���[�z����Ȃ� NINST �s MOSTCFS ��̍s��
%                  �ł��B���̍s����\�����邻�ꂼ��̍s�́A�Ή�����1��
%                  �،��̃L���b�V���t���[�l�̃��X�g�ƂȂ��Ă��܂��B�،�
%                  �̃L���b�V���t���[���AMOSTCFS �L���b�V���t���[����
%                  ���Ȃ��ꍇ�A�s�̖����� NaN �Ńp�f�B���O����܂��B
%
%   CFlowDates   - �L���b�V���t���[���t������ NINST �s MOSTCFS ��̍s��
%                  �ł��B���̍s��̊e���͒l�́ACFlowAmounts ���̑Ή�����
%                  �L���b�V���t���[�̃V���A�����t�������Ă��܂��B
%
%   Settle       - ���ϓ�
%
%   Basis        - �����̃J�E���g��B�f�t�H���g��0 (actual/actual).
%
% �Q�l : INSTCF.


%   Author(s): J. Akao 19-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc.
