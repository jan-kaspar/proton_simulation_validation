import root;
import pad_layout;

string topDir = "../../../";

string f_calc = "../calculate_systematics.root";

string files[], f_labels[];
pen f_pens[];
// test5: xangle=140, xi_max = 0.4, useEmpiricalApertures = checkIsHit = True
// test6: xangle=140, xi_max = 0.4, useEmpiricalApertures = checkIsHit = False
// test7: xangle=140, xi_max = 0.4, useEmpiricalApertures = True, checkIsHit = False
// test8: xangle=140, xi_max = 0.4, useEmpiricalApertures = checkIsHit = True; all systematics

files.push("data/version15-test5/2018_postTS2/collect_systematics.root"); f_labels.push("with limitations"); f_pens.push(blue);
files.push("data/version15-test6/2018_postTS2/collect_systematics.root"); f_labels.push("without limitations"); f_pens.push(red);
//files.push("data/version15-test7/2018_postTS2/collect_systematics.root"); f_labels.push("without limitations"); f_pens.push(magenta);

string elements[];
elements.push("single rp-103");
elements.push("single rp-123");
elements.push("multi rp-1");

//----------------------------------------------------------------------------------------------------

for (int eli : elements.keys)
	NewPadLabel(elements[eli]);

NewRow();


for (int eli : elements.keys)
{
	NewPad("$\xi_{\rm sim}$", "$\De\xi$");
	
	for (int fi : files.keys)
	{
		RootObject o = RootGetObject(topDir + files[fi], elements[eli] + "/opt-xd");
		draw(o, "l,p,ieb", f_pens[fi], mCi+2pt+f_pens[fi], f_labels[fi]);
	}

	draw((0, 0)--(0.3, 0.3*-0.08), black+dashed, "$-8\un{\%}$");

	RootObject g_de_xi_nt = RootGetObject(f_calc, "opt-xd/" + elements[eli] + "/g_de_xi_nt", error=false);
	if (g_de_xi_nt.valid)
		draw(g_de_xi_nt, "l", green, "anal.~prediction, without limitations");

	RootObject g_de_xi_th = RootGetObject(f_calc, "opt-xd/" + elements[eli] + "/g_de_xi_th", error=false);
	if (g_de_xi_th.valid)
		draw(g_de_xi_th, "l", cyan, "anal.~prediction, with limitations");
}

frame fl = BuildLegend();

NewPad(false);
attach(fl);

GShipout(vSkip=1mm);
