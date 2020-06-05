import root;
import pad_layout;
include "../settings.asy";

string f = topDir + "data/" + version + "/" + period  + "/test_proton_reco.root";

ref_data_file = replace(ref_data_file, "output_tracks.root", "output.root");

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("<period: " + replace(period, "_", "\_"));
AddToLegend("<version: " + version);

AddToLegend("simulation", black);
AddToLegend("LHC data (fill " + ref_data_fill + ")", red+dashed);

AttachLegend();

//----------------------------------------------------------------------------------------------------

for (int ai : arms.keys)
	NewPadLabel(a_labels[ai]);

NewRow();

NewPadLabel("");

for (int ai : arms.keys)
{
	NewPad("proton time$\ung{ns}$");

	RootObject hist = RootGetObject(f, "multiRPPlots/" + arms[ai] + "/h_time", error=false);

	if (!hist.valid)
		continue;

	draw(hist, "n,vl", black);

	bool draw_ref = (ref_data_fill != "NONE");

	if (draw_ref)
	{
		RootObject hist_ref = RootGetObject(ref_data_file, "multiRPPlots/" + arms[ai] + "/h_time", error=true);
		if (hist_ref.valid)
			draw(hist_ref, "n,vl", red+dashed);
	}


	//limits((0, 0), (20, 20), Crop);
}

GShipout(vSkip=1mm);
