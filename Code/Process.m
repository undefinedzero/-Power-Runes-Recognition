function [C,Output,outimg]=Process(Input)
%C��ʵ�ľŹ���Output��C�ı߽�
%��������ʵ���������ò�Ҫ�Ҹ�
    AGray=min(min(Input(:,:,1),Input(:,:,2)),Input(:,:,3));
%     AGray=rgb2gray(Input);
%    imwrite(AGray,'./ppt/gray.png');
    Output=AGray.*0;
    C=Output;
    outimg = Output;
    %%
    %�ҳ��Ź�����ͼ���е�λ��
    A=imclose(AGray,ones(15,25));%ȥ�������ַ�
%     imwrite(A,'./ppt/rough_1.png');
    A=imopen(A,ones(20,30));%�����Ź��񣬸�ʴ�ӵ�
%     imwrite(A,'./ppt/rough_2.png');
    B=imclose(A,ones(30,45));%ճ�ϾŹ��񣬱��һ�������
%     imwrite(B,'./ppt/rough_3.png');
    C=imbinarize(B,graythresh(B));
%     imwrite(C,'./ppt/rough_4.png');
    C=imfill(C,'hole');
%     imwrite(C,'./ppt/rough_5.png');
    C=imopen(C,ones(70,70));
%     imwrite(C,'./ppt/rough_6.png');
    C=imclearborder(C);
%     imwrite(C,'./ppt/rough_7.png');
    C=MaxConnctedArea(C);%�����ͨ����һ����ǾŹ���ճ�ɵĴ����
%     imwrite(C,'./ppt/rough_8.png');
    C=imdilate(C,ones(30));
%     imwrite(C,'./ppt/rough_9.png');
    
    %����CΪ1�ĵط��ǾŹ���������ҳ�������Ӿ���
    x1=find((sum(C')>0),1,'first');
    x2=find((sum(C')>0),1,'last');
    y1=find((sum(C)>0),1,'first');
    y2=find((sum(C)>0),1,'last');
    
    %%
    if (x2>x1)&(y2>y1)
            T=AGray(x1:x2,y1:y2);%ȡ���Ź�������
%             imwrite(T,'./ppt/acc_1.png');
            T=imbinarize(T,mean(T(:))+0.1);%��ֵ��
%             imwrite(T,'./ppt/acc_2.png');
            T=imclose(T,ones(floor((x2-x1)/20),floor((y2-y1)/20)));%ȥ�������ַ�
%             imwrite(T,'./ppt/acc_3.png');
            T=imopen(T,ones(10));%��ʴС�ӵ�
%             imwrite(T,'./ppt/acc_4.png');
            T=imfill(T,'hole');
%             imwrite(T,'./ppt/acc_5.png');
            T=imopen(T,ones(floor((x2-x1)/7),floor((y2-y1)/7)));%�����Ź��񣬸�ʴ�ӵ�
%             imwrite(T,'./ppt/acc_6.png');
            D=imclose(T,ones(floor((x2-x1)/10),floor((y2-y1)/10)));%ճ�ϾŹ��񣬱��һ�������
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