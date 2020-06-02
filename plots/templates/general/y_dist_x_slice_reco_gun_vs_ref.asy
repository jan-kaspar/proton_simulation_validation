import root;
import pad_layout;
include "../settings.asy";

string f = topDir + "data/" + version + "/" + period + "/test_acceptance_xy.root";

xTicksDef = LeftTicks(5., 1.);

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("period: " + replace(period, "_", "\_"));
AddToLegend("version: " + version);

AddToLegend("simulation", black);
AddToLegend("LHC data (fill " + ref_data_fill + ")", red+dashed);

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
			TH1_y_def = 1e-4;
			currentpad.xTicks = LeftTicks(0.5, 0.1);
		} else {
			TH1_use_y_def = false;
		}

		real x = 10.;

		RootObject hist_2D = RootGetObject(f, "RP " + rps[rpi] + "/h2_y_vs_x", error=false);
		RootObject hist_2D_ref = RootGetObject(ref_data_file, "RP " + rps[rpi] + "/h2_y_vs_x", error=false);

		if (!hist_2D.valid || !hist_2D_ref.valid)
			continue;

		int bin = hist_2D.oExec("GetXaxis").iExec("FindBin", x);
		RootObject hist = hist_2D.oExec("ProjectionY", rps[rpi] + "_py", bin, bin);

		draw(hist, "n,vl", black);

		int bin = hist_2D_ref.oExec("GetXaxis").iExec("FindBin", x);
		RootObject hist_ref = hist_2D_ref.oExec("ProjectionY", rps[rpi] + "_py_ref", bin, bin);

		draw(hist_ref, "n,vl", red+dashed);

		if (log)
			limits((min, 4e-4), (max, 1e0), Crop);
		else
			xlimits(min, max, Crop);
	}
}

//----------------------------------------------------------------------------------------------------

DrawOne("full range", -15, 15.);
DrawOne("high y", 3.5, 9.0, true);

GShipout(hSkip=1mm);
