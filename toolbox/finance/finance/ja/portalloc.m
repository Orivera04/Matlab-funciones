% PORTALLOC   �L���|�[�g�t�H���I�ɑ΂��鎑�Y�z�����o��
%
% [RiskyRisk, RiskyReturn, RiskyWts, RiskyFraction, OverallRisk, ....
%             OverallReturn] = portalloc(PortRisk, PortReturn, ...
%                      PortWts,RisklessRate, BorrowRate, RiskAversion)
% �́A���[�U�ݒ�̗L���|�[�g�t�H���I�̕W���΍��A���Ҏ��v�A���d�l��
% �g���āA�œK���X�N�|�[�g�t�H���I���o�͂��܂��B���S���q���A���B�����A
% �����Ƃ̃��X�N����̒��x���^������ƁA���̊֐��́A�œK�����|�[�g
% �t�H���I�A���X�N�|�[�g�t�H���I�ƃ��X�N�t���[�|�[�g�t�H���I�Ԃ̓���
% �œK�z�����v�Z���܂��B
%
% ����:
% PortRisk �́A�e�|�[�g�t�H���I�̕��U������ NPORTS �s1��x�N�g���ł��B
% 
% PortReturn �́A�e�|�[�g�t�H���I�̊��Ҏ��v������ NPORTS �s1��x�N�g��
% �ł��B
% 
% PortWts �́A�e���Y�ɔz���������d�l�� NPORTS �s NASSETS ��̍s��ł��B
% �s��̊e�s�́A���ꂼ��ʂ̃|�[�g�t�H���I��\���Ă��܂��B�|�[�g�t�H���I
% �̉��d�l�̑��a ��1�ł��B
%
% RisklessRate �́A10�i���\�L�œ��͂��ꂽ���S���q���ł��B
%
% BorrowRate �́A10�i���\�L�œ��͂��ꂽ���B�����ł��B���B��]�܂��A�܂��A
% ���B���I�v�V�����ł��Ȃ��P�[�X�ł́A���̈����̒l�̓f�t�H���g�� NaN ��
% �ݒ肵�Ă��������B
%
% RiskAversion �́A�����Ƃ̃��X�N����̒��x�������W���ł��B���̒l������
% ��΍����قǁA�����Ƃ́A��胊�X�N������u������悤�ɂȂ�܂��B���X�N
% ����W���̒ʏ�͈̔͂́A2.0����4.0 �ƂȂ��Ă��܂��B�Ȃ��A�f�t�H���g��
% �l��3�ł��B
%
% �o��:
% RiskyRisk �́A�œK���X�N�|�[�g�t�H���I�̕��U�ł��B
%
% RiskyReturn �́A�œK���X�N�|�[�g�t�H���I�̊��Ҏ��v�ł��B
%
% RiskyWts �́A�œK���X�N�|�[�g�t�H���I�ɑ΂��Ĕz���������d�l��1 �s
% NASSETS ��̃x�N�g���ł��B�|�[�g�t�H���I�̉��d�l�̑��a��1�ł��B
% 
% RiskyFraction �́A���X�N�|�[�g�t�H���I�ɔz������銮�S�ȃ|�[�g�t�H���I
% �̒[��(fraction)�ł��B
%
% OverallRisk �́A�œK����(overall)�|�[�g�t�H���I�̕��U�ł��B
%
% OverallReturn �́A�œK�����|�[�g�t�H���I�̊��Ҏ��v���ł��B
%
% ���ӁF
% �o�͈����Ȃ��ŁA���̊֐����Ăяo�����ꍇ�A�ՊE�_��\������O���t���\��
% ����܂��B
%
% �Q�l : PORTSTATS, EWSTATS, FRONTCON.
%
% �Q�l����: Bodie, Kane, and Marcus, Investments, Chapters 6 and 7. 


%  Author(s): M. Reyes-Kattar, 02/15/98
%  Copyright 1995-2002 The MathWorks, Inc.  
