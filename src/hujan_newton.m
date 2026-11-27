function [y, a, tabel] = hujan_newton(x, H, q)
  % Empat simpul (x dalam bulan, H dalam mm/bulan), q dalam [x(1), x(4)].
  % x dan H boleh baris/kolom. y (mm/bulan) mengikuti bentuk skalar/vektor q.
  % tabel(i,k+1) dimulai di simpul i untuk orde k; sel di luar segitiga NaN.
  % a adalah baris pertama tabel. Masukan tak sah menimbulkan error metnum:masukan.
  [x, H, q] = simpul_valid(x, H, q, 4, 1, 4);
  tabel = NaN(4);
  tabel(:,1) = H;
  for k = 1:3
    for i = 1:4-k
      tabel(i,k+1) = (tabel(i+1,k) - tabel(i,k)) / (x(i+k) - x(i));
    endfor
  endfor
  a = tabel(1,:);
  y = a(4);
  for i = 3:-1:1
    y = a(i) + (q - x(i)) .* y;
  endfor
endfunction
