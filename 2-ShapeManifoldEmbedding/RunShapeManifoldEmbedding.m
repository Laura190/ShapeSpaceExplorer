function  RunShapeManifoldEmbedding()

out=SelectFolderEigen();
dataFile = fullfile(out.folder, 'Bigcellarrayandindex.mat');
global PATH;
PATH=out.folder;
if exist(dataFile, 'file')
    data = load(dataFile);
    ShapeManifoldEmbedding_finalSJ(data.BigCellArray, out.folder, out.sparse, out.dims);
else 
    display('-------')
    display('The file "Bigcellarrayandindex.mat" does not exist in your Analysis folder.');
    display('Please check whether previous steps have been succesfully completed.');
    display('-------')

end
end

