close all;
path='good\';
PicName=dir(path);
PicNum=length(PicName)-2;
B = zeros(56,56,10);
for i=1:10
    A=imread([path,PicName(i+2).name]);
    A = rgb2gray(A);
    A = A(10:56,1:47,:);
    imwrite(A,['./',num2str(i),'.png']);
end