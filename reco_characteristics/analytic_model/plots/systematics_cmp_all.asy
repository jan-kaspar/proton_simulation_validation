import root;
import pad_layout;

string topDir = "../../../";

string f_calc = "../calculate_systematics.root";

string f_simu = "data/version15-test8/2018_postTS2/collect_systematics.root";

string elements[];
elements.push("single rp-103");
elements.push("single rp-123");
elements.push("multi rp-1");

string scenarios[];
pen s_pens[];
scenarios.push("alig-x-sym"); s_pens.push(red);
scenarios.push("alig-x-asym"); s_pens.push(blue);

scenarios.push("opt-Lx"); s_pens.push(heavygreen);
scenarios.push("opt-Lpx"); s_pens.push(cyan);
scenarios.push("opt-xd"); s_pens.push(magenta);

TGraph_errorBar = None;

//----------------------------------------------------------------------------------------------------

for (int eli : elements.keys)
	NewPadLabel(elements[eli]);

NewRow();


for (int eli : elements.keys)
{
	NewPad("$\xi_{\rm sim}$", "$\De\xi$");

	AddToLegend("<points: MC simulation");
	AddToLegend("<lines: analytic calculation");
	
	for (int si : scenarios.keys)
	{
		RootObject o = RootGetObject(topDir + f_simu, elements[eli] + "/" + scenarios[si]);
		draw(o, "p", s_pens[si], mCi+1pt+s_pens[si], scenarios[si]);

		RootObject g_de_xi_th = RootGetObject(f_calc, scenarios[si] + "/" + elements[eli] + "/g_de_xi_th", error=true);
		if (g_de_xi_th.valid)
			draw(g_de_xi_th, "l", s_pens[si]);
	}

	limits((0, -0.02), (0.25, 0.01), Crop);
}

frame fl = BuildLegend();

NewPad(false);
attach(fl);

GShipout(vSkip=1mm);
