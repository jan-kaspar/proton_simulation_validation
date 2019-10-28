import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

string f = topDir + "data/" + version + "/" + period + "/test_acceptance_xy.root";

xTicksDef = LeftTicks(5., 1.);

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
		NewPad("$x\ung{mm}$");

		if (log)
		{
			//scale(Linear, Log);
			//TH1_use_y_def = true;
			//TH1_y_def = 1e-4;
			currentpad.xTicks = LeftTicks(0.5, 0.1);
		}

		RootObject hist = RootGetObject(f, "RP " + rps[rpi] + "/h_x", error=false);
		RootObject hist_ref = RootGetObject(ref_data_file, "RP " + rps[rpi] + "/h_x", error=false);

		if (!hist.valid || !hist_ref.valid)
			continue;

		draw(hist, "n,vl", black);
		draw(hist_ref, "n,vl", red);

		xlimits(min, max, Crop);
	}
}

//----------------------------------------------------------------------------------------------------

DrawOne("full range", 0., 20.);
DrawOne("low x", 1., 4., true);

GShipout(hSkip=1mm);
