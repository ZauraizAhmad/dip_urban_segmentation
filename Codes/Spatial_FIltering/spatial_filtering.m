% spatial_filtering.m
clc; clear; close all;

% Input image
img = imread('hanover_000000_054276_leftImg8bit.png');  % adjust path as needed

gray = rgb2gray(img);

% Output folder
output_path = 'outputs/spatial_filtered/hanover_000000_054276_leftImg8bit';
if ~exist(output_path, 'dir')
    mkdir(output_path);
end

% 1. Mean Filter (3x3)
mean_filter = fspecial('average', [3 3]);
mean_result = imfilter(gray, mean_filter, 'replicate');
imwrite(mean_result, [output_path 'mean_filtered.png']);

% 2. Gaussian Filter (3x3, sigma=1)
gaussian_result = imgaussfilt(gray, 1);  % sigma = 1
imwrite(gaussian_result, [output_path 'gaussian_filtered.png']);

% 3. Median Filter (3x3)
median_result = medfilt2(gray, [3 3]);
imwrite(median_result, [output_path 'median_filtered.png']);

% Display results
figure;
subplot(2,2,1); imshow(gray); title('Original Grayscale');
subplot(2,2,2); imshow(mean_result); title('Mean Filter');
subplot(2,2,3); imshow(gaussian_result); title('Gaussian Filter');
subplot(2,2,4); imshow(median_result); title('Median Filter');
