function [ morphframe ] = Morph_Props( CellArray , savedestination)
%MORPH_PROPS Summary of this function goes here
%   Detailed explanation goes here
%CellShapeData should be the output of BAM DM through the
%ShapeManifoldEmbedding code of your training data.

if ~exist('savedestination','var')
    savedestination=pwd; 
end
L=length(CellArray);
h=waitbar(0, 'keep waiting');
for i=1:L
   waitbar(i/L, h, 'keep waiting');
   coords=CellArray{i};
   binimage=BinIm(coords,i);
   morphframe_temp=regionprops(binimage,'all');
   %i
   morphframe_temp.Circularity=morphframe_temp.Perimeter/(2*sqrt(pi*morphframe_temp.Area));
   
   B=bwboundaries(binimage,'noholes');
   borderpixels=B{1}; %I hope there will always be only one element in B
   Centreofgravity=morphframe_temp.Centroid;
   dist=borderpixels - repmat([Centreofgravity(2) Centreofgravity(1)],length(borderpixels),1);
   dist = sqrt(sum(dist.^2,2));
   %maximal distance between centre of gravity and border pixels
   morphframe_temp.Dist_max=max(dist);
   %minimal distance between centre of gravity and border pixels
   morphframe_temp.Dist_min=min(dist);
   %ratio of minimal to maximal distances between centre of gravity and border pixels
   morphframe_temp.Dist_ratio=morphframe_temp.Dist_min/morphframe_temp.Dist_max;
   %We are assuming cells to be simple closed curves
   %irregularity (foreground irregularity)
   [r,c]=find(binimage);
   r=r-mean(r);
   c=c-mean(c);
   morphframe_temp.Irregularity=(1+sqrt(pi)*max(sqrt(c.^2 +r.^2)))./sqrt(morphframe_temp.Area) -1;
   %irregularity2 (background irregularity)
   [r2,c2]=find(~binimage);
   r2=r2-mean(r2);
   c2=c2-mean(c2);
   morphframe_temp.Irregularity2=(1+sqrt(pi)*max(sqrt(c2.^2 +r2.^2)))./sqrt(length(r2)) -1;
   morphframe_temp.Symmetry=symmetry_score( coords, morphframe_temp.Orientation, morphframe_temp.MajorAxisLength );
   morphframe(i)=morphframe_temp;
end
delete(h)
save([savedestination '/Morphframe.mat'],'morphframe','-v7.3')

end

function [ symscore ] = symmetry_score( coords, orientation, maj_axis_length )
%SYMMETRY_SCORE Summary of this function goes here
%   Detailed explanation goes here
theta=orientation;
l=[cos(theta*pi/180); sin(theta*pi/180)];
A=[l(1)^2-l(2)^2 2*l(1)*l(2); 2*l(1)*l(2) l(2)^2-l(1)^2];
coords=coords-repmat(mean(coords),size(coords,1),1);
T_coords=A*coords';
L=maj_axis_length;
C1=BinImBox(coords,L);
C2=BinImBox(T_coords',L);
% figure
% imshow(C1,[])
% figure
% imshow(C2,[])
 %figure
%C=cat(3,C1,zeros(size(C1)),C2);
%imshow(C,[])
C_=C1&C2;
symscore=sum(C_(:))/sum(C1(:));
end

function [binimage]=BinIm(coords,num)
coords=round(coords*188);
x_coords=coords(:,1);
y_coords=coords(:,2);
y_coords=-y_coords;
cols=max(x_coords)-min(x_coords);
rows=max(y_coords)-min(y_coords);
disp=round(0.1*max(cols,rows));
x_coords=x_coords-min(x_coords);
y_coords=(y_coords-min(y_coords));

%binimage=poly2mask(x_coords+disp,y_coords+disp,rows+2*disp,cols+2*disp);
%binimage=imdilate(binimage,[0 1 0; 1 1 1; 0 1 0]);
%binimage=imclose(binimage,strel('disk',1));
BW = roipoly(ones(rows+2*disp,cols+2*disp),x_coords+disp,y_coords+disp);
BW2 = lineburning(BW,x_coords+disp,y_coords+disp);
% if rem(num,100)==0;
%     figure; imshow(BW2,[]);
% end
binimage=bwareaopen(BW2, 10);

end

function im = lineburning(im, x, y)

n = numel(x);
m = size(im,1);
for k=1:n-1
    x1 = x(k);
    x2 = x(k+1);
    y1 = y(k);
    y2 = y(k+1);
    if abs(x2-x1)>abs(y2-y1)
        if x2<x1
            [x1 x2] = deal(x2,x1);
            [y1 y2] = deal(y2,y1);
        end
        xi = (x1:x2).';
        yi = linterp(x1, x2, y1, y2, xi);
    else
        if y2<y1
            [x1 x2] = deal(x2,x1);
            [y1 y2] = deal(y2,y1);
        end
        yi = (y1:y2).';
        xi = linterp(y1, y2, x1, x2, yi);
    end
    ind = (xi-1)*m+yi;
    ind = ind(ind>=1 & ind <=numel(im));
    im(ind) = 1; % Put the color you want here
end

function y = linterp(x1, x2, y1, y2, x)
    y = round(y1+(x-x1)*((y2-y1)/(x2-x1)));
end
end

function [binimage]=BinImBox(coords,L)

coords=round(coords);
x_coords=coords(:,1);
y_coords=coords(:,2);
y_coords=-y_coords;
% cols=max(x_coords)-min(x_coords);
% rows=max(y_coords)-min(y_coords);
% disp=round(0.1*max(cols,rows));
% x_coords=x_coords-min(x_coords);
% y_coords=(y_coords-min(y_coords));

%binimage=poly2mask(x_coords+disp,y_coords+disp,rows+2*disp,cols+2*disp);
%binimage=imdilate(binimage,[0 1 0; 1 1 1; 0 1 0]);
%binimage=imclose(binimage,strel('disk',1));
%BW = roipoly(ones(rows+2*disp,cols+2*disp),x_coords+disp,y_coords+disp);
L2=ceil(1.2*L);
BW = roipoly(ones(L2,L2),x_coords+ceil(0.5*L2),y_coords+ceil(0.5*L2));
BW2 = lineburning(BW,x_coords+ceil(0.5*L2),y_coords+ceil(0.5*L2));
% if rem(num,100)==0;
%     figure; imshow(BW2,[]);
% end
binimage=bwareaopen(BW2, 10);

end