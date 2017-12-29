function class = dbscan(data, Minpts, varargin)
% ����dbscan�㷨������x����
% ����:
%     data: m*n, m objects and n features;
%     Eps: radius;
%     Minpts: values used for define core points
% ���:   
%     cluter: cluster labels for non-noiose data points
  
% �������Eps��MinPts  
MinPts = Minpts;  
if nargin > 2
    Eps = varargin{1};
else
    % epsilon�������ڼ�������İ뾶
    Eps = epsilon(data, Minpts);
end

[m,n] = size(data);%�õ����ݵĴ�С  
x = [(1:m)' data];  
[m,n] = size(x);%���¼������ݼ��Ĵ�С  
types = zeros(1,m);%�������ֺ��ĵ�1���߽��0��������-1  
dealed = zeros(m,1);%�����жϸõ��Ƿ����,0��ʾδ�����  
dis = calDistance(x(:,2:n));  
number = 1;%���ڱ����  
  
% ��ÿһ������д���  
for i = 1:m  
    %�ҵ�δ����ĵ�  
    if dealed(i) == 0  
        xTemp = x(i,:);  
        D = dis(i,:);%ȡ�õ�i���㵽�������е�ľ���  
        ind = find(D<=Eps);%�ҵ��뾶Eps�ڵ����е� 
        % ���ֵ������  
        %�߽��  
        if length(ind) > 1 && length(ind) < MinPts+1  
            types(i) = 0;  
            class(i) = 0;  
        end  
        %������  
        if length(ind) == 1  %���Լ��ľ���
            types(i) = -1;  
            class(i) = -1;  
            dealed(i) = 1;  
        end  
        %���ĵ�(�˴��ǹؼ�����)  
        if length(ind) >= MinPts+1  
            types(xTemp(1,1)) = 1;  
            class(ind) = number;  
              
            % �жϺ��ĵ��Ƿ��ܶȿɴ�  
            while ~isempty(ind)  
                yTemp = x(ind(1),:);  
                dealed(ind(1)) = 1;  
                ind(1) = [];  
                D = dis(yTemp(1,1),:);%�ҵ���ind(1)֮��ľ���  
                ind_1 = find(D<=Eps);  
                  
                if length(ind_1)>1%�����������  
                    class(ind_1) = number;  
                    if length(ind_1) >= MinPts+1  
                        types(yTemp(1,1)) = 1;  
                    else  
                        types(yTemp(1,1)) = 0;  
                    end  
                      
                    for j=1:length(ind_1)  
                       if dealed(ind_1(j)) == 0  
                          dealed(ind_1(j)) = 1;  
                          ind=[ind ind_1(j)];     
                          class(ind_1(j))=number;  
                       end                      
                   end  
                end  
            end  
            number = number + 1;  
        end  
    end  
end  
  
% ���������δ����ĵ�Ϊ������  
ind_2 = find(class==0);  
class(ind_2) = -1;  
types(ind_2) = -1;  
  
% �������յľ���ͼ  
% ԭʼ���ͼ
figure('Position',[20 20 500 200]);
subplot(121);
scatter(data(1:200,1),data(1:200,2),15,'ro','filled');
hold on
scatter(data(201:end,1),data(201:end,2),15,'bo','filled')
title('��ʵ�ľ�����');

subplot(122);
hold on
for i = 1:m  
    if class(i) == -1  
        plot(data(i,1),data(i,2),'.r');  
    elseif class(i) == 1  
        if types(i) == 1  
            plot(data(i,1),data(i,2),'+b');  
        else  
            plot(data(i,1),data(i,2),'.b');  
        end  
    elseif class(i) == 2  
        if types(i) == 1  
            plot(data(i,1),data(i,2),'+g');  
        else  
            plot(data(i,1),data(i,2),'.g');  
        end  
    elseif class(i) == 3  
        if types(i) == 1  
            plot(data(i,1),data(i,2),'+c');  
        else  
            plot(data(i,1),data(i,2),'.c');  
        end  
    else  
        if types(i) == 1  
            plot(data(i,1),data(i,2),'+k');  
        else  
            plot(data(i,1),data(i,2),'.k');  
        end  
    end  
end  
hold off  
title(sprintf('DBSCAN�㷨(MinPts=%d)', Minpts));

