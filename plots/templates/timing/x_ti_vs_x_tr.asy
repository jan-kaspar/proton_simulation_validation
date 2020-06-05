import root;
import pad_layout;
include "../settings.asy";

string f = topDir + "data/" + version + "/" + period  + "/test_proton_reco.root";

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

	RootObject hist = RootGetObject(f, "multiRPPlots/" + arms[ai] + "/h2_x_timing_vs_x_tracking_ClCo");
	draw(hist);

	limits((0, 0), (20, 20), Crop);
}

GShipout(vSkip=1mm);
