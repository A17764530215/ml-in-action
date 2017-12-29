clc
clear
close all
%% ��������
rng default;  % For reproducibility
mu1 = [1 2];
sigma1 = [3 .2; .2 2];
mu2 = [-2 -4];
sigma2 = [2 0; 0 1];
X = [mvnrnd(mu1,sigma1,200); mvnrnd(mu2,sigma2,100)];%2����˹����������
n = size(X,1);

%% dbscan����
label = dbscan(X,2);