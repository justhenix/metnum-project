function [y, sekan, m] = hujan_pchip_tengah(x, H, q)
  % Empat simpul (x dalam bulan, H dalam mm/bulan), q dalam [x(2), x(3)].
  % x dan H boleh baris/kolom. y (mm/bulan) mengikuti bentuk skalar/vektor q.
  % sekan (3x1) dan turunan interior m (2x1) per langkah bulan.
  % Masukan tak sah menimbulkan error metnum:masukan.
  [x, H, q] = simpul_valid(x, H, q, 4, 2, 3);
  h = diff(x);
  sekan = diff(H) ./ h;
  m = zeros(2,1);
  for i = 1:2
    kiri = sekan(i);
    kanan = sekan(i+1);
    if kiri != 0 && kanan != 0 && sign(kiri) == sign(kanan)
      w1 = 2*h(i+1) + h(i);
      w2 = h(i+1) + 2*h(i);
      m(i) = (w1 + w2) / (w1/kiri + w2/kanan);
    endif
  endfor
  u = (q - x(2)) / h(2);
  y = (2*u.^3 - 3*u.^2 + 1) * H(2) + (u.^3 - 2*u.^2 + u) * h(2)*m(1) ...
    + (3*u.^2 - 2*u.^3) * H(3) + (u.^3 - u.^2) * h(2)*m(2);
endfunction
