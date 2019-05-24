import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

string f = topDir + "results/" + version + "/" + period + "/test_acceptance_xy.root";

//xTicksDef = LeftTicks(0.5, 0.1);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("period: " + replace(period, "_", "\_"));
AddToLegend("version: " + version);

AddToLegend("simulation", black);
AddToLegend("LHC data (fill " + ref_data_fill + ")", red);

AttachLegend();

for (int rpi : rps.keys)
	NewPadLabel(rp_labels[rpi]);

//----------------------------------------------------------------------------------------------------

void DrawOne(string label, real min, real max)
{
	NewRow();

	NewPadLabel(label);

	for (int rpi : rps.keys)
	{
		NewPad("$x\ung{mm}$");
		scale(Linear, Linear, Log);

		RootObject hist = RootGetObject(f, "RP " + rps[rpi] + "/h_x");
		RootObject hist_ref = RootGetObject(ref_data_file, "RP " + rps[rpi] + "/h_x");

		draw(hist, "n,vl", black);
		draw(hist_ref, "n,vl", red);

		xlimits(min, max, Crop);
	}
}

//----------------------------------------------------------------------------------------------------

DrawOne("full range", 0., 20.);
DrawOne("low x", 0., 4.);

GShipout(hSkip=1mm);
