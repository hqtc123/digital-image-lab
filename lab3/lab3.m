Img=imread('duck.png');
I=rgb2gray(Img);
figure;
subplot(2,1,1);
imshow(Img);title('��a��ԭʼͼ��');
subplot(2,1,2);
k=menu('��ѡ��һ������: ','Sobel����','Prewitt����','Roberts����','Laplace����','Canny����');
switch k
    case 1
        I1=edge(I,'sobel'); %Sobel���ӱ�Ե���
        imshow(I1);title('��b��Sobel����');
    case 2
        I1=edge(I,'prewitt'); %Prewitt���ӱ�Ե���
        imshow(I2);title('��c��Prewitt����'); 
    case 3
        I3=edge(I,'roberts'); %Roberts���ӱ�Ե���

        imshow(I3);title('��d��Roberts����'); 
    case 4
        I4=edge(I,'log'); %Laplace���ӱ�Ե���
        imshow(I4);title('��e��Laplace����'); 
    case 5
        I5=edge(I,'canny'); %Canny���ӱ�Ե���
        imshow(I5);title('��f��Canny����');
end

