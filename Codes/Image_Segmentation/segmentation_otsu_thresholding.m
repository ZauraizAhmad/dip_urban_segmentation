clc; clear; close all;

% Output folder
output_folder = fullfile('outputs', 'segmented');
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Image file
img_name = 'hamburg_000000_016928_leftImg8bit.png';
img = imread(img_name);
gray = rgb2gray(img);

% Apply global thresholding (Otsu's method)
binary = imbinarize(gray);

% Save output
imwrite(binary, fullfile(output_folder, 'hamburg_threshold.png'));

% Display results
figure('Name', 'Original Hamburg Grayscale');
imshow(gray); title('Original Grayscale');

figure('Name', 'Hamburg Thresholded');
imshow(binary); title('Global Thresholding (Otsu)');
