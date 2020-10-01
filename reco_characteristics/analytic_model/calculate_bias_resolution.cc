#include <TFile.h>
#include <TGraph.h>
#include "TF2.h"

#include <string>
#include <vector>

#include "common_code.h"

using namespace std;

//----------------------------------------------------------------------------------------------------

void MakeSingleRPCurves(TFile *f_in, unsigned int rp, const string &label)
{
	TDirectory *d_top = gDirectory;
	gDirectory = d_top->mkdir(label.c_str());

	char buf[100];
	sprintf(buf, "%u", rp);

	TGraph *g_x_d_vs_xi = (TGraph *) f_in->Get((string(buf) + "/g_x_D_vs_xi").c_str());
	TGraph *g_L_x_vs_xi = (TGraph *) f_in->Get((string(buf) + "/g_L_x_vs_xi").c_str());
	TGraph *g_x_d_vs_xi_INV = Invert(g_x_d_vs_xi);

	TGraph *g_bias = new TGraph();
	TGraph *g_reso = new TGraph();

	for (double xi_sim = 0; xi_sim < 0.30; xi_sim += 0.005)
	{
		const double th_mean = -GetMeanThX(xi_sim); // in LHC coordinates
		bool th_mean_valid = (th_mean != -999E3);
		
		const double th_rms = GetRMSThX(xi_sim);

		const double x = g_x_d_vs_xi->Eval(xi_sim) + g_L_x_vs_xi->Eval(xi_sim) * th_mean;
		const double xi_rec = g_x_d_vs_xi_INV->Eval(x);

		const double ep = 1E-5;
		const double x0 = g_x_d_vs_xi->Eval(xi_sim);
		const double der = (g_x_d_vs_xi_INV->Eval(x0 + ep) - g_x_d_vs_xi_INV->Eval(x0)) / ep;

		const double xi_bias = xi_rec - xi_sim;
		const double xi_reso = fabs(der * g_L_x_vs_xi->Eval(xi_sim) * th_rms);

		int idx = g_bias->GetN();
		g_bias->SetPoint(idx, xi_sim, (th_mean_valid) ? xi_bias : 0.);
		g_reso->SetPoint(idx, xi_sim, (th_mean_valid) ? xi_reso : 0.);
	}

	g_bias->Write("g_bias");
	g_reso->Write("g_reso");

	gDirectory = d_top;
}

//----------------------------------------------------------------------------------------------------

void MakeMultiRPCurves(TFile *f_in, unsigned int rp_N, unsigned int rp_F, const string &label)
{
	TDirectory *d_top = gDirectory;
	gDirectory = d_top->mkdir(label.c_str());

	char rpn_N[100];
	sprintf(rpn_N, "%u", rp_N);
	char rpn_F[100];
	sprintf(rpn_F, "%u", rp_F);

	TGraph *g_x_d_vs_xi_N = (TGraph *) f_in->Get((string(rpn_N) + "/g_x_D_vs_xi").c_str());
	TGraph *g_L_x_vs_xi_N = (TGraph *) f_in->Get((string(rpn_N) + "/g_L_x_vs_xi").c_str());

	TGraph *g_x_d_vs_xi_F = (TGraph *) f_in->Get((string(rpn_F) + "/g_x_D_vs_xi").c_str());
	TGraph *g_L_x_vs_xi_F = (TGraph *) f_in->Get((string(rpn_F) + "/g_L_x_vs_xi").c_str());

	TGraph *g_bias = new TGraph();
	TGraph *g_reso = new TGraph();

	for (double xi_sim = 0; xi_sim < 0.30; xi_sim += 0.005)
	{
		const double th_mean = -GetMeanThX(xi_sim); // in LHC coordinates
		bool th_mean_valid = (th_mean != -999E3);

		double a_N, b_N, a_F, b_F;
		GetLinearApproximation(g_x_d_vs_xi_N, xi_sim, a_N, b_N);
		GetLinearApproximation(g_x_d_vs_xi_F, xi_sim, a_F, b_F);

		const double L_N = g_L_x_vs_xi_N->Eval(xi_sim);
		const double L_F = g_L_x_vs_xi_F->Eval(xi_sim);

		const double D = L_N*b_F - L_F*b_N;
		const double al_F = L_N / D;
		const double al_N = L_F / D;
		const double coef = sqrt(al_F*al_F + al_N*al_N);

		const double xi_bias = 0.;

		const double x_unc = 21E-4; // in cm

		const double xi_reso = coef * x_unc;

		int idx = g_bias->GetN();
		g_bias->SetPoint(idx, xi_sim, (th_mean_valid) ? xi_bias : 0.);
		g_reso->SetPoint(idx, xi_sim, (th_mean_valid) ? xi_reso : 0.);

	}

	g_bias->Write("g_bias");
	g_reso->Write("g_reso");

	gDirectory = d_top;
}

//----------------------------------------------------------------------------------------------------

int main()
{
	// TODO: switch to versoin17
	TFile *f_in = TFile::Open("../../data/version17-fixed-xangle/2018_postTS2/proton_reco_optics/optics_none_1_opt_fun.root");

	TFile *f_out = TFile::Open("calculate_bias_resolution.root", "recreate");

	MakeSingleRPCurves(f_in, 103, "single rp-103");
	MakeSingleRPCurves(f_in, 123, "single rp-123");

	MakeMultiRPCurves(f_in, 103, 123, "multi rp-1");

	delete f_out;

	return 0;
}
