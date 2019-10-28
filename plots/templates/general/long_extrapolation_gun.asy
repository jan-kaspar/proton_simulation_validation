import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

string dir = "data/" + version + "/" + period;

string f = topDir + dir + "/test_long_extrapolation.root";

xTicksDef = LeftTicks(20., 10.);

string projections[];
projections.push("x");
projections.push("y");

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("period: " + replace(period, "_", "\_"));
AddToLegend("version: " + version);

AddToLegend("simulation", blue);

AttachLegend();

for (int rpi : rps.keys)
	NewPadLabel(rp_labels[rpi]);

//----------------------------------------------------------------------------------------------------

for (int pi : projections.keys)
{
	NewRow();

	NewPadLabel(projections[pi]);

	for (int rpi : rps.keys)
	{
		NewPad("$\De " + projections[pi] + "\ung{\mu m}$");

		RootObject hist = RootGetObject(f, "RP " + rps[rpi] + "/h_de_" + projections[pi], error=false);

		if (!hist.valid)
			continue;

		draw(scale(1e3, 1), hist, "vl", blue, format("RMS = %#.1f", hist.rExec("GetRMS") * 1e3));

		xlimits(-100, +100, Crop);

		AttachLegend();
	}
}

//----------------------------------------------------------------------------------------------------

GShipout(hSkip=1mm, vSkip=3mm);
