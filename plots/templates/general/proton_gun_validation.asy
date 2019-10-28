import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../";

string dir = "data/" + version + "/" + period;

string f = topDir + dir + "/test_proton_gun.root";

//xTicksDef = LeftTicks(20., 10.);

//----------------------------------------------------------------------------------------------------

NewPad("$\xi$");
draw(RootGetObject(f, "h_xi"), "vl", red);

NewPad("$\th^*_x\ung{\mu rad}$");
RootObject hist = RootGetObject(f, "h_th_x");
draw(scale(1e6, 1), hist, "vl", red, format("RMS = %.1f", hist.rExec("GetRMS") * 1e6));
AttachLegend();

NewPad("$\th^*_y\ung{\mu rad}$");
RootObject hist = RootGetObject(f, "h_th_y");
draw(scale(1e6, 1), hist, "vl", red, format("RMS = %.1f", hist.rExec("GetRMS") * 1e6));
AttachLegend();

GShipout(hSkip=1mm, vSkip=3mm);
