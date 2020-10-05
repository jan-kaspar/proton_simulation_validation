#include "TGraphErrors.h"
#include "TProfile.h"
#include "TFile.h"

#include <TGraph.h>
#include <vector>
#include <string>

using namespace std;

//----------------------------------------------------------------------------------------------------

unique_ptr<TGraphErrors> ProfileToGraph(const TProfile *p)
{
	unique_ptr<TGraphErrors> g(new TGraphErrors());

	for (int bi = 1; bi <= p->GetNbinsX(); ++bi)
	{
		const auto xi = p->GetBinCenter(bi);
		const auto w = p->GetBinWidth(bi);
		const auto v = p->GetBinContent(bi);
		const auto u = p->GetBinError(bi);

		int idx = g->GetN();
		g->SetPoint(idx, xi, v);
		g->SetPointError(idx, w/2., u);
	}

	return g;
}

//----------------------------------------------------------------------------------------------------

template <typename T>
void ZeroOutsideRange(T &g, double xi_min, double xi_max)
{
	for (int i = 0; i < g->GetN(); ++i)
	{
		const auto &xi = g->GetX()[i];
		if (xi < xi_min || xi > xi_max)
		{
			g->GetY()[i] = 0.;
			g->SetPointError(i, 0., 0.);
		}
	}
}

//----------------------------------------------------------------------------------------------------

int main()
{
	string topDir = "../../data/version17-1E6/";
	string output = "reco_charactersitics_v17-1E6.root";

	vector<string> periods = {
		"2016_preTS2",
		"2016_postTS2",

		"2017_preTS2",
		"2017_postTS2",

		"2018_preTS1",
		"2018_TS1_TS2",
		"2018_postTS2",
	};

	vector<string> elements = {
		"single rp/2",
		"single rp/3",
		"single rp/23",

		"single rp/102",
		"single rp/103",
		"single rp/123",

		"multi rp/0",
		"multi rp/1",
	};

	string file_bias_resolution = "proton_reco_resolution/resolution_th_Large_level_4_validation.root";
	string file_systematics = "collect_systematics.root";

	unique_ptr<TFile> f_out(new TFile(output.c_str(), "recreate"));

	for (const auto &period : periods)
	{
		printf("* %s\n", period.c_str());

		TDirectory *d_period = f_out->mkdir(period.c_str());

		unique_ptr<TFile> f_in_bias_resolution(TFile::Open((topDir + period + "/" + file_bias_resolution).c_str()));
		unique_ptr<TFile> f_in_systematics(TFile::Open((topDir + period + "/" + file_systematics).c_str()));

		if (!f_in_bias_resolution || !f_in_systematics)
		{
			printf("    ERROR: cannot load input files, skipping.\n");
			continue;
		}

		for (const auto &element : elements)
		{
			string element_dash = element;
			element_dash.replace(element.find("/"), 1, "-");

			TDirectory *d_element = d_period->mkdir(element_dash.c_str());

			{
				TDirectory *d_quantity = d_element->mkdir("xi");
				gDirectory = d_quantity;

				// get input
				TProfile *p_bias = (TProfile *) f_in_bias_resolution->Get((element + "/p_de_xi_vs_xi_simu").c_str());
				TGraphErrors *g_resolution = (TGraphErrors *) f_in_bias_resolution->Get((element + "/g_rms_de_xi_vs_xi_simu").c_str());
				TGraphErrors *g_systematics = (TGraphErrors *) f_in_systematics->Get((element_dash + "/combined").c_str());

				if (!p_bias || !g_resolution || !g_systematics)
				{
					printf("WARNING: cannot load data for element %s\n", element.c_str());
					continue;
				}

				// determine range
				double xi_min = 1E100, xi_max = -1E100;
				for (int bi = 1; bi < p_bias->GetNbinsX(); ++bi)
				{
					const double c = p_bias->GetBinCenter(bi);
					const double w = p_bias->GetBinWidth(bi);
					const double e = p_bias->GetBinEntries(bi);

					if (e > 10)
					{
						xi_min = min(xi_min, c-w/4.);
						xi_max = max(xi_max, c+w/4.);
					}
				}

				// bias and uncertainty
				auto g_bias = ProfileToGraph(p_bias);
				ZeroOutsideRange(g_bias, xi_min, xi_max);
				g_bias->SetTitle(";xi;bias");
				g_bias->Write("g_bias_vs_xi");

				ZeroOutsideRange(g_resolution, xi_min, xi_max);
				g_resolution->SetTitle(";#xi simu;resolution");
				g_resolution->Write("g_resolution_vs_xi");

				// systematics
				ZeroOutsideRange(g_systematics, xi_min, xi_max);
				g_systematics->SetTitle(";#xi simu;systematics");
				g_systematics->Write("g_systematics_vs_xi");
			}
		}
	}

	return 0;
}
