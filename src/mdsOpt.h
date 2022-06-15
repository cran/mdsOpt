#ifdef WIN32
#define MDS_OPT_API __declspec(dllexport)

extern "C" void MDS_OPT_API sphgrad(double *grad, double *X, double *r, double *D, double *ldm, double *udm, double *ldiss, double *udiss, int *N, int *P);
extern "C" void MDS_OPT_API  mmSph(double *X, double *r, double *str, double *ldist, double *udist, double *ldiss, double *udiss, double *eps, int *relax, int *dilation, int *N, int *P, int *maxit, int *report);
extern "C" void MDS_OPT_API bidist(double *X, double *R, double *ldist, double *udist, int *N, int *P);
extern "C" void MDS_OPT_API boxobj(double *str, double *X, double *R, double *ldiss, double *udiss, int *N, int *P);	
extern "C" void MDS_OPT_API boxgrad(double *grad, double *X, double *R, double *ldiss, double *udiss, int *N, int *P);
extern "C" void MDS_OPT_API mmBox(double *X, double *R, double *str, double *ldist, double *udist, double *ldiss, double *udiss, double *eps, int *relax, int *dilation, int *N, int *P, int *maxit, int *report);

#else
extern "C" void sphgrad(double *grad, double *X, double *r, double *D, double *ldm, double *udm, double *ldiss, double *udiss, int *N, int *P);
extern "C" void mmSph(double *X, double *r, double *str, double *ldist, double *udist, double *ldiss, double *udiss, double *eps, int *relax, int *dilation, int *N, int *P, int *maxit, int *report);
extern "C" void bidist(double *X, double *R, double *ldist, double *udist, int *N, int *P);
extern "C" void boxobj(double *str, double *X, double *R, double *ldiss, double *udiss, int *N, int *P);	
extern "C" void boxgrad(double *grad, double *X, double *R, double *ldiss, double *udiss, int *N, int *P);
extern "C" void mmBox(double *X, double *R, double *str, double *ldist, double *udist, double *ldiss, double *udiss, double *eps, int *relax, int *dilation, int *N, int *P, int *maxit, int *report);

#endif
