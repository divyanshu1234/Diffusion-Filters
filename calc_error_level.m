clear all;

% image_n = 'tomo';
image_n = 'tri';

% diff_type = 'eed';
% diff_type = 'ced';
diff_type = 'pca';

% level_list = {'0_01', '0_05', '0_10', '0_25', '0_50'};
% level_list = {'gauss', 'sp', 'poi', 'spe'};
% level_list = {'ld', 'pm', 'pmc', 'eed', 'ced'};
level_list = {'10', '20', '30', '40', '50', '60'};

img_ref = double(imread(strcat('Outputs2/', image_n, '.jpg')));

psnr_mse = [];

for level = level_list
    path = char(strcat('Outputs2/', image_n, '_', diff_type, '_', string(level), '.jpg'));
%     path = char(strcat('Outputs2/', image_n, '_', string(level), '.jpg'));
    img = double(imread(path));
    
    psnr_mse = [psnr_mse; psnr(img, img_ref, 255), immse(img, img_ref)];
end

psnr_mse = round(psnr_mse, 4);