string period = "2016_preTS2";

string version = "version1";

string ref_data_file = "/afs/cern.ch/work/j/jkaspar/analyses/ctpps/proton_reconstruction_validation/data/2016/version3/fill_5052/xangle_185_beta_0.30_stream_ALL/output_tracks.root";
string ref_data_fill = "5052";

string rps[], rp_labels[];
rps.push("3"); rp_labels.push("45-210-fr");
rps.push("2"); rp_labels.push("45-210-nr");
rps.push("102"); rp_labels.push("56-210-nr");
rps.push("103"); rp_labels.push("56-210-fr");

string sectors[], s_rpId_N[], s_rpId_F[];
pen s_pens[];
sectors.push("sector 45"); s_pens.push(red); s_rpId_N.push("2"); s_rpId_F.push("3");
sectors.push("sector 56"); s_pens.push(blue); s_rpId_N.push("102"); s_rpId_F.push("103");

bool rebin = true;
