function  RunShapeManifoldEmbedding()

out=SelectFolderEigen();
dataFile = fullfile(out.folder, 'Bigcellarrayandindex.mat');
global PATH;
PATH=out.folder;
if exist(dataFile, 'file') && out.dims >=2
    data = load(dataFile);
    ShapeManifoldEmbedding_finalSJ(data.BigCellArray, out.folder, out.sparse, out.dims);
elseif out.dims<2
    display('-------')
    display('Number of dimensions must be greater than 2');
    display('-------')
else 
    display('-------')
    display('The file "Bigcellarrayandindex.mat" does not exist in your Analysis folder.');
    display('Please check whether previous steps have been succesfully completed.');
    display('-------')

end
end

