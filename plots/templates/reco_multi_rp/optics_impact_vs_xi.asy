import root;
import pad_layout;

include "../settings.asy";

string topDir = "../../../";

TGraph_errorBar = None;

string cols[];
string c_tags[];
cols.push("sector 45"); c_tags.push("0");
cols.push("sector 56"); c_tags.push("1");

string scenarios[], s_tags[];
pen s_pens[];
scenarios.push("none"); s_tags.push("none_1"); s_pens.push(black);
scenarios.push("xd, +1"); s_tags.push("xd_1"); s_pens.push(red);
scenarios.push("Lx, +1"); s_tags.push("Lx_1"); s_pens.push(blue);
scenarios.push("Lpx, +1"); s_tags.push("Lpx_1"); s_pens.push(heavygreen);
scenarios.push("Lx-scale, +2"); s_tags.push("Lx-scale_2"); s_pens.push(magenta+dashed);

string quantities[];
string q_labels[];
string q_units[];
real q_scales[], q_limits[];
quantities.push("xi"); q_labels.push("\xi"); q_units.push(""); q_scales.push(1.); q_limits.push(0.005);
quantities.push("th_x"); q_labels.push("\th^*_x"); q_units.push("\ung{\mu rad}"); q_scales.push(1e6); q_limits.push(10);
quantities.push("th_y"); q_labels.push("\th^*_y"); q_units.push("\ung{\mu rad}"); q_scales.push(1e6); q_limits.push(15);
quantities.push("vtx_y"); q_labels.push("y^*"); q_units.push("\ung{\mu m}"); q_scales.push(1e3); q_limits.push(200);
quantities.push("t"); q_labels.push("|t|"); q_units.push("\ung{GeV^2}"); q_scales.push(1.); q_limits.push(0.5);

xTicksDef = LeftTicks(0.05, 0.01);

//----------------------------------------------------------------------------------------------------

for (int qi : quantities.keys)
{
	write("* " + quantities[qi]);

	for (int ci : cols.keys)
	{
		NewPad(false);
		label("{\SetFontSizesXX " + cols[ci] + "}");
	}

	NewRow();
	
	for (int ci : cols.keys)
	{
		string ql = q_labels[qi];
		NewPad("$\xi(\rm simu)$", "mean of $"+ql+"({\rm reco}) - "+ql+"({\rm simu}) " + q_units[qi] + "$");
		scale(Linear, Linear(true));
	
		for (int si : scenarios.keys)
		{
			string s_tag = s_tags[si];

			string f = topDir + "data/" + version + "/" + period + "/proton_reco_optics/optics_" + s_tag + "_validation.root";

			string o = "multi rp/" + c_tags[ci] + "/p_de_"+quantities[qi]+"_vs_xi_simu";
	
			pen p = s_pens[si];

			RootObject obj = RootGetObject(f, o, error=false);
			if (!obj.valid)
				continue;
	
			draw(scale(1., q_scales[qi]), obj, "d0,eb", p);
		}
	
		limits((0., -q_limits[qi]), (0.21, +q_limits[qi]), Crop);
	}

	NewPad(false);
	
	for (int si : scenarios.keys)
	{
		AddToLegend(scenarios[si], s_pens[si]);
	}
	
	AttachLegend();

	GShipout("optics_impact_vs_xi_" + quantities[qi], vSkip=0mm);
}
