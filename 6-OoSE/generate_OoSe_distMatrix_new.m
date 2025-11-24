function  generate_OoSe_distMatrix( )
%generate_OoSe_distMatrix OoSE embedding
%   Calculate distance matrix for addition data using a choice of two
%   methods.
%   path.anaFolder is path to analysis folder containing CellShapeData 
%   from output of BAM DM through the ShapeManifoldEmbedding code of your 
%   training data.
%   path.OosFolder is path to additional data (OoSE folder) containing 
%   Bigcellarrayandindex in your contour output folder from 
%   1-ImageSegmentationFull.
%   chosen_method is index of available methods:
%       - Nearest neightbours with K=5 
%       - Laplacian Pyramids


path=OoseConfig1();
try if isempty(path.anaFolder) || isempty(path.OosFolder)||...
    strcmp(path.anaFolder,path.OosFolder)==1 ||...
    ~exist(path.anaFolder, 'dir') || ~exist(path.OosFolder, 'dir')
    return;
    end
catch
    return;
end
disp('Files Loading...')
cPath=fullfile(path.anaFolder, 'CellShapeData.mat');
cData= load(cPath);

bPath1 = fullfile(path.OosFolder, 'Bigcellarrayandindex.mat');
bData= load(bPath1);
disp('Files Loaded');

if ~isfile(fullfile(path.OosFolder, 'Dist_mat.mat'))
    disp('Calculating BAM values');
    BAM_for_OoSE(cData.CellShapeData, bData.BigCellArray, path.OosFolder)
    disp('BAM values calculated, saved as Dist_mat.mat');
else
    disp('Using existing Dist_mat.mat file')
end

bPath = fullfile(path.OosFolder, 'Dist_mat.mat');
if path.chosen_method == 2
    LP_OoSE_train(cData.CellShapeData, path.OosFolder);
    lPath=fullfile(path.OosFolder, 'LP_trained.mat');
    LP_OoSE_run(cData.CellShapeData, lPath, bPath, path.OosFolder);
else
    DIST= load(bPath);
    K=path.nn_value;
    nn_OoSE_run(cData.CellShapeData, DIST, path.OosFolder,K);
end

%%%%%%%%%%%%%%%%%%
% oPath = fullfile(path.OosFolder, 'OoSE_embedding.mat');
% OoSEscores= load(oPath);
% 
% iPath = fullfile(path.OosFolder, 'Bigcellarrayandindex.mat');
% OoSEcellarrayandindex= load(iPath);
% 
% sPath = fullfile(path.OosFolder, 'BigCellDataStruct.mat');
% OoSECellDataStruct= load(sPath);
% 
% 
% CreateCDS_OoSE_run_new(OoSEscores, OoSEcellarrayandindex.BigCellArray, OoSECellDataStruct, path.OosFolder)
% display('Oose CDS is sucessfully generated');

%%%%%%%%%%%
RunCreateCellShapeDataforOoSE(path.OosFolder);
%%%%%%%%%%%

end
