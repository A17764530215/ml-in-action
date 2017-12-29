% Matlab �Դ�K���ĵ��㷨����kmedoidsʵ��
clc;
clear;
close all;
X = [randn(100,2)*0.75+ones(100,2);randn(100,2)*0.5-ones(100,2)];%���������������
[idx,C,sumd,d,midx,info] = kmedoids(X,2,'Distance','cityblock');%����K���ĵ��㷨���з���
plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',7) %���Ʒ�����һ�������
hold on
plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',7) %���Ʒ����ڶ��������
plot(C(:,1),C(:,2),'co','MarkerSize',7,'LineWidth',1.5)%���Ƶ�һ��͵ڶ������ݵ����ĵ�
legend('Cluster 1','Cluster 2','Medoids','Location','NW');
title('Cluster Assignments and Medoids');
hold off