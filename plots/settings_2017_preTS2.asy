string period = "2017_preTS2";

string version = "version1";

string ref_data_file = "/afs/cern.ch/work/j/jkaspar/analyses/ctpps/proton_reconstruction_validation/data/2017/version10/fill_6053/xangle_150_beta_0.40_stream_ALL/output_tracks.root";
string ref_data_fill = "6053";

string rps[], rp_labels[];
rps.push("23"); rp_labels.push("45-220-fr");
rps.push("3"); rp_labels.push("45-210-fr");
rps.push("103"); rp_labels.push("56-210-fr");
rps.push("123"); rp_labels.push("56-220-fr");

bool rebin = true;
