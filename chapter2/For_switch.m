%%ͨ��for��switch ���ʵ��
a=[1,2,3;4,5,6;7,8,9];
for i=1:3 %����1,2,3
    for j=1:3 %����1,2,3
        switch (a(i,j))
            case 1
            case 2 
            case 3  
            case 4   
            case 5 
                a(i,j)=0;
            case 6
                a(i,j)=0;
            case 7
            case 8
            case 9
        end  
    end
end
a %��a�������