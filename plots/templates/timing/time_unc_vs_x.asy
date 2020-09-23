import root;
import pad_layout;
include "../settings.asy";

string f = topDir + "data/" + version + "/" + period  + "/test_proton_reco.root";

ref_data_file = replace(ref_data_file, "output_tracks.root", "output.root");

xTicksDef = LeftTicks(5., 1.);
yTicksDef = RightTicks(0.05, 0.01);

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
	NewPad("$x_{\rm tracking}\ung{mm}$", "proton time uncertainty$\ung{ns}$");

	RootObject hist = RootGetObject(f, "multiRPPlots/" + arms[ai] + "/p_time_unc_vs_x_ClCo", error=true);

	if (!hist.valid)
		continue;

	draw(hist, "vl", black);

	bool draw_ref = (ref_data_fill != "NONE");

	if (draw_ref)
	{
		RootObject hist_ref = RootGetObject(ref_data_file, "multiRPPlots/" + arms[ai] + "/p_time_unc_vs_x_ClCo", error=true);
		if (hist_ref.valid)
			draw(hist_ref, "vl", red+dashed);
	}


	limits((0, 0.05), (20, 0.20), Crop);
}

GShipout(vSkip=1mm);
