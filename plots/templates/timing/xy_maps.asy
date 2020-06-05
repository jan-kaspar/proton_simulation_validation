import root;
import pad_layout;
include "../settings.asy";

string f = topDir + "data/" + version + "/" + period  + "/test_proton_reco.root";
ref_data_file = replace(ref_data_file, "output_tracks.root", "output.root");

bool draw_ref = (ref_data_fill != "NONE");

string plots[], p_labels[];
plots.push("arm0/h2_y_vs_x_tt0_ClCo"); p_labels.push("sector 45, 0 timing track");
plots.push("arm0/h2_y_vs_x_tt1_ClCo"); p_labels.push("sector 45, 1 timing track");
plots.push("arm1/h2_y_vs_x_tt0_ClCo"); p_labels.push("sector 56, 0 timing track");
plots.push("arm1/h2_y_vs_x_tt1_ClCo"); p_labels.push("sector 56, 1 timing track");

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("period: " + replace(period, "_", "\_"));
AddToLegend("version: " + version);

AttachLegend();

for (int pli : plots.keys)
	NewPadLabel(p_labels[pli]);

//----------------------------------------------------------------------------------------------------

NewRow();

NewPadLabel("simulation");

for (int pli : plots.keys)
{
	NewPad("$x\ung{mm}$", "$y\ung{mm}$");
	scale(Linear, Linear, Log);

	RootObject hist = RootGetObject(f, "multiRPPlots/" + plots[pli], error=false);
	if (!hist.valid)
		continue;

	draw(hist);

	limits((0, -10), (20, +10), Crop);
}

if (draw_ref)
{
	NewRow();

	NewPadLabel("LHC data (fill " + ref_data_fill + ")");

	for (int pli : plots.keys)
	{
		NewPad("$x\ung{mm}$", "$y\ung{mm}$");
		scale(Linear, Linear, Log);

		RootObject hist = RootGetObject(ref_data_file, "multiRPPlots/" + plots[pli], error=false);
		if (!hist.valid)
			continue;

		draw(hist);

		limits((0, -10), (20, +10), Crop);
	}
}
