import root;
import pad_layout;

include "../settings.asy";

TGraph_errorBar = None;

string cols[];
string c_tags[];
cols.push("sector 45"); c_tags.push("0");
cols.push("sector 56"); c_tags.push("1");

string rows[];
string r_tags[], r_labs[];
rows.push("\hbox{bias}"); r_tags.push("p_de_"); r_labs.push("mean");
rows.push("\hbox{resolution}"); r_tags.push("g_rms_de_"); r_labs.push("RMS");

string thetaSize = "Large";

string levels[];
string l_tags[];
pen l_pens[];
levels.push("$y^*$"); l_tags.push("level_1"); l_pens.push(black);
levels.push("$y^*$, $x^*$"); l_tags.push("level_2"); l_pens.push(red);
levels.push("$y^*$, $x^*$, beam. div."); l_tags.push("level_3"); l_pens.push(blue);
levels.push("$y^*$, $x^*$, beam. div., det.~resol."); l_tags.push("level_4"); l_pens.push(heavygreen);

string quantities[];
string q_labels[];
string q_units[];
real q_scales[], q_mean_lims[], q_RMS_lims[];
//quantities.push("xi"); q_labels.push("\xi"); q_units.push(""); q_scales.push(1.); q_mean_lims.push(0.001); q_RMS_lims.push(0.002);
//quantities.push("th_x"); q_labels.push("\th^*_x"); q_units.push("\ung{\mu rad}"); q_scales.push(1e6); q_mean_lims.push(15.); q_RMS_lims.push(30.);
//quantities.push("th_y"); q_labels.push("\th^*_y"); q_units.push("\ung{\mu rad}"); q_scales.push(1e6); q_mean_lims.push(15.); q_RMS_lims.push(30.);
//quantities.push("vtx_y"); q_labels.push("y^*"); q_units.push("\ung{\mu m}"); q_scales.push(1e3); q_mean_lims.push(100.); q_RMS_lims.push(200.);
quantities.push("t"); q_labels.push("|t|"); q_units.push("\ung{GeV^2}"); q_scales.push(1.); q_mean_lims.push(0.5); q_RMS_lims.push(1.);

xTicksDef = LeftTicks(1., 0.5);

//----------------------------------------------------------------------------------------------------

for (int qi : quantities.keys)
{
	write("* " + quantities[qi]);

	NewPad();
	for (int ci : cols.keys)
	{
		NewPad(false);
		label("{\SetFontSizesXX " + cols[ci] + "}");
	}
	
	for (int ri : rows.keys)
	{
		NewRow();
	
		NewPad(false);
		label("\vbox{\SetFontSizesXX " + rows[ri] + "}");
	
		for (int ci : cols.keys)
		{
			string ql = q_labels[qi];
			NewPad("$|t|(\rm simu)\ung{GeV^2}$",  r_labs[ri] + " of $"+ql+"({\rm reco}) - "+ql+"({\rm simu}) " + q_units[qi] + "$");
			scale(Linear, Linear(true));
	
			for (int li : levels.keys)
			{
				string f = topDir + "data/" + version + "/" + period + "/proton_reco_resolution/resolution_th_" + thetaSize + "_" + l_tags[li] + "_validation.root";
				string o = "multi rp/" + c_tags[ci] + "/" + r_tags[ri] + quantities[qi]+"_vs_t_simu";
	
				pen p = l_pens[li];

				RootObject obj = RootGetObject(f, o, error=false);
				if (!obj.valid)
					continue;

				if (r_labs[ri] == "mean")
					draw(scale(1., q_scales[qi]), obj, "d0,eb", p);
				if (r_labs[ri] == "RMS")
					draw(scale(1., q_scales[qi]), obj, "d0,l,p", p, mCi+2pt+p);
			}
	
			if (r_labs[ri] == "mean")
				limits((0., -q_mean_lims[qi]), (5., +q_mean_lims[qi]), Crop);
			if (r_labs[ri] == "RMS")
				limits((0., 0.), (5., q_RMS_lims[qi]), Crop);
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

	GShipout("bias_resolution_vs_t_" + quantities[qi], vSkip=0mm);
}
