% Dari folder repositori: octave-cli src/run_m3c.m
addpath('src');
out = 'hasil';
[ok, pesan] = mkdir(out);
assert(ok, pesan);
kab = {'Grobogan', 'Cilacap', 'Sragen'};
metode = {'Linear', 'Newton kubik', 'PCHIP'};
kalender = (12*2011 : 12*2026-1)';
target = kalender(3:end-2);
data = baca_hujan('data/curah_hujan_2011_2025.csv');
assert(isequal(unique(data.kabupaten), sort(kab(:))) && all(data.H >= 0));

hasil = fopen(fullfile(out, 'prediksi.csv'), 'wt');
assert(hasil >= 0);
fprintf(hasil, ['kabupaten,tanggal,metode,aktual,pred_raw,galat_absolut,' ...
  'kategori_aktual,kategori_pred,cocok,negatif,pred_clip,galat_clip\n']);
% Kolom indeks berturut-turut adalah target, metode, dan kabupaten.
raw = galat = galat_clip = NaN(numel(target), 3, 3);
cocok = false(size(raw));
for k = 1:numel(kab)
  seri = sort(data.bulan(strcmp(data.kabupaten, kab{k})));
  assert(isequal(seri, kalender));
  for t = 1:numel(target)
    tahun = floor(target(t)/12);
    bulan = mod(target(t), 12) + 1;
    [x, H, i] = tetangga_bulan(data, kab{k}, tahun, bulan);
    assert(isequal(x, [-2 -1 1 2]));
    y = [hujan_linear(x(2:3), H(2:3), 0), hujan_newton(x, H, 0), ...
         hujan_pchip_tengah(x, H, 0)];
    asli = data.H(i);
    for m = 1:numel(metode)
      e = evaluasi_hujan(y(m), asli);
      clip = evaluasi_hujan(max(y(m), 0), asli);
      assert(clip.galat_absolut <= e.galat_absolut && ...
             strcmp(clip.kategori, e.kategori) && clip.cocok == e.cocok);
      raw(t,m,k) = y(m);
      galat(t,m,k) = e.galat_absolut;
      galat_clip(t,m,k) = clip.galat_absolut;
      cocok(t,m,k) = e.cocok;
      fprintf(hasil, ['%s,%04d-%02d-01,%s,%.17g,%.17g,%.17g,' ...
        '%s,%s,%d,%d,%.17g,%.17g\n'], kab{k}, tahun, bulan, metode{m}, ...
        asli, y(m), e.galat_absolut, e.kategori_asli, e.kategori, ...
        e.cocok, e.negatif, clip.prediksi, clip.galat_absolut);
    endfor
  endfor
endfor
assert(fclose(hasil) == 0);
metrik = fopen(fullfile(out, 'metrik.csv'), 'wt');
sens = fopen(fullfile(out, 'sensitivitas.csv'), 'wt');
assert(metrik >= 0 && sens >= 0);
fprintf(metrik, ['wilayah,metode,n,mae_raw,n_cocok,persen_cocok,' ...
  'n_negatif,persen_negatif,min_raw\n']);
fprintf(sens, 'wilayah,metode,n,mae_raw,mae_clip,penurunan_mae\n');
wilayah = [kab {'Gabungan'}];
for k = 1:numel(wilayah)
  grup = k;
  if k == numel(wilayah)
    grup = 1:numel(kab);
  endif
  for m = 1:numel(metode)
    nilai = raw(:,m,grup)(:);
    n = numel(nilai);
    mae = sum(galat(:,m,grup)(:)) / n;
    mae_clip = sum(galat_clip(:,m,grup)(:)) / n;
    benar = sum(cocok(:,m,grup)(:));
    negatif = sum(nilai < 0);
    fprintf(metrik, '%s,%s,%d,%.17g,%d,%.17g,%d,%.17g,%.17g\n', ...
      wilayah{k}, metode{m}, n, mae, benar, 100*benar/n, negatif, ...
      100*negatif/n, min(nilai));
    fprintf(sens, '%s,%s,%d,%.17g,%.17g,%.17g\n', ...
      wilayah{k}, metode{m}, n, mae, mae_clip, mae-mae_clip);
  endfor
endfor
assert(fclose(metrik) == 0 && fclose(sens) == 0);
printf('Selesai: %d taksiran tersimpan di folder %s.\n', numel(raw), out);
