%% Reconstruct manual-segmentation input folders from MATLAB output
% Select BigCellDataStruct.mat when prompted. The generated directory tree is:
%
%   reconstructed_input/
%       stack001/
%           Cell_001/
%               frame001.txt
%               frame002.txt
%
% Each text file has the ImageJ-style columns: pointid, x, y.
%
% Note: The original filenames and contours rejected for having fewer than
% three points were not stored by Import_Manual_Segs_plus_Struct, so they
% cannot be reconstructed. Canonical names are generated instead.

clear;
clc;

[mat_name, mat_folder] = uigetfile( ...
    {'*.mat', 'MATLAB data files (*.mat)'}, ...
    'Select BigCellDataStruct.mat');

if isequal(mat_name, 0)
    error('No MAT file was selected.');
end

output_root = uigetdir(mat_folder, 'Select a parent folder for reconstructed_input');
if isequal(output_root, 0)
    error('No output folder was selected.');
end

output_root = fullfile(output_root, 'reconstructed_input');
if isfolder(output_root)
    error(['Output folder already exists: %s\n' ...
           'Remove it or choose another parent folder to avoid overwriting data.'], ...
          output_root);
end
mkdir(output_root);

loaded = load(fullfile(mat_folder, mat_name), 'BigCellDataStruct');
if ~isfield(loaded, 'BigCellDataStruct')
    error('The selected file does not contain BigCellDataStruct.');
end

cells = loaded.BigCellDataStruct;
required_fields = {'Stack_number', 'Cell_number', 'Contours'};
if ~all(isfield(cells, required_fields))
    error('BigCellDataStruct must contain Stack_number, Cell_number, and Contours.');
end

num_cells = numel(cells);
num_contours = 0;

for cell_index = 1:num_cells
    if isempty(cells(cell_index).Stack_number)
        continue;
    end
    stack_number = validate_index(cells(cell_index).Stack_number, 'Stack_number');
    cell_number = validate_index(cells(cell_index).Cell_number, 'Cell_number');

    stack_folder = fullfile(output_root, sprintf('stack%03d', stack_number));
    cell_folder = fullfile(stack_folder, sprintf('Cell_%03d', cell_number));
    if ~isfolder(cell_folder)
        mkdir(cell_folder);
    end

    contours = cells(cell_index).Contours;
    if isempty(contours)
        continue;
    end
    if ~iscell(contours)
        error('Contours for structure element %d is not a cell array.', cell_index);
    end

    for frame_number = 1:numel(contours)
        points = contours{frame_number};
        validateattributes(points, {'numeric'}, ...
            {'2d', 'ncols', 2, 'finite', 'real'}, ...
            mfilename, sprintf('Contours{%d}', frame_number));

        if size(points, 1) < 3
            warning('Skipping contour %d for stack %d, cell %d: fewer than 3 points.', ...
                frame_number, stack_number, cell_number);
            continue;
        end

        output_file = fullfile(cell_folder, sprintf('frame%03d.txt', frame_number));
        file_id = fopen(output_file, 'wt');
        if file_id == -1
            error('Could not open output file: %s', output_file);
        end

        cleanup = onCleanup(@() fclose(file_id));
        fprintf(file_id, 'pointid\tx\ty\n');
        for point_id = 1:size(points, 1)
            fprintf(file_id, '%d\t%.17g\t%.17g\n', ...
                point_id, points(point_id, 1), points(point_id, 2));
        end
        clear cleanup;
        num_contours = num_contours + 1;
    end
end

fprintf('Reconstructed %d cells and %d contour files in:\n%s\n', ...
    num_cells, num_contours, output_root);

function value = validate_index(value, field_name)
    validateattributes(value, {'numeric'}, ...
        {'scalar', 'integer', 'positive', 'finite', 'real'}, ...
        mfilename, field_name);
    value = double(value);
end
