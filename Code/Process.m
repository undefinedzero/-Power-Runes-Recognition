function [C,Output,outimg]=Process(Input)
%C是实心九宫格，Output是C的边界
%参数经过实验调整，最好不要乱改
    AGray=min(min(Input(:,:,1),Input(:,:,2)),Input(:,:,3));
%     AGray=rgb2gray(Input);
%    imwrite(AGray,'./ppt/gray.png');
    Output=AGray.*0;
    C=Output;
    outimg = Output;
    %%
    %找出九宫格在图像中的位置
    A=imclose(AGray,ones(15,25));%去掉数字字符
%     imwrite(A,'./ppt/rough_1.png');
    A=imopen(A,ones(20,30));%保留九宫格，腐蚀杂点
%     imwrite(A,'./ppt/rough_2.png');
    B=imclose(A,ones(30,45));%粘合九宫格，变成一个大矩形
%     imwrite(B,'./ppt/rough_3.png');
    C=imbinarize(B,graythresh(B));
%     imwrite(C,'./ppt/rough_4.png');
    C=imfill(C,'hole');
%     imwrite(C,'./ppt/rough_5.png');
    C=imopen(C,ones(70,70));
%     imwrite(C,'./ppt/rough_6.png');
    C=imclearborder(C);
%     imwrite(C,'./ppt/rough_7.png');
    C=MaxConnctedArea(C);%最大联通区域一般就是九宫格粘成的大矩形
%     imwrite(C,'./ppt/rough_8.png');
    C=imdilate(C,ones(30));
%     imwrite(C,'./ppt/rough_9.png');
    
    %现在C为1的地方是九宫格的区域，找出它的外接矩形
    x1=find((sum(C')>0),1,'first');
    x2=find((sum(C')>0),1,'last');
    y1=find((sum(C)>0),1,'first');
    y2=find((sum(C)>0),1,'last');
    
    %%
    if (x2>x1)&(y2>y1)
            T=AGray(x1:x2,y1:y2);%取出九宫格区域
%             imwrite(T,'./ppt/acc_1.png');
            T=imbinarize(T,mean(T(:))+0.1);%二值化
%             imwrite(T,'./ppt/acc_2.png');
            T=imclose(T,ones(floor((x2-x1)/20),floor((y2-y1)/20)));%去掉数字字符
%             imwrite(T,'./ppt/acc_3.png');
            T=imopen(T,ones(10));%腐蚀小杂点
%             imwrite(T,'./ppt/acc_4.png');
            T=imfill(T,'hole');
%             imwrite(T,'./ppt/acc_5.png');
            T=imopen(T,ones(floor((x2-x1)/7),floor((y2-y1)/7)));%保留九宫格，腐蚀杂点
%             imwrite(T,'./ppt/acc_6.png');
            D=imclose(T,ones(floor((x2-x1)/10),floor((y2-y1)/10)));%粘合九宫格，变成一个大矩形
%             imwrite(D,'./ppt/acc_7.png');
            D=imfill(D,'hole');
%             imwrite(D,'./ppt/acc_8.png');
            D=MaxConnctedArea(D);
%             imwrite(D,'./ppt/acc_9.png');
            T=T.*D;
%             imwrite(T,'./ppt/acc_10.png');
            
            C(x1:x2,y1:y2)=T;
            outimg = AGray.*C;
%             imwrite(C,'./ppt/acc_11.png');
            T=edge(T);
            
            Output(x1:x2,y1:y2)=T;
    end
end