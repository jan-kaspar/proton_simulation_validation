string topDir = "/afs/cern.ch/work/j/jkaspar/work/analyses/ctpps/proton_simulation_validation/";

string period = "2016_postTS2";

string version = "version10";

string ref_data_fill = "5427";
string ref_data_dir = "/afs/cern.ch/work/j/jkaspar/work/analyses/ctpps/proton_reconstruction_validation/data/2016/version-UL-devel-11";
string ref_data_file = ref_data_dir + "/fill_" + ref_data_fill + "/xangle_140_beta_0.40_stream_ALL/output_tracks.root";

string rps[], rp_labels[];
rps.push("3"); rp_labels.push("45-210-fr");
rps.push("2"); rp_labels.push("45-210-nr");
rps.push("102"); rp_labels.push("56-210-nr");
rps.push("103"); rp_labels.push("56-210-fr");

string arms[], a_sectors[], a_labels[], a_nr_rps[], a_fr_rps[];
pen a_pens[];
arms.push("arm0"); a_sectors.push("sector 45"); a_labels.push("sector 45 (L, z+)"); a_nr_rps.push("2"); a_fr_rps.push("3"); a_pens.push(blue);
arms.push("arm1"); a_sectors.push("sector 56"); a_labels.push("sector 56 (R, z-)"); a_nr_rps.push("102"); a_fr_rps.push("103"); a_pens.push(red);

bool rebin = true;
