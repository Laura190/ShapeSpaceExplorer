function [ CellShapeData ] = ShapeManifoldEmbedding_finalSJ( Frames, savedestination, doSparse, new_d )
%SHAPEMANIFOLDEMBEDDING Frames must be Nx1 Cell Array, N is your sample 
%size, each cell contains the Mx2 Contour outlines (M can vary), corresponding to closed planar curves 
%savedestination should be a string indicating the path to the desired save destination of the
%output file. Default will be the current folder 
%



%CellShapeData is a structure containing information about the dataset, the Diffusion Maps analysis and intermediate steps.

%The main output of this algorithm is the Diffusion Maps embedding of 
%the contour data (Find this at CellShapeData.set.SCORE or 
%CellShapeData.point(i).SCORE for the DM embedding of ith contour)   

%CellShapeData contains two substructures: set and point. 
    %Fields in the set substructure relate to the whole dataset:
    %CellShapeData.set.Long_D:  A long vector of pairwise BAM distances. Equivalent to symmetric distance matrix D, Long_D is arranged: D(1,2),D(1,3), D(2,3), D(1,4), D(2,4), D(3,4), etc...
    %CellShapeData.set.Vect: Matrix whose columns are eigenvectors (if you have RAM trouble, suppress lines 168&169)
    %CellShapeData.set.Val:  Eigenvalues
    %CellShapeData.set.sig_sq: Value used for kernel bandwidth in similarity measure (median(Long_D))
    %CellShapeData.set.SCORE: Final output, DM representation
    
    %Fields in the point substructure relate to the individual curves:
    %CellShapeData.point(i).coords: the original contour coordinates
    %CellShapeData.point(i).coords_interp: interpolated and rescaled coordinates
    %CellShapeData.point(i).original_curve_length: length of original contour
    %CellShapeData.point(i).coords_interp_trans: translated coordinates
    %CellShapeData.point(i).coords_comp: complex coordinate version of contour
    %CellShapeData.point(i).sum_curve: the sum of the squares of the absolute values of the complex coordinates
    %CellShapeData.point(i).fft_conj: the fast fourier transform of the complex conjugate of the coordinates
    %CellShapeData.point(i).fft_flip: the fast fourier transform of the coordinates in reverse order
    %CellShapeData.point(i).SCORE: Final output, DM representation of contour i
    
if ~exist('savedestination','var')
    savedestination=pwd;
end
%number of cells
N=length(Frames);
%waitbar
h = waitbar(0,'Please wait...');
w=0;
waitbar(0,h,sprintf('%5.2f%% completed ..',0));

for i=1:N
    Frames{i}=clockcheck(Frames{i});
end

nodes=512; %This selects the number of vertices for the contours, BAM runs quicker if it's a power of 2.

for i=1:N
    CellShapeData.point(i).coords=Frames{i};
end
%%interpolation
%stack={CellShapeData.point.coords}';
[snakematrix, lengthvec ]=Interpolate_and_rescale(Frames,h,nodes); 
for i=1:N
    CellShapeData.point(i).coords_interp=snakematrix(:,i);
    CellShapeData.point(i).original_curve_length=lengthvec(i);
end

%translate shapes to origin
for i=1:N
    f=CellShapeData.point(i).coords_interp;
    Xf=f(1:nodes);
    Yf=f((nodes+1):end);
    cXf=mean(Xf);
    cYf=mean(Yf);
    CellShapeData.point(i).coords_interp_trans=[(Xf-cXf) ; (Yf-cYf)];
end

%convert to complex representation
for i=1:N
    compvec_temp=CellShapeData.point(i).coords_interp_trans(1:nodes) + 1i*CellShapeData.point(i).coords_interp_trans((nodes+1):end);
    CellShapeData.point(i).coords_comp = compvec_temp(:);
end
    
%diffusion map embedding
%new_d=5; %Increase this to generate more new dimensions
CellShapeData=BAM_DM_frame(CellShapeData, new_d,h,nodes, doSparse);

waitbar((1)/(1),h,sprintf('Complete'));
save([savedestination '/CellShapeData.mat'], 'CellShapeData', '-v7.3');

CellShapeData_slim  = slimCellShapeData( CellShapeData );
clear CellShapeData;
CellShapeData =CellShapeData_slim;
save([savedestination '/CellShapeData_med.mat'], 'CellShapeData', '-v7.3');

CellShapeData_slim  = slimCellShapeData( CellShapeData, 1 );
clear CellShapeData;
CellShapeData =CellShapeData_slim;
save([savedestination '/CellShapeData_slim.mat'], 'CellShapeData', '-v7.3');

close(h);
end





