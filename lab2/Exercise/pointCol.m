%����AlreadyThereCol,�ж�������ΪRow�������Ǵ���ָ���ĺڵ����� 
%����������ص���WhichCol�е�ֵǡ��ΪcurrentCol 
%���������������أ�����ֵthereIsOneΪ1������Ϊ0 
function [thereIsOne] = AlreadyThereCol(pointbak,Row,currentCol,WhichCol) 
%����ֵĬ��Ϊ0 
thereIsOne = 0; 
%���RowС�ڵ���0���߳���128���򷵻�0 
if Row <= 0 || Row > 128 
    thereIsOne = 0; 
else 
    %ѭ�����м�� 
    for i = 1:1:128 
        if pointbak(Row,i) == 1 
            if WhichCol(Row,i) == currentCol 
                thereIsOne = 1; 
            end 
        end 
    end 
end