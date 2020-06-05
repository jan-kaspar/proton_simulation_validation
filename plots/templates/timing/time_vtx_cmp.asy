import root;
import pad_layout;
include "../settings.asy";

string f = topDir + "data/" + version + "/" + period  + "/test_proton_reco_val.root";

//----------------------------------------------------------------------------------------------------

NewPad(false);
AddToLegend("<period: " + replace(period, "_", "\_"));
AddToLegend("<version: " + version);
AttachLegend();

//----------------------------------------------------------------------------------------------------

NewRow();

NewPadLabel("");

{
	NewPad("$t^*\ung{mm}$", "$(t_{56} + t_{45})/2\ung{mm}$");
	draw(RootGetObject(f, "double arm/h2_t_sh_vs_vtx_t"));

	NewPad("$(t_{56} + t_{45})/2 - t^*\ung{mm}$");
	draw(RootGetObject(f, "double arm/h_t_sh_minus_vtx_t"), "vl,lR", red);
	AttachLegend();
}

NewRow();

NewPadLabel("");

{
	NewPad("$z^*\ung{mm}$", "$(t_{56} - t_{45})/2\ung{mm}$");
	draw(RootGetObject(f, "double arm/h2_t_dh_vs_vtx_z"));

	NewPad("$(t_{56} - t_{45})/2 - z^*\ung{mm}$");
	draw(RootGetObject(f, "double arm/h_t_dh_minus_vtx_z"), "vl,lR", red);
	AttachLegend();
}

GShipout(vSkip=1mm);
