function [costVal, theta] = graDescent(train, label, alpha, maxCycls)
% �����ݶ��½������ع�ϵ��
% ���룺
%     train������ѵ����
%     label�����󣬱�ǩ
%     alpha��ѧϰ����
%     maxCycls����������
% �����
%     costVal:���ۺ���ֵ
%     theta�����������صĻع�ϵ��

% Author��huiwen
[m,n] = size(train);
theta0 = ones(n, 1);    %����������������
for i = 1:maxCycls
    

