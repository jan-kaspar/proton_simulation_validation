#include "TFile.h"
#include "TProfile.h"
#include "TGraphErrors.h"

#include <string>

using namespace std;

//----------------------------------------------------------------------------------------------------

TGraphErrors* MakeDiff(const TProfile *p1, const TProfile *p2)
{
	TGraphErrors *g = new TGraphErrors;

	for (int bi = 1; bi <= p1->GetNbinsX(); ++bi)
	{
		const double xi = p1->GetBinCenter(bi);
		const double xi_unc = p1->GetBinWidth(bi) / 2.;

		const double c1 = p1->GetBinContent(bi);
		const double c1_unc = p1->GetBinError(bi);

		const double c2 = p2->GetBinContent(bi);

		int idx = g->GetN();
		g->SetPoint(idx, xi, c1 - c2);
		g->SetPointError(idx, xi_unc, c1_unc);
	}

	return g;
}

//----------------------------------------------------------------------------------------------------

TGraphErrors* MakeCombination(const vector<TGraphErrors *> &vp)
{
	TGraphErrors *g = new TGraphErrors(*vp[0]);

	for (int i = 0; i <= g->GetN(); ++i)
	{
		double s2 = 0.;

		for (unsigned int ci = 0; ci < vp.size(); ++ci)
		{
			const double c = vp[ci]->GetY()[i];
			s2 += c*c;
		}

		g->GetY()[i] = sqrt(s2);
	}

	return g;
}

//----------------------------------------------------------------------------------------------------

int main(int argc, char **argv)
{
	// parse command line
	string period = argv[1];

	// config
	string dir = "./";

	struct Scenario
	{
		string name;
		string simu_eff, simu_none;
	};

	vector<Scenario> scenarios = {
		{ "alig-x-sym", "proton_reco_misalignment/misalignment_x_sym_validation.root", "proton_reco_misalignment/misalignment_none_validation.root" },
		{ "alig-x-asym", "proton_reco_misalignment/misalignment_x_asym_validation.root", "proton_reco_misalignment/misalignment_none_validation.root" },

		{ "opt-Lx", "proton_reco_optics/optics_Lx_1_validation.root", "proton_reco_optics/optics_none_1_validation.root" },
		{ "opt-Lpx", "proton_reco_optics/optics_Lpx_1_validation.root", "proton_reco_optics/optics_none_1_validation.root" },
		{ "opt-xd", "proton_reco_optics/optics_xd_1_validation.root", "proton_reco_optics/optics_none_1_validation.root" },
	};

	vector<string> elements = {
		"single rp/3",
		"single rp/103",
		"multi rp/0",
		"multi rp/1",
	};

	// prepare output
	TFile *f_out = TFile::Open("collect_systematics.root", "recreate");

	// process all elements
	for (const auto &el : elements)
	{
		string dn_el = el;
		dn_el.replace(dn_el.find('/'), 1, "-");

		printf("* %s\n", dn_el.c_str());

		TDirectory *d_el = f_out->mkdir(dn_el.c_str());

		vector<TGraphErrors *> graphs;

		for (const auto &sc : scenarios)
		{
			TFile *f_in_eff = TFile::Open((dir + sc.simu_eff).c_str());
			TFile *f_in_none = TFile::Open((dir + sc.simu_none).c_str());

			TProfile *p_eff = (TProfile *) f_in_eff->Get((el + "/p_de_xi_vs_xi_simu").c_str());
			TProfile *p_none = (TProfile *) f_in_none->Get((el + "/p_de_xi_vs_xi_simu").c_str());

			gDirectory = d_el;

			TGraphErrors *g_diff = MakeDiff(p_eff, p_none);
			g_diff->Write(sc.name.c_str());

			graphs.push_back(g_diff);
		}

		TGraphErrors *g_comb = MakeCombination(graphs);
		g_comb->Write("combined");
	}

	// clean up
	delete f_out;

	return 0;
}
