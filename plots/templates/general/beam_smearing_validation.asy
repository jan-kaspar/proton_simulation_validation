import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

string dir = "data/" + version + "/" + period;

string f = topDir + dir + "/test_beam_smearing.root";

//xTicksDef = LeftTicks(20., 10.);

string sectors[];
pen s_pens[];
sectors.push("sector 45"); s_pens.push(red);
sectors.push("sector 56"); s_pens.push(blue);

//----------------------------------------------------------------------------------------------------

NewPad("$\De x^*\ung{\mu m}$");
RootObject hist = RootGetObject(f, "h_de_vtx_x");
draw(scale(1e3, 1), hist, "vl", red, format("RMS = %.1f", hist.rExec("GetRMS") * 1e3));
AttachLegend();

NewPad("$\De y^*\ung{\mu m}$");
RootObject hist = RootGetObject(f, "h_de_vtx_y");
draw(scale(1e3, 1), hist, "vl", red, format("RMS = %.1f", hist.rExec("GetRMS") * 1e3));
AttachLegend();

NewPad("$\De z^*\ung{mm}$");
RootObject hist = RootGetObject(f, "h_de_vtx_z");
draw(scale(1, 1), hist, "vl", red, format("RMS = %.1f", hist.rExec("GetRMS") * 1));
AttachLegend();

//----------------------------------------------------------------------------------------------------

NewRow();

NewPad("$\De \th^*_x\ung{\mu rad}$");
for (int si : sectors.keys)
{
	RootObject hist = RootGetObject(f, sectors[si] + "/h_de_th_x");
	draw(scale(1e6, 1), hist, "vl", s_pens[si], format(sectors[si] + ", RMS = %.1f", hist.rExec("GetRMS") * 1e6));
}
AttachLegend();

NewPad("$\De \th^*_y\ung{\mu rad}$");
for (int si : sectors.keys)
{
	RootObject hist = RootGetObject(f, sectors[si] + "/h_de_th_y");
	draw(scale(1e6, 1), hist, "vl", s_pens[si], format(sectors[si] + ", RMS = %.1f", hist.rExec("GetRMS") * 1e6));
}
AttachLegend();
