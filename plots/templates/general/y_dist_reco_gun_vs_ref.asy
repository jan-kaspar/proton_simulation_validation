import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

string f = topDir + "data/" + version + "/" + period + "/test_acceptance_xy.root";

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
		{
			scale(Linear, Log);
			TH1_use_y_def = true;
			TH1_y_def = 1e-5;
			//currentpad.xTicks = LeftTicks(0.5, 0.1);
		} else {
			TH1_use_y_def = false;
		}

		RootObject hist = RootGetObject(f, "RP " + rps[rpi] + "/h_y", error=false);
		RootObject hist_ref = RootGetObject(ref_data_file, "RP " + rps[rpi] + "/h_y", error=false);

		if (!hist.valid || !hist_ref.valid)
			continue;

		draw(hist, "n,vl", black);
		draw(hist_ref, "n,vl", red);

		if (log)
			limits((min, 4e-5), (max, 1e0), Crop);
		else
			xlimits(min, max, Crop);
	}
}

//----------------------------------------------------------------------------------------------------

DrawOne("full range", -15, 15.);
DrawOne("high y", 2., 9., true);

GShipout(hSkip=1mm);
