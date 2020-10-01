#include <TFile.h>
#include <TGraph.h>
#include "TF2.h"

#include <string>
#include <vector>

#include "common_code.h"

using namespace std;

//----------------------------------------------------------------------------------------------------

void MakeSingleRPCurvesOpt(TFile *f_in_none, TFile *f_in_scen, unsigned int rp, const string &label)
{
	TDirectory *d_top = gDirectory;
	gDirectory = d_top->mkdir(label.c_str());

	char buf[100];
	sprintf(buf, "%u", rp);

	TGraph *g_x_d_vs_xi_none = (TGraph *) f_in_none->Get((string(buf) + "/g_x_D_vs_xi").c_str());
	TGraph *g_L_x_vs_xi_none = (TGraph *) f_in_none->Get((string(buf) + "/g_L_x_vs_xi").c_str());
	TGraph *g_x_d_vs_xi_none_INV = Invert(g_x_d_vs_xi_none);

	TGraph *g_x_d_vs_xi_scen = (TGraph *) f_in_scen->Get((string(buf) + "/g_x_D_vs_xi").c_str());
	TGraph *g_x_d_vs_xi_scen_INV = Invert(g_x_d_vs_xi_scen);

	TGraph *g_de_xi_nt = new TGraph();
	TGraph *g_de_xi_th = new TGraph();

	for (double xi_sim = 0; xi_sim < 0.30; xi_sim += 0.005)
	{
		const double th_mean = -GetMeanThX(xi_sim); // in LHC coordinates
		bool th_mean_valid = (th_mean != -999E3);

		const double x_nt = g_x_d_vs_xi_none->Eval(xi_sim);
		const double x_th = g_x_d_vs_xi_none->Eval(xi_sim) + g_L_x_vs_xi_none->Eval(xi_sim) * th_mean;

		const double xi_idr_nt = g_x_d_vs_xi_none_INV->Eval(x_nt);
		const double xi_idr_th = g_x_d_vs_xi_none_INV->Eval(x_th);

		const double xi_rec_nt = g_x_d_vs_xi_scen_INV->Eval(x_nt);
		const double xi_rec_th = g_x_d_vs_xi_scen_INV->Eval(x_th);

		int idx = g_de_xi_nt->GetN();
		g_de_xi_nt->SetPoint(idx, xi_sim, xi_rec_nt - xi_idr_nt);
		g_de_xi_th->SetPoint(idx, xi_sim, (th_mean_valid) ? xi_rec_th - xi_idr_th : 0.);
	}

	g_de_xi_nt->Write("g_de_xi_nt");
	g_de_xi_th->Write("g_de_xi_th");

	gDirectory = d_top;
}

//----------------------------------------------------------------------------------------------------

void MakeMultiRPCurvesOpt(TFile *f_in_none, TFile *f_in_scen, unsigned int rp_N, unsigned int rp_F, const string &label)
{
	TDirectory *d_top = gDirectory;
	gDirectory = d_top->mkdir(label.c_str());

	char rpn_N[100];
	sprintf(rpn_N, "%u", rp_N);
	char rpn_F[100];
	sprintf(rpn_F, "%u", rp_F);

	TGraph *g_x_d_vs_xi_none_N = (TGraph *) f_in_none->Get((string(rpn_N) + "/g_x_D_vs_xi").c_str());
	TGraph *g_L_x_vs_xi_none_N = (TGraph *) f_in_none->Get((string(rpn_N) + "/g_L_x_vs_xi").c_str());
	TGraph *g_x_d_vs_xi_scen_N = (TGraph *) f_in_scen->Get((string(rpn_N) + "/g_x_D_vs_xi").c_str());
	TGraph *g_L_x_vs_xi_scen_N = (TGraph *) f_in_scen->Get((string(rpn_N) + "/g_L_x_vs_xi").c_str());

	TGraph *g_x_d_vs_xi_none_F = (TGraph *) f_in_none->Get((string(rpn_F) + "/g_x_D_vs_xi").c_str());
	TGraph *g_L_x_vs_xi_none_F = (TGraph *) f_in_none->Get((string(rpn_F) + "/g_L_x_vs_xi").c_str());
	TGraph *g_x_d_vs_xi_scen_F = (TGraph *) f_in_scen->Get((string(rpn_F) + "/g_x_D_vs_xi").c_str());
	TGraph *g_L_x_vs_xi_scen_F = (TGraph *) f_in_scen->Get((string(rpn_F) + "/g_L_x_vs_xi").c_str());

	TGraph *g_x_d_vs_xi_scen_N_INV = Invert(g_x_d_vs_xi_scen_N);

	TGraph *g_de_xi_nt = new TGraph();
	TGraph *g_de_xi_th = new TGraph();

	for (double xi_sim = 0; xi_sim < 0.30; xi_sim += 0.005)
	{
		const double th_mean = -GetMeanThX(xi_sim); // in LHC coordinates
		bool th_mean_valid = (th_mean != -999E3);

		// "simulation" of hits
		const double x_N_nt = g_x_d_vs_xi_none_N->Eval(xi_sim);
		const double x_F_nt = g_x_d_vs_xi_none_F->Eval(xi_sim);

		const double x_N_th = g_x_d_vs_xi_none_N->Eval(xi_sim) + g_L_x_vs_xi_none_N->Eval(xi_sim) * th_mean;
		const double x_F_th = g_x_d_vs_xi_none_F->Eval(xi_sim) + g_L_x_vs_xi_none_F->Eval(xi_sim) * th_mean;

		// "ideal reconstruction"
		double xi_idr_nt, xi_idr_th;
		{
			const double xi_rec_app = xi_sim;

			double a_N, b_N, a_F, b_F;
			GetLinearApproximation(g_x_d_vs_xi_none_N, xi_rec_app, a_N, b_N);
			GetLinearApproximation(g_x_d_vs_xi_none_F, xi_rec_app, a_F, b_F);

			const double L_N = g_L_x_vs_xi_none_N->Eval(xi_rec_app);
			const double L_F = g_L_x_vs_xi_none_F->Eval(xi_rec_app);

			const double R_N_nt = x_N_nt - a_N;
			const double R_F_nt = x_F_nt - a_F;
			xi_idr_nt = (L_N * R_F_nt - L_F * R_N_nt) / (L_N * b_F - L_F * b_N);

			const double R_N_th = x_N_th - a_N;
			const double R_F_th = x_F_th - a_F;
			xi_idr_th = (L_N * R_F_th - L_F * R_N_th) / (L_N * b_F - L_F * b_N);
		}

		// "perturbed" reconstruction
		double xi_rec_nt, xi_rec_th;
		{
			double xi_rec_app = g_x_d_vs_xi_scen_N_INV->Eval(x_N_nt);

			unsigned int n_iterations = 3;

			xi_rec_nt = xi_rec_app;
			for (unsigned int it = 0; it < n_iterations; ++it)
			{
				double a_N, b_N, a_F, b_F;
				GetLinearApproximation(g_x_d_vs_xi_scen_N, xi_rec_nt, a_N, b_N);
				GetLinearApproximation(g_x_d_vs_xi_scen_F, xi_rec_nt, a_F, b_F);

				const double L_N = g_L_x_vs_xi_scen_N->Eval(xi_rec_nt);
				const double L_F = g_L_x_vs_xi_scen_F->Eval(xi_rec_nt);

				const double R_N_nt = x_N_nt - a_N;
				const double R_F_nt = x_F_nt - a_F;
				xi_rec_nt = (L_N * R_F_nt - L_F * R_N_nt) / (L_N * b_F - L_F * b_N);
			}

			xi_rec_th = xi_rec_app;
			for (unsigned int it = 0; it < n_iterations; ++it)
			{
				double a_N, b_N, a_F, b_F;
				GetLinearApproximation(g_x_d_vs_xi_scen_N, xi_rec_th, a_N, b_N);
				GetLinearApproximation(g_x_d_vs_xi_scen_F, xi_rec_th, a_F, b_F);

				const double L_N = g_L_x_vs_xi_scen_N->Eval(xi_rec_th);
				const double L_F = g_L_x_vs_xi_scen_F->Eval(xi_rec_th);

				const double R_N_th = x_N_th - a_N;
				const double R_F_th = x_F_th - a_F;
				xi_rec_th = (L_N * R_F_th - L_F * R_N_th) / (L_N * b_F - L_F * b_N);
			}
		}

		int idx = g_de_xi_nt->GetN();
		g_de_xi_nt->SetPoint(idx, xi_sim, xi_rec_nt - xi_idr_nt);
		g_de_xi_th->SetPoint(idx, xi_sim, (th_mean_valid) ? xi_rec_th - xi_idr_th : 0.);
	}

	g_de_xi_nt->Write("g_de_xi_nt");
	g_de_xi_th->Write("g_de_xi_th");

	gDirectory = d_top;
}
//----------------------------------------------------------------------------------------------------

void MakeMultiRPCurvesAlig(TFile *f_in_opt, unsigned int rp_N, unsigned int rp_F, double de_x_N, double de_x_F, const string &label)
{
	TDirectory *d_top = gDirectory;
	gDirectory = d_top->mkdir(label.c_str());

	char rpn_N[100];
	sprintf(rpn_N, "%u", rp_N);
	char rpn_F[100];
	sprintf(rpn_F, "%u", rp_F);

	TGraph *g_x_d_vs_xi_N = (TGraph *) f_in_opt->Get((string(rpn_N) + "/g_x_D_vs_xi").c_str());
	TGraph *g_L_x_vs_xi_N = (TGraph *) f_in_opt->Get((string(rpn_N) + "/g_L_x_vs_xi").c_str());

	TGraph *g_x_d_vs_xi_F = (TGraph *) f_in_opt->Get((string(rpn_F) + "/g_x_D_vs_xi").c_str());
	TGraph *g_L_x_vs_xi_F = (TGraph *) f_in_opt->Get((string(rpn_F) + "/g_L_x_vs_xi").c_str());

	TGraph *g_x_d_vs_xi_N_INV = Invert(g_x_d_vs_xi_N);

	TGraph *g_de_xi_nt = new TGraph();
	TGraph *g_de_xi_th = new TGraph();

	for (double xi_sim = 0; xi_sim < 0.30; xi_sim += 0.005)
	{
		const double th_mean = -GetMeanThX(xi_sim); // in LHC coordinates
		bool th_mean_valid = (th_mean != -999E3);

		// "simulation" of hits
		const double x_N_nt = g_x_d_vs_xi_N->Eval(xi_sim);
		const double x_F_nt = g_x_d_vs_xi_F->Eval(xi_sim);

		const double x_N_th = g_x_d_vs_xi_N->Eval(xi_sim) + g_L_x_vs_xi_N->Eval(xi_sim) * th_mean;
		const double x_F_th = g_x_d_vs_xi_F->Eval(xi_sim) + g_L_x_vs_xi_F->Eval(xi_sim) * th_mean;

		// "ideal reconstruction"
		double xi_idr_nt, xi_idr_th;
		{
			const double xi_rec_app = xi_sim;

			double a_N, b_N, a_F, b_F;
			GetLinearApproximation(g_x_d_vs_xi_N, xi_rec_app, a_N, b_N);
			GetLinearApproximation(g_x_d_vs_xi_F, xi_rec_app, a_F, b_F);

			const double L_N = g_L_x_vs_xi_N->Eval(xi_rec_app);
			const double L_F = g_L_x_vs_xi_F->Eval(xi_rec_app);

			const double R_N_nt = x_N_nt - a_N;
			const double R_F_nt = x_F_nt - a_F;
			xi_idr_nt = (L_N * R_F_nt - L_F * R_N_nt) / (L_N * b_F - L_F * b_N);

			const double R_N_th = x_N_th - a_N;
			const double R_F_th = x_F_th - a_F;
			xi_idr_th = (L_N * R_F_th - L_F * R_N_th) / (L_N * b_F - L_F * b_N);
		}

		// "perturbed" reconstruction
		double xi_rec_nt, xi_rec_th;
		{
			const double xi_rec_app = g_x_d_vs_xi_N_INV->Eval(x_N_nt - de_x_N);

			unsigned int n_iterations = 3;

			xi_rec_nt = xi_rec_app;
			for (unsigned int it = 0; it < n_iterations; ++it)
			{
				double a_N, b_N, a_F, b_F;
				GetLinearApproximation(g_x_d_vs_xi_N, xi_rec_nt, a_N, b_N);
				GetLinearApproximation(g_x_d_vs_xi_F, xi_rec_nt, a_F, b_F);

				const double L_N = g_L_x_vs_xi_N->Eval(xi_rec_nt);
				const double L_F = g_L_x_vs_xi_F->Eval(xi_rec_nt);

				const double R_N_nt = x_N_nt - de_x_N - a_N;
				const double R_F_nt = x_F_nt - de_x_F - a_F;
				xi_rec_nt = (L_N * R_F_nt - L_F * R_N_nt) / (L_N * b_F - L_F * b_N);
			}

			xi_rec_th = xi_rec_app;
			for (unsigned int it = 0; it < n_iterations; ++it)
			{
				double a_N, b_N, a_F, b_F;
				GetLinearApproximation(g_x_d_vs_xi_N, xi_rec_th, a_N, b_N);
				GetLinearApproximation(g_x_d_vs_xi_F, xi_rec_th, a_F, b_F);

				const double L_N = g_L_x_vs_xi_N->Eval(xi_rec_th);
				const double L_F = g_L_x_vs_xi_F->Eval(xi_rec_th);

				const double R_N_th = x_N_th - de_x_N - a_N;
				const double R_F_th = x_F_th - de_x_F - a_F;
				xi_rec_th = (L_N * R_F_th - L_F * R_N_th) / (L_N * b_F - L_F * b_N);
			}
		}

		int idx = g_de_xi_nt->GetN();
		g_de_xi_nt->SetPoint(idx, xi_sim, xi_rec_nt - xi_idr_nt);
		g_de_xi_th->SetPoint(idx, xi_sim, (th_mean_valid) ? xi_rec_th - xi_idr_th : 0.);
	}

	g_de_xi_nt->Write("g_de_xi_nt");
	g_de_xi_th->Write("g_de_xi_th");

	gDirectory = d_top;
}

//----------------------------------------------------------------------------------------------------

void MakeSingleRPCurvesAlig(TFile *f_in_opt, unsigned int rp, double de_x, const string &label)
{
	TDirectory *d_top = gDirectory;
	gDirectory = d_top->mkdir(label.c_str());

	char buf[100];
	sprintf(buf, "%u", rp);

	TGraph *g_x_d_vs_xi = (TGraph *) f_in_opt->Get((string(buf) + "/g_x_D_vs_xi").c_str());
	TGraph *g_L_x_vs_xi = (TGraph *) f_in_opt->Get((string(buf) + "/g_L_x_vs_xi").c_str());
	TGraph *g_x_d_vs_xi_INV = Invert(g_x_d_vs_xi);

	TGraph *g_de_xi_nt = new TGraph();
	TGraph *g_de_xi_th = new TGraph();

	for (double xi_sim = 0; xi_sim < 0.30; xi_sim += 0.005)
	{
		const double th_mean = -GetMeanThX(xi_sim); // in LHC coordinates
		bool th_mean_valid = (th_mean != -999E3);

		const double x_nt = g_x_d_vs_xi->Eval(xi_sim);
		const double x_th = g_x_d_vs_xi->Eval(xi_sim) + g_L_x_vs_xi->Eval(xi_sim) * th_mean;

		const double xi_idr_nt = g_x_d_vs_xi_INV->Eval(x_nt);
		const double xi_idr_th = g_x_d_vs_xi_INV->Eval(x_th);

		const double xi_rec_nt = g_x_d_vs_xi_INV->Eval(x_nt - de_x);
		const double xi_rec_th = g_x_d_vs_xi_INV->Eval(x_th - de_x);

		int idx = g_de_xi_nt->GetN();
		g_de_xi_nt->SetPoint(idx, xi_sim, xi_rec_nt - xi_idr_nt);
		g_de_xi_th->SetPoint(idx, xi_sim, (th_mean_valid) ? xi_rec_th - xi_idr_th : 0.);
	}

	g_de_xi_nt->Write("g_de_xi_nt");
	g_de_xi_th->Write("g_de_xi_th");

	gDirectory = d_top;
}

//----------------------------------------------------------------------------------------------------

int main()
{
	TFile *f_out = TFile::Open("calculate_systematics.root", "recreate");

	// optics scenarios
	map<string, string> opt_scenarios = {
		{ "xd_1", "opt-xd" },
		{ "Lx_1", "opt-Lx" },
		{ "Lpx_1", "opt-Lpx" },
	};
	for (const auto &p : opt_scenarios)
	{
		const auto &scen = p.first;

		printf("* %s\n", scen.c_str());

		TFile *f_in_none = TFile::Open("../../data/version15-test8/2018_postTS2/proton_reco_optics/optics_none_1_opt_fun.root");
		TFile *f_in_scen = TFile::Open(("../../data/version15-test8/2018_postTS2/proton_reco_optics/optics_" + scen + "_opt_fun.root").c_str());

		gDirectory = f_out->mkdir(p.second.c_str());

		MakeSingleRPCurvesOpt(f_in_none, f_in_scen, 103, "single rp-103");
		MakeSingleRPCurvesOpt(f_in_none, f_in_scen, 123, "single rp-123");

		MakeMultiRPCurvesOpt(f_in_none, f_in_scen, 103, 123, "multi rp-1");

		delete f_in_none;
		delete f_in_scen;
	}

	// alignment scenarios
	struct AlignmentScenario
	{
		string name;
		double de_x_N; // in cm
		double de_x_F; // in cm
	};

	map<string, AlignmentScenario> alig_scenarios = {
		{ "alig-x-sym", { "x_sym", +150E-4, +150E-4 } },
		{ "alig-x-asym", { "x_asym", -10E-4, +10E-4 } },
	};

	for (const auto &p : alig_scenarios)
	{
		const auto &scen = p.first;

		printf("* %s\n", scen.c_str());

		TFile *f_in_opt = TFile::Open("../../data/version15-test8/2018_postTS2/proton_reco_optics/optics_none_1_opt_fun.root");

		gDirectory = f_out->mkdir(scen.c_str());

		MakeSingleRPCurvesAlig(f_in_opt, 103, p.second.de_x_N, "single rp-103");
		MakeSingleRPCurvesAlig(f_in_opt, 123, p.second.de_x_F, "single rp-123");

		MakeMultiRPCurvesAlig(f_in_opt, 103, 123, p.second.de_x_N, p.second.de_x_F, "multi rp-1");

		delete f_in_opt;
	}


	delete f_out;

	return 0;
}
