import root;
import pad_layout;
include "../settings.asy";

string f = topDir + "data/" + version + "/" + period + "/collect_systematics.root";

string rows[], r_labels[];
rows.push("single rp"); r_labels.push("single-RP");
rows.push("multi rp"); r_labels.push("multi-RP");

string cols[], c_rps[], c_labels[];
cols.push("0"); c_rps.push("3"); c_labels.push("sector 45/RP 3");
cols.push("1"); c_rps.push("103"); c_labels.push("sector 56/RP 103");

string contributions[];
contributions.push("alig-x-sym");
contributions.push("alig-x-asym");
contributions.push("opt-Lx");
contributions.push("opt-Lpx");
contributions.push("opt-xd");

TGraph_errorBar = None;

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
		NewPad("$\xi_{\rm simu}$", "$\De\xi$ or $\si(\xi)$");

		string element = "";
		if (rows[ri] == "single rp") element = "single rp-" + c_rps[ci];
		if (rows[ri] == "multi rp") element = "multi rp-" + cols[ci];

		for (int ci : contributions.keys)
		{
			RootObject obj = RootGetObject(f, element + "/" + contributions[ci]);
			pen p = StdPen(ci+1);
			draw(obj, "l,p,ds0", p, mCi+1pt+p);
		}

		RootObject obj = RootGetObject(f, element + "/combined");
		draw(obj, "l,p,ds0", black+1pt, mCi+1pt);

		limits((0, -0.025), (0.2, +0.025), Crop);
	}

	if (ri == 0)
	{
		NewPad(false);

		AddToLegend("<period: " + replace(period, "_", "\_"));
		AddToLegend("<version: " + version);

		AddToLegend("<contributions:");
		for (int ci : contributions.keys)
			AddToLegend(contributions[ci], StdPen(ci + 1));

		AddToLegend("<combination:");
		AddToLegend("in quadrature", black+1pt);
		AttachLegend(shift(0, 50) * BuildLegend());
	}
}

//----------------------------------------------------------------------------------------------------

GShipout(vSkip=1mm);
