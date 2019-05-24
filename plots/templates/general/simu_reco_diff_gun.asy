import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

string dir = "results/" + version + "/" + period;

string f_beam = topDir + dir + "/test_smearing_effects_beam.root";
string f_sensor = topDir + dir + "/test_smearing_effects_sensor.root";

xTicksDef = LeftTicks(20., 10.);

string projections[];
projections.push("x");
projections.push("y");

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

for (int pi : projections.keys)
{
	NewRow();

	NewPadLabel(projections[pi]);

	for (int rpi : rps.keys)
	{
		NewPad("$" + projections[pi] + "_{\rm reco} - " + projections[pi] + "_{\rm simu}\ung{\mu m}$");

		//draw(scale(1e3, 1e3), RootGetObject(f_beam, "RP " + rps[rpi] + "/h_de_x"), "vl", blue);

		RootObject hist_sensor = RootGetObject(f_sensor, "RP " + rps[rpi] + "/h_de_x");
		draw(scale(1e3, 1), hist_sensor, "vl", red, format("RMS = %.1f", hist_sensor.rExec("GetRMS") * 1e3));

		xlimits(-50, +50, Crop);

		AttachLegend();
	}
}

//----------------------------------------------------------------------------------------------------

GShipout(hSkip=1mm, vSkip=3mm);
