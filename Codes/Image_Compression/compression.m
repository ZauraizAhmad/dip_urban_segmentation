% Read original image
original = imread('cologne_000073_000019_leftImg8bit.png');

% Save as JPEG with quality = 30 (more compression)
imwrite(original, 'compressed_q30.jpg', 'jpg', 'Quality', 30);

% Read compressed image back
compressed = imread('compressed_q30.jpg');

% Show both images
figure;
subplot(1,2,1), imshow(original), title('Original');
subplot(1,2,2), imshow(compressed), title('Compressed (Q=30)');

% Convert to grayscale for PSNR/SSIM calculation (if needed)
if size(original,3) == 3
    original_gray = rgb2gray(original);
    compressed_gray = rgb2gray(compressed);
else
    original_gray = original;
    compressed_gray = compressed;
end

% Calculate PSNR and SSIM
psnr_value = psnr(compressed_gray, original_gray);
ssim_value = ssim(compressed_gray, original_gray);

% File size comparison
original_info = dir('cologne_000073_000019_leftImg8bit.png');
compressed_info = dir('compressed_q30.jpg');

disp(['Original size: ', num2str(original_info.bytes / 1024, '%.2f'), ' KB']);
disp(['Compressed size: ', num2str(compressed_info.bytes / 1024, '%.2f'), ' KB']);
disp(['PSNR: ', num2str(psnr_value, '%.2f'), ' dB']);
disp(['SSIM: ', num2str(ssim_value, '%.4f')]);

