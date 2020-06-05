import root;
import pad_layout;
include "../settings.asy";

string f = topDir + "data/" + version + "/" + period + "/test_proton_reco.root";

string rows[];
rows.push("simulation");
rows.push("LHC data (fill " + ref_data_fill + ")");

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("period: " + replace(period, "_", "\_"));
AddToLegend("version: " + version);

AttachLegend();

for (int ai : arms.keys)
	NewPadLabel(a_labels[ai]);

//----------------------------------------------------------------------------------------------------

TH2_x_min = 0;
TH2_x_max = 0.25;

TH2_y_min = -300e-6;
TH2_y_max = +300e-6;

for (int ri : rows.keys)
{
	NewRow();
	
	if (rows[ri] != "simulation" && ref_data_fill == "NONE")
		continue;

	NewPadLabel(rows[ri]);

	for (int ai : arms.keys)
	{
		NewPad("$\xi$", "$\th^*_x\ung{\mu rad}$");
		scale(Linear, Linear, Log);

		string f_in = replace(ref_data_file, "output_tracks.root", "output.root");
		if (rows[ri] == "simulation")
			f_in = f;

		RootObject hist = RootGetObject(f_in, "multiRPPlots/" + arms[ai] + "/h2_th_x_vs_xi");

		if (rebin)
			hist.vExec("Rebin2D", 2, 2);

		draw(scale(1., 1e6), hist);

		limits((0, -300), (0.25, +300), Crop);
	}
}

GShipout(hSkip=1mm);
