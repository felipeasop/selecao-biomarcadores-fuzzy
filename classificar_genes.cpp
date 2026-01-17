#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
String classificar_gene(double x, NumericVector quartis_gene) {
    double min = quartis_gene[0];
    double q1 = quartis_gene[1];
    double q2 = quartis_gene[2];
    double q3 = quartis_gene[3];
    double max = quartis_gene[4];
    
    if (min == max) return "BAIXO";
    
    double baixo = 0, medio = 0, alto = 0;
    
    if(x >= min && x <= q1 && q1 > min) baixo = (x - min) / (q1 - min);
    else if (x > q1 && x <= q2 && q2 > q1) baixo = (q2 - x) / (q2 - q1);
    
    if (x >= q1 && x <= q2 && q2 > q1) medio = (x - q1) / (q2 - q1);
    else if (x > q2 && x <= q3 && q3 > q2) medio = (q3 - x) / (q3 - q2);
    
    if (x >= q2 && x <= q3 && q3 > q2) alto = (x - q2) / (q3 - q2);
    else if (x > q3 && x <= max && max > q3) alto = (max - x) / (max - q3);
    
    if(baixo >= medio && baixo >= alto) return "BAIXO";
    else if(medio >= alto) return "MEDIO";
    else return "ALTO";
}