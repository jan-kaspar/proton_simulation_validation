import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

string f = topDir + "results/" + version + "/" + period + "/test_xy_pattern.root";

//----------------------------------------------------------------------------------------------------

for (int rpi : rps.keys)
{
	NewPad("$x\ung{mm}$", "$y\ung{mm}$");
	scale(Linear, Linear, Log);

	RootObject hist = RootGetObject(f, "RP " + rps[rpi] + "/h2_y_vs_x");
	hist.vExec("Rebin2D", 3, 3);

	draw(hist);
	limits((0, -25), (50, 25), Crop);
	AttachLegend(rp_labels[rpi]);
}

GShipout(hSkip=1mm);
