%函数AlreadyThereRow,判断离列数为Col的列中是存在指定的黑点像素 
%并且这个像素的在WhichRow中的值恰好为currentRow 
%若存在这样的像素，返回值thereIsOne为1，否则为0 
function [thereIsOne] = AlreadyThereRow(pointbak,Col,currentRow,WhichRow) 
%返回值的默认为应该为0 
thereIsOne = 0; 
%如果Col小于等于0或者超出上界，直接返回0 
if Col <= 0 || Col > 128 
    thereIsOne = 0; 
else 
    %循环进行检测 
    for i = 1:1:128 
        if pointbak(i,Col) == 1 
            if WhichRow(i,Col) == currentRow 
               thereIsOne = 1; 
            end 
        end 
    end 
end 