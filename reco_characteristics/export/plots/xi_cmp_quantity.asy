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

string quantities[];
pen q_pens[];
quantities.push("bias"); q_pens.push(red);
quantities.push("resolution"); q_pens.push(blue);
quantities.push("systematics"); q_pens.push(heavygreen);

string version = "v17"; 
string file = "../reco_charactersitics_v17.root";

TGraph_errorBar = None;

//----------------------------------------------------------------------------------------------------

NewPad(false);

AddToLegend("<version: " + version);
for (int qi : quantities.keys)
{
	AddToLegend(quantities[qi], q_pens[qi]);
}
AttachLegend();

for (int eli : elements.keys)
	NewPadLabel(replace(elements[eli], "_", "\_"));

for (int pei : periods.keys)
{
	NewRow();

	NewPadLabel(replace(periods[pei], "_", "\_"));

	for (int eli : elements.keys)
	{
		NewPad("$\xi_{\rm simu}$", "effect on $\xi$");

		for (int qi : quantities.keys)
		{
			RootObject g = RootGetObject(file, periods[pei] + "/" + elements[eli] + "/xi/g_" + quantities[qi] + "_vs_xi", error=false);
			if (g.valid)
				draw(g, "l,p", q_pens[qi]);
		}

		limits((0, -0.050), (0.25, 0.050), Crop);
	}
}
