#include "TF2.h"
#include "TGraph.h"

//----------------------------------------------------------------------------------------------------

TGraph* Invert(TGraph *g_in)
{
	TGraph *g_out = new TGraph();

	for (int i = 0; i < g_in->GetN(); ++i)
	{
		const auto &x = g_in->GetX()[i];
		const auto &y = g_in->GetY()[i];

		g_out->SetPoint(i, y, x);
	}

	return g_out;
}

//----------------------------------------------------------------------------------------------------

void GetLinearApproximation(TGraph *g, double x, double &a, double &b)
{
	const double x1 = x;
	const double x2 = x + 0.001;

	const double y1 = g->Eval(x1);
	const double y2 = g->Eval(x2);

	b = (y2 - y1) / (x2 - x1);
	a = y1 - b * x1;
}

//----------------------------------------------------------------------------------------------------

// 2018
//if (arm == "arm0") return "-(8.44219E-07*[xangle]-0.000100957)+(([xi]<(0.000247185*[xangle]+0.101599))*-(1.40289E-05*[xangle]-0.00727237)+([xi]>=(0.000247185*[xangle]+0.101599))*-(0.000107811*[xangle]-0.0261867))*([xi]-(0.000247185*[xangle]+0.101599))";
TF2 *f_aperture = new TF2("aperture", "-(-4.74758E-07*[xangle]+3.0881E-05)+(([xi]<(0.000727859*[xangle]+0.0722653))*-(2.43968E-05*[xangle]-0.0085461)+([xi]>=(0.000727859*[xangle]+0.0722653))*-(7.19216E-05*[xangle]-0.0148267))*([xi]-(0.000727859*[xangle]+0.0722653))");

double GetApertureLimit(double xi)
{
	f_aperture->SetParameter("xangle", 140);
	f_aperture->SetParameter("xi", xi);
	return - f_aperture->EvalPar(nullptr); // returns theta*_x in CMS coordinates
}

//----------------------------------------------------------------------------------------------------

const double si_thx = 67E-6;

double GetMeanThX(double xi)
{
	const double thx_max = GetApertureLimit(xi);

	double sw = 0., stw = 0.;
	for (double thx = -300E-6; thx <= +300E-6; thx += 1E-6)
	{
		if (thx > thx_max)
			continue;

		const double w = exp(-pow(thx/si_thx, 2.) / 2.);
		
		sw += w;
		stw += thx * w;
	}

	if (sw <= 0.)
		return 999E3;

	return stw / sw;
}

//----------------------------------------------------------------------------------------------------

double GetRMSThX(double xi)
{
	const double thx_mean = GetMeanThX(xi);

	const double thx_max = GetApertureLimit(xi);

	double sw = 0., sdsw = 0.;
	for (double thx = -300E-6; thx <= +300E-6; thx += 1E-6)
	{
		if (thx > thx_max)
			continue;

		const double w = exp(-pow(thx/si_thx, 2.) / 2.);

		const double ds = pow(thx - thx_mean, 2.);
		
		sw += w;
		sdsw += ds * w;
	}

	if (sw <= 0.)
		return 999E3;

	const double si_sq = sdsw / sw;
	const double si = (si_sq > 0.) ? sqrt(si_sq) : 0.;

	return si;
}