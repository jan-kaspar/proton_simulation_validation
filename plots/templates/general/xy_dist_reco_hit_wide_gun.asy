import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

string f = topDir + "data/" + version + "/" + period + "/test_xy_pattern.root";

//----------------------------------------------------------------------------------------------------

for (int rpi : rps.keys)
{
	NewPad("$x\ung{mm}$", "$y\ung{mm}$");
	scale(Linear, Linear, Log);

	RootObject hist = RootGetObject(f, "RP " + rps[rpi] + "/h2_y_vs_x", error=false);

	if (!hist.valid)
		continue;

	hist.vExec("Rebin2D", 2, 2);

	//draw(hist);
	limits((0, -20), (40, 20), Crop);
	AttachLegend(rp_labels[rpi]);
}

GShipout(hSkip=1mm);
