function y = hujan_linear(x, H, q)
  % Dua pengapit (x dalam bulan, H dalam mm/bulan), q dalam [x(1), x(2)].
  % x dan H boleh baris/kolom. y (mm/bulan) mengikuti bentuk skalar/vektor q.
  % Masukan tak sah menimbulkan error metnum:masukan.
  [x, H, q] = simpul_valid(x, H, q, 2, 1, 2);
  y = H(1) + (q - x(1)) / (x(2) - x(1)) * (H(2) - H(1));
endfunction
