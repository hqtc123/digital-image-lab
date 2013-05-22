Img=imread('duck.png');
I=rgb2gray(Img);
figure;
subplot(2,1,1);
imshow(Img);title('（a）原始图像');
subplot(2,1,2);
k=menu('请选择一个算子: ','Sobel算子','Prewitt算子','Roberts算子','Laplace算子','Canny算子');
switch k
    case 1
        I1=edge(I,'sobel'); %Sobel算子边缘检测
        imshow(I1);title('（b）Sobel算子');
    case 2
        I1=edge(I,'prewitt'); %Prewitt算子边缘检测
        imshow(I2);title('（c）Prewitt算子'); 
    case 3
        I3=edge(I,'roberts'); %Roberts算子边缘检测

        imshow(I3);title('（d）Roberts算子'); 
    case 4
        I4=edge(I,'log'); %Laplace算子边缘检测
        imshow(I4);title('（e）Laplace算子'); 
    case 5
        I5=edge(I,'canny'); %Canny算子边缘检测
        imshow(I5);title('（f）Canny算子');
end

