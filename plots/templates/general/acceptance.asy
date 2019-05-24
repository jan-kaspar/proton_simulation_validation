import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

string dir = "results/" + version + "/" + period;

string f = topDir + dir + "/test_acceptance.root";

//xTicksDef = LeftTicks(20., 10.);

xSizeDef = 8cm;

//----------------------------------------------------------------------------------------------------

for (int si : sectors.keys)
{
	NewPad("$\xi$", "acceptance");
	draw(RootGetObject(f, s_rpId_N[si]+"/h_xi_rat"), "vl", blue, "near");
	draw(RootGetObject(f, s_rpId_F[si]+"/h_xi_rat"), "vl", heavygreen, "far");

	draw(RootGetObject(f, s_rpId_N[si]+","+s_rpId_F[si]+"/h_xi_rat"), "vl", red+dashed, "near \& far");

	AttachLegend(sectors[si]);
}

NewPad("$m\ung{GeV}$", "acceptance");
draw(RootGetObject(f, s_rpId_N[0]+","+s_rpId_N[1]+"/h_m_rat"), "vl", blue, "near");
draw(RootGetObject(f, s_rpId_F[0]+","+s_rpId_F[1]+"/h_m_rat"), "vl", heavygreen, "far");

draw(RootGetObject(f, s_rpId_N[0]+","+s_rpId_F[0]+","+s_rpId_N[1]+","+s_rpId_F[1]+"/h_m_rat"), "vl", red+dashed, "near \& far");

AttachLegend(sectors[0] + " \& " + sectors[1]);
