import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

string dir = "data/" + version + "/" + period;

string f = topDir + dir + "/test_acceptance.root";

//xTicksDef = LeftTicks(20., 10.);

xSizeDef = 8cm;

//----------------------------------------------------------------------------------------------------

for (int ai : arms.keys)
{
	NewPad("$\xi$", "acceptance");
	draw(RootGetObject(f, a_nr_rps[ai]+"/h_xi_rat"), "vl", blue, "near");
	draw(RootGetObject(f, a_fr_rps[ai]+"/h_xi_rat"), "vl", heavygreen, "far");

	draw(RootGetObject(f, a_nr_rps[ai]+","+a_fr_rps[ai]+"/h_xi_rat"), "vl", red+dashed, "near \& far");

	AttachLegend(a_sectors[ai]);
}

NewPad("$m\ung{GeV}$", "acceptance");
draw(RootGetObject(f, a_nr_rps[0]+","+a_nr_rps[1]+"/h_m_rat"), "vl", blue, "near");
draw(RootGetObject(f, a_fr_rps[0]+","+a_fr_rps[1]+"/h_m_rat"), "vl", heavygreen, "far");

draw(RootGetObject(f, a_nr_rps[0]+","+a_fr_rps[0]+","+a_nr_rps[1]+","+a_fr_rps[1]+"/h_m_rat"), "vl", red+dashed, "near \& far");

AttachLegend(a_sectors[0] + " \& " + a_sectors[1]);
