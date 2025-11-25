function ordered_list_plusoverlays(number,CellShapeData,wish_list,linkagemat,idx)
%load('Z:\Shared240\Archive\Sam_Jefferyes\Microscope_data\TemporalAnalysis\Turns\NecessaryData\New_control_frame.mat');
%load('Z:\Shared240\Archive\Sam_Jefferyes\Microscope_data\BAM_AP_features\CorrectedBigRPEsetAnalysis_37818edit\APclusterOutput.mat')
%load('Z:\Shared240\Archive\Sam_Jefferyes\Microscope_data\BAM_AP_features\CorrectedBigRPEsetAnalysis_37818edit\wish_list.mat')
%load('Z:\Shared240\Archive\Sam_Jefferyes\Microscope_data\BAM_AP_features\CorrectedBigRPEsetAnalysis_37818edit\linkagemat.mat')
%load('Z:\Shared240\Archive\Sam_Jefferyes\Microscope_data\TemporalAnalysis\Turns\NecessaryData\refinedSCORE.mat')
for i=1:1077
    NewCellArray{i}=CellShapeData.point(i).coords_comp;
end
    SCORE=CellShapeData.point.SCORE;
    N=length(CellShapeData.point);
%else
    for i=1:N
       SCORE(i,:)= CellShapeData.point(i).SCORE;
    end
% colour_idx(colour_idx==5)=4;
% colour_idx(colour_idx==6)=4;
if number==4
    colour=[1 0 0; 0 0.75 0.75; 0.75 0.75 0; 0 0 1];
elseif number==6
    colour=[1 0 0; 0 0.75 0.75; 0.75 0.75 0; 0 0 1; 0 0.5 0; 0.75 0 0.75];
else
    %     colour=hsv(number*6/5);
    %     colour=colour(1:number,:);
    %     %colour=flipud(colour);
    %     colour_norm=colour*colour';
    %     colour_norm2=repmat(sqrt(diag(colour_norm)),1,3);
    %     colour=0.75*colour./(colour_norm2);
    colour=jet(number);
    colour=flipud(colour);
    colour=colour.*repmat((1-0.25*colour(:,2)),1,3);
end

exem_list=sort(wish_list);
figure
dendrogram(linkagemat,0);
figure
[~,T]=dendrogram(linkagemat,number);
close

for i=1:68
T2(i)=T(exem_list==wish_list(i));
end

d=diff([0 T2]);
clust_order=T2(logical(d));
%subplot(2,number,1:number)
figure
for i=1:number
    clust_idx=clust_order(i);
    exems=wish_list(T2==clust_idx);
    points=ismember(idx,exems);
    plot(SCORE(points,1),SCORE(points,2),'.','Color',colour(i,:))
    hold on
end
axis tight
axis equal
grid on


L=length(wish_list);

b=floor(sqrt(L));
a=ceil(L/b);

figure
h = [];
t = 1;
A = 0.9/a;
B=0.9/b;
for i=1:b
    y = (b-i)/b;
    for j=1:a
        x = (j-1)/a;
        h(t) = axes('units','norm','pos',[x y A B]);
        t = t+1;
    end
end

c=1;
for i=1:number
%    clust_num=clust_order(i);
    clust_idx=clust_order(i);
    exems=wish_list(T2==clust_idx);
    for j=1:length(exems)
        plot(real(NewCellArray{exems(j)}),imag(NewCellArray{exems(j)}),'color',colour(i,:),'LineWidth',2,'parent',h(c))
        axis(h(c), 'equal')
        axis(h(c),[-0.4 0.4 -0.4 0.4])
        axis(h(c), 'xy','off')
        c=c+1;
    end
    
end
while c<=a*b
    delete(h(c))
    c=c+1;
end


M=max(SCORE(:,2));
m=min(SCORE(:,2));
scale_con=(M-m)/sqrt(L);
ploting=false;
n=3;
temp_count=n-1;
figure
for i=1:number
%    clust_num=clust_order(i);
    clust_idx=clust_order(i);
    exems=wish_list(T2==clust_idx);
    for j=1:length(exems)
        %if ploting
        plot(n*scale_con*real(NewCellArray{exems(j)})+SCORE(exems(j),1),n*scale_con*imag(NewCellArray{exems(j)})+SCORE(exems(j),2),'color',colour(i,:),'LineWidth',2)
        hold on
       %     ploting=false;
        %    temp_count=0;
        %else
        %    ploting=temp_count==n-1;
        %    temp_count=temp_count+1;
       % end
        
    end
    
end
xlabel('diffusion coordinate 1')
ylabel('diffusion coordinate 2')
axis tight
axis equal
grid on
    fPath=fullfile('E:\LauraCooper\dataset-processinG\dataset-processing-master\SSE_datainput\Analysis_NoDevices\Figures', 'plotted_exemplars_12_dc1_2');
    saveas(gcf, fPath, 'fig');
    saveas(gcf, fPath, 'epsc');
M=max(SCORE(:,4));
m=min(SCORE(:,4));
scale_con=(M-m)/sqrt(L);
figure
for i=1:number
%    clust_num=clust_order(i);
    clust_idx=clust_order(i);
    exems=wish_list(T2==clust_idx);
    for j=1:length(exems)
        %if ploting
        plot(n*scale_con*real(NewCellArray{exems(j)})+SCORE(exems(j),3),n*scale_con*imag(NewCellArray{exems(j)})+SCORE(exems(j),4),'color',colour(i,:),'LineWidth',2)
        hold on
       %     ploting=false;
        %    temp_count=0;
        %else
        %    ploting=temp_count==n-1;
        %    temp_count=temp_count+1;
       % end
        
    end
    
end
xlabel('diffusion coordinate 3')
ylabel('diffusion coordinate 4')
axis tight
axis equal
grid on
    fPath=fullfile('E:\LauraCooper\dataset-processinG\dataset-processing-master\SSE_datainput\Analysis_NoDevices\Figures', 'plotted_exemplars_12_dc3_4');
    saveas(gcf, fPath, 'fig');
    saveas(gcf, fPath, 'epsc');

end

