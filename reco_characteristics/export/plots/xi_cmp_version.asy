import root;
import pad_layout;

string periods[] = {
	"2016_preTS2",
	"2016_postTS2",

	"2017_preTS2",
	"2017_postTS2",

	"2018_preTS1",
	"2018_TS1_TS2",
	"2018_postTS2",
};

string elements[] = {
	"single rp-2",
	"single rp-3",
	"single rp-23",

	"single rp-102",
	"single rp-103",
	"single rp-123",

	"multi rp-0",
	"multi rp-1",
};

string characteristics[] = {
	"bias",
	"resolution",
	"systematics",
};

string versions[], v_files[];
pen v_pens[];
versions.push("v17-1E6"); v_files.push("../reco_charactersitics_v17-1E6.root"); v_pens.push(blue);
versions.push("v18"); v_files.push("../reco_charactersitics_v18.root"); v_pens.push(red+dashed);

TGraph_errorBar = None;

//----------------------------------------------------------------------------------------------------

for (string ch : characteristics)
{
	NewPad(false);
	for (int vi : versions.keys)
		AddToLegend(versions[vi], v_pens[vi]);
	AttachLegend();

	for (int eli : elements.keys)
		NewPadLabel(replace(elements[eli], "_", "\_"));

	for (int pei : periods.keys)
	{
		NewRow();

		NewPadLabel(replace(periods[pei], "_", "\_"));

		for (int eli : elements.keys)
		{
			NewPad("$\xi_{\rm simu}$", "$\xi$ " + ch);

			for (int vi : versions.keys)
			{
				RootObject g = RootGetObject(v_files[vi], periods[pei] + "/" + elements[eli] + "/xi/g_" + ch + "_vs_xi", error=false);
				if (g.valid)
					draw(g, "l,p", v_pens[vi]);
			}

			if (ch == "bias")
				limits((0, -0.025), (0.25, 0.025), Crop);
			else
				limits((0, 0), (0.25, 0.050), Crop);
		}
	}

	GShipout("xi_cmp_version_" + ch);
}
