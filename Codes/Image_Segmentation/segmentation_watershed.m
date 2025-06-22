clc; clear; close all;

% Output folder
output_folder = fullfile('outputs', 'segmented');
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Step 1: Load and convert to grayscale
img_name = 'cologne_000073_000019_leftImg8bit.png';
img = imread(img_name);
gray = rgb2gray(img);

% Step 2: Apply Gaussian filter to smooth noise
gray_blur = imgaussfilt(gray, 2);

% Step 3: Compute gradient magnitude
gmag = imgradient(gray_blur);

% Step 4: Adaptive thresholding to get binary regions
T = adaptthresh(gray_blur, 0.5);
bw = imbinarize(gray_blur, T);

% Step 5: Morphological cleaning
bw_clean = imopen(bw, strel('disk', 3));        % Remove small specks
bw_clean = imclose(bw_clean, strel('disk', 5)); % Fill gaps
bw_clean = imfill(bw_clean, 'holes');           % Fill enclosed holes

% Step 6: Compute distance transform
D = -bwdist(~bw_clean);
D(~bw_clean) = -Inf;

% Step 7: Find extended minima (foreground markers)
fgm = imextendedmin(D, 4); % Increase value if too many markers

% Step 8: Impose minima to guide watershed
D2 = imimposemin(D, fgm);

% Step 9: Apply watershed
L = watershed(D2);

% Step 10: Create boundary mask
boundary_mask = L == 0;

% Step 11: Overlay boundaries on original image
overlay = img;
overlay(repmat(boundary_mask, [1, 1, 3])) = 255;

% Save results
imwrite(overlay, fullfile(output_folder, 'cologne_watershed_overlay.png'));
imwrite(label2rgb(L, 'jet', 'w'), fullfile(output_folder, 'cologne_watershed_labeled.png'));

% Display
figure('Name', 'Watershed Overlay on Original');
imshow(overlay); title('Watershed Boundaries on Original Image');

figure('Name', 'Labeled Regions (Jet)');
imshow(label2rgb(L, 'jet', 'w')); title('Labeled Segmentation Map');
