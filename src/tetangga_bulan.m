function [x, H, target] = tetangga_bulan(data, kabupaten, tahun, bulan)
  % x dan H berupa vektor baris empat tetangga asli. target = indeks baris
  % observasi untuk evaluasi sesudah prediksi. Jendela tak lengkap ditolak.
  validateattributes(tahun, {'numeric'}, {'scalar','real','finite','integer'});
  validateattributes(bulan, {'numeric'}, {'scalar','real','integer','>=',1,'<=',12});
  baris = find(strcmp(data.kabupaten, kabupaten));
  pusat = 12*tahun + bulan - 1;
  [ada, indeks] = ismember(pusat + (-2:2), data.bulan(baris));
  if !all(ada)
    error('metnum:jendela', 'Target atau tetangga tidak lengkap: %s %04d-%02d.', kabupaten, tahun, bulan);
  endif
  target = baris(indeks(3));
  tetangga = baris(indeks([1 2 4 5]));
  x = data.bulan(tetangga)' - pusat;
  H = data.H(tetangga)';
endfunction
