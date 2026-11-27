function hasil = evaluasi_hujan(prediksi, asli)
  % Dua skalar riil berhingga (mm/bulan). Galat dan kategori memakai nilai mentah.
  hasil.kategori = kategori(prediksi);
  hasil.kategori_asli = kategori(asli);
  hasil.prediksi = prediksi;
  hasil.galat_absolut = abs(double(prediksi) - double(asli));
  hasil.cocok = strcmp(hasil.kategori, hasil.kategori_asli);
  hasil.negatif = prediksi < 0;
endfunction

function nama = kategori(H)
  validateattributes(H, {'numeric'}, {'scalar','real','finite'});
  if H < 100
    nama = 'Kering';
  elseif H <= 200
    nama = 'Lembap';
  else
    nama = 'Basah';
  endif
endfunction
