import root;
import pad_layout;
include "../settings.asy";

string f = topDir + "data/" + version + "/" + period  + "/test_proton_reco.root";
ref_data_file = replace(ref_data_file, "output_tracks.root", "output.root");

bool draw_ref = (ref_data_fill != "NONE");

xTicksDef = LeftTicks(5., 1.);
yTicksDef = RightTicks(5., 1.);

TH2_palette = Gradient(white, blue, heavygreen, yellow, red, black);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("<period: " + replace(period, "_", "\_"));
AddToLegend("<version: " + version);
AttachLegend();

//----------------------------------------------------------------------------------------------------

for (int ai : arms.keys)
	NewPadLabel(a_labels[ai]);

NewRow();

NewPadLabel("simulation");

for (int ai : arms.keys)
{
	NewPad("$x_{\rm tracking}\ung{mm}$", "$x_{\rm timing}\ung{mm}$");
	scale(Linear, Linear, Log);

	RootObject hist = RootGetObject(f, "multiRPPlots/" + arms[ai] + "/h2_x_timing_vs_x_tracking_ClCo");
	draw(hist);

	limits((0, 0), (20, 20), Crop);
}

NewRow();

if (draw_ref)
{
	NewPadLabel("LHC data (fill " + ref_data_fill + ")");

	for (int ai : arms.keys)
	{
		NewPad("$x_{\rm tracking}\ung{mm}$", "$x_{\rm timing}\ung{mm}$");
		scale(Linear, Linear, Log);

		RootObject hist = RootGetObject(ref_data_file, "multiRPPlots/" + arms[ai] + "/h2_x_timing_vs_x_tracking_ClCo");
		draw(hist);

		limits((0, 0), (20, 20), Crop);
	}
}

GShipout(vSkip=1mm);
