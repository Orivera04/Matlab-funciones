% FRONTCON   �|�[�g�t�H���I����𔺂����ϕ��U�L���t�����e�B�A���o��
%
% ���[�U���w�肵�����Y����A�����U�A���v���畽�ϕ��U�L���t�����e�B�A��
% �o�͂��܂��BNASSETS �̐������̃��X�N���Y�̏W�����^������ƁA���Ҏ��v
% �̏��^�̉��l�ɑ΂��āA���X�N���ŏ�������悤�ȏd�ݕt�����s�������Y����
% �̃|�[�g�t�H���I���v�Z���܂��B�|�[�g�t�H���I�̃��X�N�́A���Y�̉��d�l�A
% �܂��́A���Y�̉��d�l�̏W���ɉۂ���ꂽ����ɏ]���čŏ�������܂��B
%
% [PortRisk, PortReturn, PortWts] = frontcon(ExpReturn, .....
%      ExpCovariance, NumPorts, PortReturn, AssetBounds, ....
%      Groups, GroupBounds)
%
% ����: 
% ExpReturn �́A�e���Y�̐���(����)���v��1�sNASSETS��̃x�N�g���ł��B
%     
% ExpCovariance �́A���Y���v�̋����U������NASSETS�sNASSETS��̍s��ł��B
%    
% NumPorts �́A�L���|�[�g�t�H���I�̐� NPORTS �ł��BNumPorts �ɋ�s�� [] 
% �����͂��ꂽ��A�����w�肪�Ȃ���Ȃ������Ƃ��̃f�t�H���g�l��10�ł��B
% PortReturn ���A���͂��ꂽ�ꍇ�ANumPorts �ɂ́A��s�� [] ����͂���
% ���������B
%
% PortReturn �́A�t�����e�B�A��̑ΏۂƂȂ���v�l���܂ޒ��� NPORTS ��
% �x�N�g���ł��B���[�U�́A2�̕��@�Ń|�[�g�t�H���I�̎��v�l���w�肷�邱��
% ���ł��܂��BPortReturn �ɁA������͂��Ȃ�������A���͂���ɂ����ꍇ�A
% �g�p�\�ȍŏ��l�ƍő�l�̊ԂŁANumPorts �̓��Ԋu�̒l���o�͂��܂��B
%
% AssetBounds �́A�|�[�g�t�H���I���̊e���Y�Ɋ��蓖�Ă�ꂽ���d�l�̉���
% �y�я�����܂�2 �s NASSETS ��̍s��ł��B�f�t�H���g�̉����͑S�ă[��
% (�J������Ȃ�)�ŁA�f�t�H���g�̏���́A�S��1(�����Ȃ鎑�Y�����S�ȃ|�[�g
% �t�H���I����Ȃ�)�ł��B
%    
% Groups �́A���Y�W���A�܂��́A���Y�N���X���w�肷��NGROUPS�sNASSETS���
% �s��ł��B���̍s��̊e�s�́A�W�����w�肵�Ă��܂��BGroups(i,j)= 1 ��
% �ꍇ�Aj �Ԗڂ̎��Y�́Ai �Ԗڂ̏W���ɑ����Ă��܂��B Groups(i,j)= 0 ��
% �ꍇ�Aj �Ԗڂ̎��Y�́Ai �Ԗڂ̏W���ɑ����Ă��܂���B
%    
% GroupBounds �́A�e�W���ɂ��āA���Y�W���̑S���Y�̑����d�l�̉����A���
% ���w�肷��NGROUPS�s2��̍s��ł��B�f�t�H���g�̉����l�͑S�ă[���A����l��
% �S��1�ƂȂ��Ă��܂��B
%
% �o��: 
% PortRisk �́A�e�|�[�g�t�H���I�̎��v�̕W���΍�������NPORTS�s1��̃x�N
% �g���ł��B
%    
% PortReturn �́A�e�|�[�g�t�H���I�̊��Ҏ��v������NPORTS�s1��̃x�N�g��
% �ł��B
% PortWts �́A�e���Y�ɔz�����ꂽ���d�l��NPORTS�sNASSETS��̍s��ł��B
% ���̍s��̂��ꂼ��̍s�́A�ʁX�̃|�[�g�t�H���I��\���Ă��܂��B�|�[�g
% �t�H���I���̑S���d�l�̑��a��1�ł��B         
%
% ���ӁF 
%   �֐����o�͈����Ȃ��ŌĂяo���ꂽ�ꍇ�A�L���t�����e�B�A�̃v���b�g��
%   �o�͂���܂��B
%
% ���Y���v�͋��ʂ��Đ���Ȏ��v�ŁAExpReturn �̊��ҕ��ώ��v�AExpCovariance
% �̎��v�����U�𔺂��Ɖ��肳��܂��B1 �s NASSET ��̉��d�l PortWts �𔺂�
% �|�[�g�t�H���I�̕��U�́A���̎��ɂ���Čv�Z����܂��B
% 
%    PortVar = PortWts*ExpCovariance*PortWts'
% 
% �����Ń|�[�g�t�H���I�̊��Ҏ��v�́APortReturn = dot(ExpReturn, PortWts)
% �ƂȂ�܂��B
%
% �Q�l : PORTSTATS, PORTOPT, EWSTATS.


%   Author(s): D. Eiler, M. Reyes-Kattar, 01/30/98
%   Copyright 1995-2002 The MathWorks, Inc. 
