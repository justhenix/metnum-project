function data = baca_hujan(path)
  % CSV proyek. Satu elemen per baris sumber; bulan = 12*tahun + nomor_bulan - 1.
  fid = fopen(path, 'rt');
  if fid < 0
    error('CSV tidak dapat dibuka: %s', path);
  endif
  tutup = onCleanup(@() fclose(fid));
  header = strsplit(strtrim(fgetl(fid)), ',');
  kolom = textscan(fid, repmat('%s', 1, numel(header)), 'Delimiter', ',', 'EndOfLine', '\n');
  nama = {'kabupaten', 'tanggal', 'curah_hujan_mm_per_bulan'};
  for i = 1:3
    idx = find(strcmp(header, nama{i}));
    assert(isscalar(idx), 'Kolom CSV hilang atau ganda: %s', nama{i});
    isi{i} = kolom{idx};
  endfor
  data.kabupaten = isi{1};
  tanggal = char(isi{2});
  assert(all(!cellfun(@isempty, regexp(isi{2}, '^[0-9]{4}-(0[1-9]|1[0-2])-01$'))), ...
         'Tanggal CSV harus menandai hari pertama bulan kalender.');
  data.bulan = 12 * str2double(cellstr(tanggal(:,1:4))) + str2double(cellstr(tanggal(:,6:7))) - 1;
  data.H = str2double(isi{3});
  assert(isequal(size(data.bulan), size(data.H), size(data.kabupaten)) && ...
         all(isfinite(data.H)) && isreal(data.H), 'Baris atau total bulanan CSV tidak sah.');
  for kab = unique(data.kabupaten)'
    bulan = data.bulan(strcmp(data.kabupaten, kab{1}));
    assert(numel(unique(bulan)) == numel(bulan), 'Bulan ganda di %s.', kab{1});
  endfor
endfunction
