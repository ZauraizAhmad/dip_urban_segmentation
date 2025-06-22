clc; clear; close all;

% Output folder setup
output_folder = fullfile('outputs', 'segmented');
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Image file from root folder
img_name = 'bremen_000007_000019_leftImg8bit.png';
img = imread(img_name);

% Convert to grayscale
gray = rgb2gray(img);

% Apply Canny edge detection
edges = edge(gray, 'Canny');

% Save result
imwrite(edges, fullfile(output_folder, 'bremen_canny.png'));

% Show in separate figures
figure('Name', 'Original Bremen Grayscale');
imshow(gray); title('Original Grayscale');

figure('Name', 'Canny Edge Detection (Bremen)');
imshow(edges); title('Canny Edge Detection');
