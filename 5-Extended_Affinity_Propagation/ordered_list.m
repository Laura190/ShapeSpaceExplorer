function ordered_list(number,CellShapeData,inputFolder,APe_output_foldername)
%ORDERED_LIST generates a number of figures bringing together BAM DM and
%APe. APe is a hierarchical clustering extension to Affinity Propagation
%using Wishart Seriation, this should have been executed using
%AP_Seriation_analysis_finaledit prior to running this code. 

%number is the number of clusters you wish to view in your generated images,
%if you haven't yet decided you can enter 0 to display the just the
%dendrogram to aid your decision. 

%CellShapeData should be the output of BAM DM through the
%ShapeManifoldEmbedding code

%savedestination should be the same as for AP_Seriation_analysis_finaledit


load(fullfile(inputFolder, '/APclusterOutput.mat'));
load(fullfile(inputFolder, '/wish_list.mat'));
load(fullfile(inputFolder, '/linkagemat.mat'));
figPath=fullfile(inputFolder, 'Figures');
if ~exist(figPath,'dir'),mkdir(figPath);end

N=length(CellShapeData.point);

if isfield(CellShapeData.set,'SCORE')
    SCORE=CellShapeData.set.SCORE;
else
    for i=1:N
       SCORE(i,:)= CellShapeData.point(i).SCORE;
    end
end



for i=1:N
    NewCellArray{i}=CellShapeData.point(i).coords_comp;
end


colour=jet(number);
colour=flipud(colour);
colour=colour.*repmat((1-0.25*colour(:,2)),1,3);

n_exems=length(wish_list);
exem_list=sort(wish_list);


if number==0
    figure
    dendrogram(linkagemat,number);
    fPath=fullfile(figPath, '5_Dendrogram_of_Shapes');
    if ~isempty(APe_output_foldername)
        saveas(gcf, fPath, 'fig');
        saveas(gcf, fPath, 'epsc');
    end
    return
end
figure('visible','off')
[~,T]=dendrogram(linkagemat,number);
if max(T(:))<number
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(2);
    errordlg(msg, 'Error', mode);
    return
end
    
    
for i=1:n_exems
T2(i)=T(exem_list==wish_list(i));
end

d=diff([0 T2]);
clust_order=T2(logical(d));

mk = getMarkerSize(N);
figure
for i=1:number
    clust_idx=clust_order(i);
    exems=wish_list(T2==clust_idx);
    points=ismember(idx,exems);
    plot(SCORE(points,1),SCORE(points,2),'.','Color',colour(i,:), 'MarkerSize', mk)
    hold on
end
axis tight
axis equal
grid on
if ~isempty(APe_output_foldername)
    fPath=fullfile(figPath, '5_Clustermembers_in_ShapeSpace');
    saveas(gcf, fPath, 'fig');
    saveas(gcf, fPath, 'epsc');
end
figure
for i=1:number
    clust_idx=clust_order(i);
    exems=wish_list(T2==clust_idx);
    points=ismember(idx,exems);
    plot(SCORE(points,3),SCORE(points,4),'.','Color',colour(i,:), 'MarkerSize', mk)
    hold on
end
axis tight
axis equal
grid on

L=length(wish_list);

b=floor(sqrt(L));
a=ceil(L/b);
% figure -----------------
figure
set(gcf,'color','w');
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
if~isempty(APe_output_foldername)
    fPath=fullfile(figPath, '5_Clusters_ordered_exemplars');
    saveas(gcf, fPath, 'fig');
    saveas(gcf, fPath, 'epsc');
end

end


function mk = getMarkerSize(N)
mk = 10;
if N>10000, mk =7; end
if N>20000, mk =3; end
end


