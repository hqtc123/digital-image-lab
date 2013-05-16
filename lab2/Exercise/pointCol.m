%函数AlreadyThereCol,判断离行数为Row的行中是存在指定的黑点像素 
%并且这个像素的在WhichCol中的值恰好为currentCol 
%若存在这样的像素，返回值thereIsOne为1，否则为0 
function [thereIsOne] = AlreadyThereCol(pointbak,Row,currentCol,WhichCol) 
%返回值默认为0 
thereIsOne = 0; 
%如果Row小于等于0或者超出128，则返回0 
if Row <= 0 || Row > 128 
    thereIsOne = 0; 
else 
    %循环进行检测 
    for i = 1:1:128 
        if pointbak(Row,i) == 1 
            if WhichCol(Row,i) == currentCol 
                thereIsOne = 1; 
            end 
        end 
    end 
end