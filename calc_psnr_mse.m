function [psnr_, mse_] = calc_psnr_mse(img, img_ref)

[M, N] = size(img);
mse_ = 0.0;

for i = 1:M
    for j = 1:N
        mse_ = mse_ + (double(img(i, j)) - double(img_ref(i, j))) ^ 2;
    end
end

mse_ = mse_ / (M*N);
psnr_ = 10 * log10(double(255*255) / double(mse_));

end