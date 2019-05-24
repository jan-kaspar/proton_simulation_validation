import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

string dir = "results/" + version + "/" + period;

string f_beam = topDir + dir + "/test_smearing_effects_beam.root";
string f_sensor = topDir + dir + "/test_smearing_effects_sensor.root";

xTicksDef = LeftTicks(20., 10.);

//----------------------------------------------------------------------------------------------------

for (int rpi : rps.keys)
{
	NewPad("$x_{\rm reco} - x_{\rm simu}\ung{\mu m}$");
	scale(Linear, Linear, Log);

	draw(scale(1e3, 1e3), RootGetObject(f_beam, "RP " + rps[rpi] + "/h_de_x"), "vl", blue);
	draw(scale(1e3, 1e3), RootGetObject(f_sensor, "RP " + rps[rpi] + "/h_de_x"), "vl", red);

	xlimits(-50, +50, Crop);

	AttachLegend(rp_labels[rpi]);
}

//----------------------------------------------------------------------------------------------------
NewRow();

for (int rpi : rps.keys)
{
	NewPad("$y_{\rm reco} - y_{\rm simu}\ung{\mu m}$");
	scale(Linear, Linear, Log);

	draw(scale(1e3, 1e3), RootGetObject(f_beam, "RP " + rps[rpi] + "/h_de_y"), "vl", blue);
	draw(scale(1e3, 1e3), RootGetObject(f_sensor, "RP " + rps[rpi] + "/h_de_y"), "vl", red);

	xlimits(-50, +50, Crop);

	AttachLegend(rp_labels[rpi]);
}

//----------------------------------------------------------------------------------------------------

GShipout(hSkip=1mm, vSkip=3mm);
