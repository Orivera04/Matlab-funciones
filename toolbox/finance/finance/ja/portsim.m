% PORTSIM   ���ւ̂��鎑�Y���v�̃����_���V�~�����[�V����
%
% ���̊֐��́ANUMOBS �̘A������ϑ�(�l)��Ԃɑ΂��āANASSETS �̎��Y
% ��������炳�����v���V�~�����[�V�������܂��B���̊֐�����̏o�͂́A
% ���̈ړ���(drift) �ƃ{���e�B���e�B Brownian �ߒ��̑����Ƃ��ăV�~��
% ���[�g����܂��B
%
% RetSeries = .....
%    portsim(ExpReturn, ExpCovariance, NumObs, RetIntervals, NumSim)
%
% ����:
%    ExpReturn     : �e���Y�̊���(����)���v������1 �s NASSETS ��̃x�N�g
%                    ���ł��B
%    ExpCovariance : ���Y-���Y�����U�� NASSETS �s NASSETS ��̍s��ł��B
%                    ���v�̕W���΍��́A���̒ʂ�ł��B
%                    ExpSigma = sqrt(diag(ExpCovariance))�ƂȂ�܂��B
%    NumObs        : ���v���n��ɂ�����A������ϑ��l�̐��BNumObs ����s
%                    ��[]�Ƃ��ē��͂����ƁARetIntervals �̒������g�p��
%                    ��܂��B
%    RetIntervals  : �ϑ��l�Ԃ̎��ԊԊu�������X�J���l�A�܂��́ANUMOBS �s
%                    1��̃x�N�g���ł��BRetIntervals �̎w�肪�Ȃ��ꍇ�A
%                    �S�Ԋu��1�̒����ł���Ɖ��肳��܂��B
%    NumSim        : NUMOBS �̊ϑ��l���ɌʂɎ��s�����V�~�����[�V��
%                    ���̉񐔂ł��B�f�t�H���g��1�ł��B
%
% �o�́F
%    RetSeries     : �������v�ϑ��l�� NUMOBS x NASSETS x NUMSIM �z��ł��B
%                    ���� DT �̋�Ԃɑ΂�����v�́A���̎��ŗ^������
%                    ���B ExpReturn *DT + ExpSigma*sqrt(DT)*randn �A����
%                    �ŁArandn �́A�W�����K�����̔������Ӗ����Ă��܂��B
%
% PortWts �Ƀ��X�g�A�b�v����Ă���|�[�g�t�H���I���瓾������v�́A��
% �̎��ɂ���ė^�����܂��B
% 
%     PortReturn = PortWts * RetSeries(:,:,1)',
% 
% �����ŁAPortWts �͊e�s���|�[�g�t�H���I�̎��Y�z�����܂�ł���s��ł��B
% PortReturn �̊e�s�́A PortWts �Ɏw�肳���|�[�g�t�H���I��1�ɑ�����
% �܂��B�܂��e��́ARetSeries �̊ϑ��l��1�ɑΉ����Ă��܂��B�|�[�g�t�H
% ���I�̐ݒ�ƍœK���ɂ��ẮA�֐� PORTOPT �� PORTSTATS ���Q�Ƃ��Ă���
% �����B
% 
% �Q�l : PORTOPT, PORTSTATS, EWSTATS, RET2TICK, RANDN.


%    Author(s): J. Akao 03/24/98
%    Copyright 1995-2002 The MathWorks, Inc.  
