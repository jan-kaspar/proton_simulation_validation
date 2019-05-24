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

void DrawOne(string label, real min, real max, bool log=false)
{
	NewRow();

	NewPadLabel(label);

	for (int rpi : rps.keys)
	{
		NewPad("$y\ung{mm}$");

		if (log)
			scale(Linear, Log);

		RootObject hist = RootGetObject(f, "RP " + rps[rpi] + "/h_y");
		RootObject hist_ref = RootGetObject(ref_data_file, "RP " + rps[rpi] + "/h_y");

		draw(hist, "n,vl", black);
		draw(hist_ref, "n,vl", red);

		xlimits(min, max, Crop);
	}
}

//----------------------------------------------------------------------------------------------------

DrawOne("full range", -15, 15.);
DrawOne("high y", 1., 8., true);

GShipout(hSkip=1mm);
