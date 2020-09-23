string topDir = "/afs/cern.ch/work/j/jkaspar/work/analyses/ctpps/proton_simulation_validation/";

string period = "2017_postTS2";

string version = "version12";

string ref_data_fill = "6304";
string ref_data_dir = "/afs/cern.ch/work/j/jkaspar/work/analyses/ctpps/proton_reconstruction_validation/data/2017/version-simu-cmp-1";
string ref_data_file = ref_data_dir + "/fill_" + ref_data_fill + "/xangle_140_beta_0.30_stream_ALL/output_tracks.root";

string rps[], rp_labels[];
rps.push("23"); rp_labels.push("45-220-fr");
rps.push("3"); rp_labels.push("45-210-fr");
rps.push("103"); rp_labels.push("56-210-fr");
rps.push("123"); rp_labels.push("56-220-fr");

string arms[], a_sectors[], a_labels[], a_nr_rps[], a_fr_rps[];
pen a_pens[];
arms.push("arm0"); a_sectors.push("sector 45"); a_labels.push("sector 45 (L, z+)"); a_nr_rps.push("3"); a_fr_rps.push("23"); a_pens.push(blue);
arms.push("arm1"); a_sectors.push("sector 56"); a_labels.push("sector 56 (R, z-)"); a_nr_rps.push("103"); a_fr_rps.push("123"); a_pens.push(red);

bool rebin = true;
