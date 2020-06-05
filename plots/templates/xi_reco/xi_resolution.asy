import root;
import pad_layout;
include "../settings.asy";

TGraph_errorBar = None;

string rows[], r_labels[];
rows.push("single rp"); r_labels.push("single-RP");
rows.push("multi rp"); r_labels.push("multi-RP");

string cols[], c_rps[], c_labels[];
cols.push("0"); c_rps.push("3"); c_labels.push("sector 45/RP 3");
cols.push("1"); c_rps.push("103"); c_labels.push("sector 56/RP 103");

string thetaSize = "Large";

string levels[];
string l_tags[];
pen l_pens[];
levels.push("$y^*$"); l_tags.push("level_1"); l_pens.push(black);
levels.push("$y^*$, $x^*$"); l_tags.push("level_2"); l_pens.push(red);
levels.push("$y^*$, $x^*$, beam. div."); l_tags.push("level_3"); l_pens.push(blue);
levels.push("$y^*$, $x^*$, beam. div., det.~resol."); l_tags.push("level_4"); l_pens.push(heavygreen);

xTicksDef = LeftTicks(0.05, 0.01);

//----------------------------------------------------------------------------------------------------

NewPad();
for (int ci : cols.keys)
{
	NewPadLabel(c_labels[ci]);
}

for (int ri : rows.keys)
{
	NewRow();

	NewPadLabel(r_labels[ri]);

	for (int ci : cols.keys)
	{
		NewPad("$\xi(\rm simu)$",  "RMS of $\xi({\rm reco}) - \xi({\rm simu})$");
		scale(Linear, Linear(true));

		for (int li : levels.keys)
		{
			string f = topDir + "data/" + version + "/" + period + "/proton_reco_resolution/resolution_th_" + thetaSize + "_" + l_tags[li] + "_validation.root";

			string bd;
			if (rows[ri] == "single rp") bd = rows[ri] + "/" + c_rps[ci];
			if (rows[ri] == "multi rp") bd = rows[ri] + "/" + cols[ci];

			RootObject o = RootGetObject(f, bd + "/g_rms_de_xi_vs_xi_simu", error=false);
			if (!o.valid)
				continue;

			pen p = l_pens[li];

			draw(o, "d0,l,p", p);
		}

		limits((0., 0.), (0.2, +0.05), Crop);
	}

	if (ri == 0)
	{
		NewPad(false);

		AddToLegend("<period: " + replace(period, "_", "\_"));
		AddToLegend("<version: " + version);

		for (int li : levels.keys)
		{
			AddToLegend(levels[li], l_pens[li]);
		}

		AttachLegend();
	}
}

GShipout(vSkip=1mm);
