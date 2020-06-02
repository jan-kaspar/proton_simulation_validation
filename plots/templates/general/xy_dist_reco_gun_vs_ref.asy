import root;
import pad_layout;
include "../settings.asy";

string f = topDir + "data/" + version + "/" + period + "/test_acceptance_xy.root";

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("period: " + replace(period, "_", "\_"));
AddToLegend("version: " + version);

AttachLegend();

for (int rpi : rps.keys)
	NewPadLabel(rp_labels[rpi]);

//----------------------------------------------------------------------------------------------------

TH2_x_min = 0;
TH2_x_max = 30;

TH2_y_min = -15;
TH2_y_max = +15;

NewRow();

NewPadLabel("simulation");

for (int rpi : rps.keys)
{
	NewPad("$x\ung{mm}$");
	scale(Linear, Linear, Log);

	RootObject hist = RootGetObject(f, "RP " + rps[rpi] + "/h2_y_vs_x", error=true);

	if (!hist.valid)
		continue;

	if (rebin)
		hist.vExec("Rebin2D", 2, 2);

	draw(hist);

	limits((0, -15), (30, +15), Crop);
}

NewRow();

NewPadLabel("LHC data (fill " + ref_data_fill + ")");

for (int rpi : rps.keys)
{
	NewPad("$x\ung{mm}$");
	scale(Linear, Linear, Log);

	RootObject hist = RootGetObject(ref_data_file, "RP " + rps[rpi] + "/h2_y_vs_x", error=false);

	if (!hist.valid)
		continue;

	if (rebin)
		hist.vExec("Rebin2D", 2, 2);

	draw(hist);

	limits((0, -15), (30, +15), Crop);
}

GShipout(hSkip=1mm);
