function [img]=MaxConnctedArea(I)  
%�����ҳ�һ����ֵͼ�������������ͨ����

imLabel = bwlabel(I);                %�Ը���ͨ����б��  
stats = regionprops(imLabel,'Area');    %�����ͨ��Ĵ�С  
area = cat(1,stats.Area);  
index = find(area == max(area));        %�������ͨ�������  
img = ismember(imLabel,index);          %��ȡ�����ͨ��ͼ��  

end