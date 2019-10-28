import root;
import pad_layout;
include "../settings.asy";

string topDir = "../../../data/" + version + "/" + period + "/proton_reco_efficiency/";

string scenarios[], sce_labels[];
scenarios.push("no_cut"); sce_labels.push("no association");
scenarios.push("default"); sce_labels.push("default settings");

if (find(period, "2016") >= 0)
{
	scenarios.push("xi_0.005"); sce_labels.push("$|\De\xi| < 0.005$");
	scenarios.push("xi_0.010"); sce_labels.push("$|\De\xi| < 0.010$");
	scenarios.push("xi_0.015"); sce_labels.push("$|\De\xi| < 0.015$");

	scenarios.push("xi_0.013_th_y_200"); sce_labels.push("$|\De\xi| < 0.013$ AND $|\De\th^*_y| < 200\un{\mu rad}$");
	scenarios.push("xi_0.013_th_y_500"); sce_labels.push("$|\De\xi| < 0.013$ AND $|\De\th^*_y| < 500\un{\mu rad}$");
}

if (find(period, "2017") >= 0)
{
	scenarios.push("xi_0.010"); sce_labels.push("$|\De\xi| < 0.010$");
	scenarios.push("xi_0.015"); sce_labels.push("$|\De\xi| < 0.015$");
	scenarios.push("xi_0.020"); sce_labels.push("$|\De\xi| < 0.020$");

	scenarios.push("xi_0.015_th_y_20"); sce_labels.push("$|\De\xi| < 0.015$ AND $|\De\th^*_y| < 20\un{\mu rad}$");
	scenarios.push("xi_0.015_th_y_100"); sce_labels.push("$|\De\xi| < 0.015$ AND $|\De\th^*_y| < 100\un{\mu rad}$");
}

if (find(period, "2018") >= 0)
{
	scenarios.push("xi_0.010"); sce_labels.push("$|\De\xi| < 0.010$");
	scenarios.push("xi_0.013"); sce_labels.push("$|\De\xi| < 0.013$");

	scenarios.push("xi_0.013_th_y_10"); sce_labels.push("$|\De\xi| < 0.013$ AND $|\De\th^*_y| < 10\un{\mu rad}$");
	scenarios.push("xi_0.013_th_y_20"); sce_labels.push("$|\De\xi| < 0.013$ AND $|\De\th^*_y| < 20\un{\mu rad}$");
	scenarios.push("xi_0.013_th_y_50"); sce_labels.push("$|\De\xi| < 0.013$ AND $|\De\th^*_y| < 50\un{\mu rad}$");
}


string n_particles[];
n_particles.push("1");
n_particles.push("2");
n_particles.push("3");
n_particles.push("4");
n_particles.push("5");

//----------------------------------------------------------------------------------------------------

NewPad(false);
for (int ai : arms.keys)
	NewPadLabel(a_labels[ai]);

for (int scei : scenarios.keys)
{
	NewRow();

	NewPadLabel(sce_labels[scei]);

	for (int ai : arms.keys)
	{
		NewPad("$\xi$", "efficiency");

		for (int npi : n_particles.keys)
		{
			pen p = StdPen(npi+1);

			string f = topDir + scenarios[scei] + "/merged.root";
			RootObject prof = RootGetObject(f, arms[ai] + "/" + n_particles[npi] + "/p_eff_vs_xi", error=false);

			if (prof.valid)
				draw(prof, "vl,eb", p);
		}

		limits((0, 0), (0.2, 1.), Crop);
	}
}

NewPad(false);
AddToLegend("<protons in acceptance");
for (int npi : n_particles.keys)
	AddToLegend(n_particles[npi], StdPen(npi+1));
AttachLegend();
