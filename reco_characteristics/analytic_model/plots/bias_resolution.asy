import root;
import pad_layout;

string topDir = "../../../";

string f_calc = "../calculate_bias_resolution.root";

string files[], f_labels[];
pen f_pens[];

files.push("data/version17-fixed-xangle-no-limits/2018_postTS2/proton_reco_resolution/resolution_th_Large_level_4_validation.root"); f_labels.push("MC simu (check hit=no, apertures=no)"); f_pens.push(heavygreen);
files.push("data/version17-fixed-xangle-no-check-hit/2018_postTS2/proton_reco_resolution/resolution_th_Large_level_4_validation.root"); f_labels.push("MC simu (check hit=no, apertures=yes)"); f_pens.push(magenta);
files.push("data/version17-fixed-xangle/2018_postTS2/proton_reco_resolution/resolution_th_Large_level_4_validation.root"); f_labels.push("MC simu (check hit=yes, apertures=yes)"); f_pens.push(red);

/*
files.push("data/version17-fixed-xangle/2018_postTS2/proton_reco_resolution/resolution_th_Large_level_1_validation.root"); f_labels.push("level1: y*"); f_pens.push(black);
files.push("data/version17-fixed-xangle/2018_postTS2/proton_reco_resolution/resolution_th_Large_level_2_validation.root"); f_labels.push("level2: + x*"); f_pens.push(heavygreen);
files.push("data/version17-fixed-xangle/2018_postTS2/proton_reco_resolution/resolution_th_Large_level_3_validation.root"); f_labels.push("level3: + beam div"); f_pens.push(cyan);
files.push("data/version17-fixed-xangle/2018_postTS2/proton_reco_resolution/resolution_th_Large_level_4_validation.root"); f_labels.push("level4: + det resol"); f_pens.push(magenta);
*/

string elements[];
elements.push("single rp/103");
elements.push("single rp/123");
elements.push("multi rp/1");

string quantities[], q_tags[];
quantities.push("bias"); q_tags.push("bias");
quantities.push("resolution"); q_tags.push("reso");

xTicksDef = LeftTicks(0.05, 0.01);

//----------------------------------------------------------------------------------------------------

NewPad(false);
for (int eli : elements.keys)
	NewPadLabel(elements[eli]);

for (int qi : quantities.keys)
{
	NewRow();

	NewPadLabel(quantities[qi]);

	for (int eli : elements.keys)
	{
		NewPad("$\xi_{\rm sim}$", "$\De\xi$");
	
		for (int fi : files.keys)
		{
			string on, opt;
			if (quantities[qi] == "bias") { on = "p_de_xi_vs_xi_simu"; opt = "d0,vl"; }
			if (quantities[qi] == "resolution") { on = "g_rms_de_xi_vs_xi_simu"; opt = "l,p,ieb"; }

			RootObject o = RootGetObject(topDir + files[fi], elements[eli] + "/" + on);

			if (quantities[qi] == "bias")
				draw(o, opt, f_pens[fi], f_labels[fi]);
			if (quantities[qi] == "resolution")
				draw(o, opt, f_pens[fi], mCi+2pt+f_pens[fi], f_labels[fi]);
		}

		string element_dash = replace(elements[eli], "/", "-");

		RootObject g_anal = RootGetObject(f_calc, element_dash + "/g_" + q_tags[qi], error=true);
		if (g_anal.valid)
			draw(g_anal, "l", blue, "anal.~calculation");

		if (qi == 1 && eli == 2)
			limits((0, 0), (0.25, 0.006), Crop);
		else
			xlimits(0., 0.25, Crop);
	}
}

frame fl = BuildLegend();

NewPad(false);
attach(fl);

GShipout(vSkip=1mm);
